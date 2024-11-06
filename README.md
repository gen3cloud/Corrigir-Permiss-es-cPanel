# cPanel FixPerms Script

Este script foi desenvolvido para corrigir as permissões de arquivos e diretórios em contas cPanel de forma eficiente, ajustando as permissões de acordo com os requisitos de segurança, como suPHP e FastCGI. O script pode ser usado para corrigir permissões de uma conta específica ou de todas as contas cPanel em um servidor.

## Funcionalidades

- **Corrigir permissões de arquivos e diretórios** dentro do diretório `public_html` da conta cPanel.
- **Corrigir permissões para subdomínios** com document root fora do diretório `public_html`.
- **Corrigir arquivos ocultos**, como `.htaccess`, `.well-known`, e outros arquivos de configuração.
- **Suporte a contas individuais** ou execução em todas as contas cPanel do servidor.

## Instalação

1. Clone este repositório em seu servidor:

   ```bash
   git clone https://github.com/PeachFlame/cPanel-fixperms.git
   cd cPanel-fixperms
Torne o script executável:
chmod +x fixperms.sh

## Uso

**Sintaxe**

./fixperms.sh [opções] -a nome_da_conta

**Opções**

-h, --help: Exibe a tela de ajuda com as instruções do script.
-a, --account <nome_da_conta>: Corrige permissões de uma conta cPanel específica.
-all: Executa a correção de permissões em todas as contas cPanel do servidor.
-v: Ativa a saída detalhada (verbose), mostrando os comandos executados.

## Exemplos

**Corrigir permissões de uma conta específica:**

./fixperms.sh -a nome_da_conta

**Corrigir permissões de todas as contas:**

./fixperms.sh -all

**Exibir a ajuda:**

./fixperms.sh -h

**Executar com saída detalhada:**

./fixperms.sh -v -a nome_da_conta

## Detalhes Técnicos

**Este script foi projetado para funcionar em servidores cPanel e utiliza os seguintes métodos para corrigir as permissões.**

O script ajusta as permissões dos diretórios para 755 e arquivos para 644.

Arquivos executáveis, como .cgi e .pl, têm permissões de execução 755.

Arquivos ocultos, como .htaccess, são ajustados com permissões específicas.

## Licença

Este projeto está licenciado sob a Licença Pública Geral GNU v3.0.

## Contribuindo

Faça um fork deste repositório.
Crie uma branch para sua modificação (git checkout -b minha-modificacao).
Faça suas alterações e commit (git commit -am 'Adicionando nova funcionalidade').
Envie para o repositório remoto (git push origin minha-modificacao).
Abra um pull request.

## Suporte

Caso encontre algum problema ou tenha dúvidas sobre o uso, abra uma issue.
