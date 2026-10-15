# My Skills

A idéia deste repo é facilitar a instalação das minhas skills mais utilizadas, independente da ferramenta (Claude Code, AGY CLI, ...).

## Estrutura

```
skills/
  <nome-da-skill>/
    SKILL.md        # obrigatório; "name" no frontmatter = nome da pasta
    ...             # scripts, referências e assets opcionais
targets.txt         # onde cada ferramenta procura skills
install.ps1         # instalador para Windows (junctions)
install.sh          # instalador para Linux/macOS (symlinks)
```

## Instalação numa máquina nova

Clone num **disco local** (junctions do Windows não funcionam em unidades de rede):

```bash
git clone <url-do-repo> ~/my-skills
```

Windows (PowerShell):

```powershell
~\my-skills\install.ps1
```

Linux/macOS:

```bash
~/my-skills/install.sh
```

O script cria um link de cada skill para a pasta de skills de cada ferramenta instalada
(ex. `~/.claude/skills/project-idea-calibrator` → `~/my-skills/skills/project-idea-calibrator`).
Por serem links, editar a skill no repositório ou dar `git pull` já atualiza todas as ferramentas.

Instalou uma ferramenta nova depois? Rode o script de novo: ele pula o que já está linkado.

### Opções

| PowerShell        | Bash              | O que faz                                                   |
| ----------------- | ----------------- | ----------------------------------------------------------- |
| `-All`            | `--all`           | Instala mesmo nas ferramentas que não foram encontradas     |
| `-Only a,b`       | `--only a,b`      | Só nos alvos indicados (nomes de `targets.txt`)             |
| `-Force`          | `--force`         | Substitui skill de mesmo nome que não veio deste repositório |
| `-Copy`           | `--copy`          | Copia em vez de linkar (rode de novo após cada `git pull`)  |
| `-Uninstall`      | `--uninstall`     | Remove apenas o que este repositório instalou               |
| `-WhatIf`         | `--dry-run`       | Mostra o que seria feito                                    |

## Adicionando uma ferramenta

Acrescente uma linha em `targets.txt`:

```
nome | pasta da ferramenta | pasta de skills
```

Os caminhos atuais de Gemini CLI e Antigravity variam entre versões; se uma skill não aparecer,
confira a documentação da ferramenta e ajuste a linha.

## Adicionando uma skill

1. Crie `skills/<nome>/SKILL.md` com `name: <nome>` e uma `description` dizendo quando usar.
2. Rode o instalador (só necessário para skills novas; edições já aparecem pelos links).
