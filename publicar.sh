#!/usr/bin/env bash
set -e
REPO="${1:-deck-report}"

command -v gh >/dev/null || { echo "gh nao encontrado"; exit 1; }
gh auth status >/dev/null 2>&1 || { echo "Rode primeiro:  gh auth login"; exit 1; }

USER=$(gh api user --jq .login)
echo "Conta: $USER"

if gh repo view "$USER/$REPO" >/dev/null 2>&1; then
  echo "Repositorio ja existe. Enviando mudancas..."
  git push
else
  gh repo create "$REPO" --public --source=. --remote=origin --push \
    --description "Deck Report — ferramenta de campo para reportar problemas do deck"
  echo "Ligando o GitHub Pages..."
  gh api --method POST "repos/$USER/$REPO/pages" \
    -f "source[branch]=main" -f "source[path]=/" >/dev/null 2>&1 \
    || echo "(Pages talvez ja estivesse ligado)"
fi

echo
echo "Endereco do app:"
echo "  https://$USER.github.io/$REPO/"
echo
echo "Abra UMA VEZ no iPhone o link de LINK-PRIVADO.txt (troque SEU-USUARIO por $USER)"
echo "para carregar as 23 casas. Leva ate 2 minutos para o Pages ficar no ar."
