# Deck Report

Ferramenta de campo para reportar problemas da área do deck em casas de temporada.

Escolhe a casa, marca o que está quebrado, tira a foto (o endereço e a hora ficam
carimbados na imagem) e sai a mensagem pronta para o WhatsApp. Problema repetido na
mesma casa vem com a contagem — "3rd report at this address (1st: Aug 12)".

Arquivo único, sem servidor e sem banco. Tudo fica no aparelho de quem usa.

## Privacidade

Este repositório **não contém endereço nenhum**. A lista de casas entra pelo link
privado (`LINK-PRIVADO.txt`, fora do repositório) e fica só no celular.

## Publicar

    gh auth login
    ./publicar.sh
