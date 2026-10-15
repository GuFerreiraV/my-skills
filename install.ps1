<#
.SYNOPSIS
  Instala (ou remove) as skills deste repositório nas ferramentas de IA listadas em targets.txt.

.DESCRIPTION
  Para cada skill em .\skills\<nome>\SKILL.md cria uma junction em <pasta de skills>\<nome>
  apontando para o repositório. Assim, um "git pull" atualiza todas as ferramentas de uma vez.
  Junctions não exigem admin, mas só funcionam com o repositório em disco local; se ele estiver
  num caminho de rede, as skills são copiadas (rode o script de novo após cada "git pull").

.EXAMPLE
  .\install.ps1               # instala nas ferramentas encontradas
  .\install.ps1 -All          # instala em todas as pastas de targets.txt
  .\install.ps1 -Only claude,codex
  .\install.ps1 -Force        # substitui skills de mesmo nome que não vieram daqui
  .\install.ps1 -Uninstall    # remove só o que este repositório instalou
  .\install.ps1 -WhatIf       # mostra o que seria feito
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [switch]$All,
    [string[]]$Only,
    [switch]$Force,
    [switch]$Uninstall,
    [switch]$Copy
)

$ErrorActionPreference = 'Stop'
$repo = $PSScriptRoot
$skillsDir = Join-Path $repo 'skills'

function Expand-Home([string]$path) {
    if ($path -like '~*') { $path = Join-Path $HOME $path.Substring(1).TrimStart('/', '\') }
    return [IO.Path]::GetFullPath($path)
}

function Get-LinkTarget([string]$path) {
    $item = Get-Item -LiteralPath $path -Force -ErrorAction SilentlyContinue
    if ($item -and $item.LinkType) { return [string]($item.Target | Select-Object -First 1) }
    return $null
}

# Marca cópias para que o -Uninstall saiba que vieram deste repositório.
$marker = '.installed-from-my-skills'

$isNetwork = ([Uri]$repo).IsUnc -or ((Get-PSDrive -Name $repo.Substring(0, 1) -ErrorAction SilentlyContinue).DisplayRoot -like '\\*')
if ($isNetwork -and -not $Copy) {
    Write-Warning "Repositório em caminho de rede ($repo): junctions não funcionam, usando cópia."
    $Copy = $true
}

$targets = Get-Content (Join-Path $repo 'targets.txt') |
    Where-Object { $_.Trim() -and -not $_.TrimStart().StartsWith('#') } |
    ForEach-Object {
        $name, $tool, $dest = $_.Split('|') | ForEach-Object { $_.Trim() }
        [pscustomobject]@{ Name = $name; Tool = Expand-Home $tool; Dest = Expand-Home $dest }
    }
if ($Only) { $targets = $targets | Where-Object { $Only -contains $_.Name } }

$skills = Get-ChildItem -LiteralPath $skillsDir -Directory |
    Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'SKILL.md') }

foreach ($t in $targets) {
    if (-not $All -and -not (Test-Path -LiteralPath $t.Tool)) {
        Write-Host "[$($t.Name)] não encontrado ($($t.Tool)), pulando." -ForegroundColor DarkGray
        continue
    }
    Write-Host "[$($t.Name)] $($t.Dest)" -ForegroundColor Cyan
    if (-not $Uninstall -and -not (Test-Path -LiteralPath $t.Dest)) {
        if ($PSCmdlet.ShouldProcess($t.Dest, 'Criar pasta')) { New-Item -ItemType Directory -Path $t.Dest -Force | Out-Null }
    }

    foreach ($s in $skills) {
        $dest = Join-Path $t.Dest $s.Name
        $exists = Test-Path -LiteralPath $dest
        $linkTarget = Get-LinkTarget $dest
        $ours = ($linkTarget -and ([IO.Path]::GetFullPath($linkTarget) -eq $s.FullName)) -or
                (Test-Path -LiteralPath (Join-Path $dest $marker))

        if ($Uninstall) {
            if ($exists -and $ours -and $PSCmdlet.ShouldProcess($dest, 'Remover')) {
                if ($linkTarget) { (Get-Item -LiteralPath $dest -Force).Delete() }
                else { Remove-Item -LiteralPath $dest -Recurse -Force }
                Write-Host "  - $($s.Name)"
            }
            continue
        }

        if ($exists -and -not $ours -and -not $Force) {
            Write-Warning "  $($s.Name): já existe em $dest e não veio deste repositório. Use -Force para substituir."
            continue
        }
        if ($exists -and $linkTarget -and $ours -and -not $Copy) {
            Write-Host "  = $($s.Name) (já linkada)"
            continue
        }
        if (-not $PSCmdlet.ShouldProcess($dest, "Instalar $($s.Name)")) { continue }

        if ($exists) {
            if ($linkTarget) { (Get-Item -LiteralPath $dest -Force).Delete() }
            else { Remove-Item -LiteralPath $dest -Recurse -Force }
        }
        if ($Copy) {
            Copy-Item -LiteralPath $s.FullName -Destination $dest -Recurse
            New-Item -ItemType File -Path (Join-Path $dest $marker) | Out-Null
            Write-Host "  + $($s.Name) (cópia)"
        } else {
            New-Item -ItemType Junction -Path $dest -Target $s.FullName | Out-Null
            Write-Host "  + $($s.Name) -> $($s.FullName)"
        }
    }
}
