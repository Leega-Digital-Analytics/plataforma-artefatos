#!/usr/bin/env bash
# verificar-referencias.sh <pasta-do-artefato>
# Confere as referências locais (src, href, poster e url() em .html, .htm e .css)
# de um artefato antes de compartilhar. Falha (exit 1) quando uma referência:
#   - sai da pasta do artefato (ex.: ../../wiki/assets/logo.png), ou
#   - aponta para arquivo que não existe dentro da pasta.
# Ignora URLs absolutas (http, https, //), data:, mailto:, tel:, javascript: e âncoras (#).
# Uso: bash verificar-referencias.sh artefatos/<nome>
set -u

RAIZ_ARG="${1:-}"
[ -n "$RAIZ_ARG" ] && [ -d "$RAIZ_ARG" ] || { printf 'uso: %s <pasta-do-artefato>\n' "$0" >&2; exit 2; }
RAIZ="$(cd "$RAIZ_ARG" && pwd -P)"

PROBLEMAS=0
VERIFICADAS=0

reportar() { printf '  %s: %s (%s)\n' "$1" "$2" "$3"; PROBLEMAS=$((PROBLEMAS + 1)); }

while IFS= read -r -d '' ARQ; do
  DIR="$(cd "$(dirname "$ARQ")" && pwd -P)"
  REL_ARQ="${ARQ#"$RAIZ_ARG"/}"
  while IFS= read -r REF; do
    REF="${REF#[\"\']}"; REF="${REF%[\"\']}"
    [ -n "$REF" ] || continue
    case "$REF" in
      http:*|https:*|//*|data:*|mailto:*|tel:*|javascript:*|'#'*|'$'*|'{'*) continue ;;
    esac
    ALVO="${REF%%#*}"; ALVO="${ALVO%%\?*}"
    [ -n "$ALVO" ] || continue
    VERIFICADAS=$((VERIFICADAS + 1))
    case "$ALVO" in
      /*) reportar "$REL_ARQ" "$REF" "caminho absoluto: use caminho relativo dentro da pasta do artefato"; continue ;;
    esac
    CAMINHO="$DIR/$ALVO"
    if [ ! -e "$CAMINHO" ]; then
      case "$ALVO" in
        ../*|*/../*) reportar "$REL_ARQ" "$REF" "sai da pasta do artefato e não existe nela" ;;
        *) reportar "$REL_ARQ" "$REF" "arquivo não encontrado na pasta do artefato" ;;
      esac
      continue
    fi
    if [ -d "$CAMINHO" ]; then
      FISICO="$(cd "$CAMINHO" && pwd -P)"
    else
      FISICO="$(cd "$(dirname "$CAMINHO")" && pwd -P)/$(basename "$CAMINHO")"
    fi
    case "$FISICO" in
      "$RAIZ"|"$RAIZ"/*) : ;;
      *) reportar "$REL_ARQ" "$REF" "sai da pasta do artefato: copie o arquivo para dentro dela (ex.: assets/) e ajuste o caminho" ;;
    esac
  done < <(
    grep -oiE '[[:space:]](src|href|poster)[[:space:]]*=[[:space:]]*"[^"]*"' "$ARQ" 2>/dev/null \
      | sed -E 's/^[^"]*"([^"]*)"$/\1/'
    grep -oiE "[[:space:]](src|href|poster)[[:space:]]*=[[:space:]]*'[^']*'" "$ARQ" 2>/dev/null \
      | sed -E "s/^[^']*'([^']*)'\$/\1/"
    grep -oiE 'url\([[:space:]]*[^)]*\)' "$ARQ" 2>/dev/null \
      | sed -E 's/^url\([[:space:]]*//; s/[[:space:]]*\)$//'
  )
done < <(find "$RAIZ_ARG" -type f \( -iname '*.html' -o -iname '*.htm' -o -iname '*.css' \) -not -path '*/origem/*' -not -path '*/dados-cliente/*' -print0)

if [ "$PROBLEMAS" -gt 0 ]; then
  printf 'verificar-referencias: %d problema(s) em %d referência(s) local(is). Corrija antes de compartilhar.\n' "$PROBLEMAS" "$VERIFICADAS" >&2
  exit 1
fi
printf 'verificar-referencias: %d referência(s) local(is), todas dentro da pasta do artefato.\n' "$VERIFICADAS"
exit 0
