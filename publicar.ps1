# Publica o Deck Report no GitHub Pages.
# Uso:  .\publicar.ps1          (repositorio "deck-report")
#       .\publicar.ps1 outronome

param([string]$Repo = "deck-report")

$ErrorActionPreference = "Stop"

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
  Write-Host "gh nao encontrado. Instale o GitHub CLI." -ForegroundColor Red; exit 1
}

gh auth status 2>&1 | Out-Null
if (-not $?) {
  Write-Host "Voce ainda nao esta logado. Rode primeiro:" -ForegroundColor Yellow
  Write-Host "    gh auth login" -ForegroundColor Cyan
  exit 1
}

$user = (gh api user --jq .login).Trim()
Write-Host "Conta: $user"

gh repo view "$user/$Repo" 2>&1 | Out-Null
if ($?) {
  Write-Host "Repositorio ja existe. Enviando mudancas..."
  git push
} else {
  gh repo create $Repo --public --source=. --remote=origin --push --description "Deck Report - ferramenta de campo para reportar problemas do deck"
  Write-Host "Ligando o GitHub Pages..."
  try {
    gh api --method POST "repos/$user/$Repo/pages" -f "source[branch]=main" -f "source[path]=/" | Out-Null
  } catch {
    Write-Host "(Pages talvez ja estivesse ligado)"
  }
}

Write-Host ""
Write-Host "Endereco do app:" -ForegroundColor Green
Write-Host "  https://$user.github.io/$Repo/" -ForegroundColor Cyan
Write-Host ""
Write-Host "Abra UMA VEZ no iPhone o link de LINK-PRIVADO.txt (troque SEU-USUARIO por $user)"
Write-Host "para carregar as 23 casas. O Pages pode levar ate 2 minutos para ficar no ar."
