#!/usr/bin/env bash
# Instala (ou remove) as skills deste repositório nas ferramentas de IA listadas em targets.txt.
#
# Para cada skill em ./skills/<nome>/SKILL.md cria um symlink em <pasta de skills>/<nome>
# apontando para o repositório. Assim, um "git pull" atualiza todas as ferramentas de uma vez.
#
# Uso:
#   ./install.sh                 instala nas ferramentas encontradas
#   ./install.sh --all           instala em todas as pastas de targets.txt
#   ./install.sh --only claude,codex
#   ./install.sh --force         substitui skills de mesmo nome que não vieram daqui
#   ./install.sh --copy          copia em vez de criar symlinks
#   ./install.sh --uninstall     remove só o que este repositório instalou
#   ./install.sh --dry-run       mostra o que seria feito
#
# No Windows, prefira install.ps1 (symlinks no Git Bash viram cópias sem o modo desenvolvedor).

set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
skills_dir="$repo/skills"
marker=".installed-from-my-skills"

all=0 force=0 copy=0 uninstall=0 dry=0 only=""
while [ $# -gt 0 ]; do
  case "$1" in
    --all) all=1 ;;
    --force) force=1 ;;
    --copy) copy=1 ;;
    --uninstall) uninstall=1 ;;
    --dry-run) dry=1 ;;
    --only) only=",$2,"; shift ;;
    -h|--help) sed -n '2,17p' "$0"; exit 0 ;;
    *) echo "Opção desconhecida: $1" >&2; exit 1 ;;
  esac
  shift
done

run() { if [ "$dry" = 1 ]; then echo "    (dry-run) $*"; else "$@"; fi; }
expand() { local p="$1"; [ "${p#\~}" != "$p" ] && p="$HOME${p#\~}"; echo "$p"; }
trim() { local s="$1"; s="${s#"${s%%[![:space:]]*}"}"; echo "${s%"${s##*[![:space:]]}"}"; }

while IFS='|' read -r name tool dest || [ -n "$name" ]; do
  name="$(trim "$name")"
  case "$name" in ''|\#*) continue ;; esac
  tool="$(expand "$(trim "$tool")")"
  dest="$(expand "$(trim "$dest")")"
  [ -n "$only" ] && [ "${only#*,"$name",}" = "$only" ] && continue

  if [ "$all" = 0 ] && [ ! -d "$tool" ]; then
    echo "[$name] não encontrado ($tool), pulando."
    continue
  fi
  echo "[$name] $dest"
  [ "$uninstall" = 0 ] && [ ! -d "$dest" ] && run mkdir -p "$dest"

  for src in "$skills_dir"/*/; do
    src="${src%/}"
    [ -f "$src/SKILL.md" ] || continue
    skill="$(basename "$src")"
    target="$dest/$skill"
    ours=0
    if [ -L "$target" ] && [ "$(cd "$target" 2>/dev/null && pwd -P)" = "$src" ]; then ours=1
    elif [ -f "$target/$marker" ]; then ours=1; fi

    if [ "$uninstall" = 1 ]; then
      if [ "$ours" = 1 ]; then run rm -rf "$target"; echo "  - $skill"; fi
      continue
    fi

    if [ -e "$target" ] || [ -L "$target" ]; then
      if [ "$ours" = 0 ] && [ "$force" = 0 ]; then
        echo "  ! $skill: já existe em $target e não veio deste repositório. Use --force para substituir." >&2
        continue
      fi
      if [ "$ours" = 1 ] && [ -L "$target" ] && [ "$copy" = 0 ]; then
        echo "  = $skill (já linkado)"
        continue
      fi
      run rm -rf "$target"
    fi

    if [ "$copy" = 1 ]; then
      run cp -R "$src" "$target"
      run touch "$target/$marker"
      echo "  + $skill (cópia)"
    else
      run ln -s "$src" "$target"
      echo "  + $skill -> $src"
    fi
  done
done < "$repo/targets.txt"
