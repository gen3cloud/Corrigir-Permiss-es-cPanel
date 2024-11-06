#!/bin/bash
# Licença: GNU General Public License v3.0
# Veja a página do Github para a licença completa e observações:
# https://github.com/PeachFlame/cPanel-fixperms

# Ativa modo de erro para garantir que falhe ao encontrar um erro
set -e

# Definir verbose como nulo
verbose=""

# Função de ajuda
ajuda () {
    tput bold
    tput setaf 2
    echo "Script para Corrigir Permissões (fixperms):"
    echo "Define permissões de arquivos/diretórios para corresponder aos esquemas do suPHP e FastCGI."
    echo "USO: fixperms [opções] -a nome_da_conta"
    echo "-------"
    echo "Opções:"
    echo "-h ou --help: Exibe esta tela e sai"
    echo "--account ou -a: Especifica uma conta cPanel"
    echo "-all: Executa em todas as contas cPanel"
    echo "-v: Saída detalhada"
    tput sgr0
    exit 0
}

# Função principal para corrigir permissões de arquivos
corrigir_permissoes () {
    # Conta passada para a função
    conta=$1
    
    # Verifica se a conta existe nos arquivos de usuário do cPanel
    if ! grep -q $conta /var/cpanel/users/*; then
        tput bold
        tput setaf 1
        echo "Conta cPanel inválida!"
        tput sgr0
        exit 1
    fi

    # Verifica se a conta está vazia
    if [ -z "$conta" ]; then
        tput bold
        tput setaf 1
        echo "É necessário fornecer uma conta cPanel!"
        tput sgr0
        ajuda
    else
        # Obtém o diretório home da conta
        HOMEDIR=$(getent passwd "$conta" | cut -d: -f6)

        tput bold
        tput setaf 4
        echo "(fixperms) para: $conta"
        tput setaf 3
        echo "--------------------------"
        tput setaf 4
        echo "Corrigindo arquivos do site..."
        tput sgr0

        # Corrige o dono do diretório public_html
        chown -R $verbose $conta:$conta $HOMEDIR/public_html

        # Corrige permissões de arquivos e diretórios em public_html
        find $HOMEDIR/public_html -type d -exec chmod $verbose 755 {} \;
        find $HOMEDIR/public_html -type f -exec chmod $verbose 644 {} \;
        find $HOMEDIR/public_html -name '*.cgi' -o -name '*.pl' -exec chmod $verbose 755 {} \;

        # Corrige arquivos e pastas ocultos como .well-known/
        chown -R $verbose $conta:$conta $HOMEDIR/public_html/.[^.]*
        find $HOMEDIR/* -name .htaccess -exec chown $verbose $conta:$conta {} \;

        tput bold
        tput setaf 4
        echo "Corrigindo public_html..."
        tput sgr0
        # Corrige permissões do próprio public_html
        chown $verbose $conta:nobody $HOMEDIR/public_html
        chmod $verbose 750 $HOMEDIR/public_html

        # Corrige subdomínios fora do public_html
        tput setaf 3
        tput bold
        echo "--------------------------"
        tput setaf 4
        echo "Corrigindo domínios com docroot fora de public_html..."
        for SUBDOMINIO in $(grep -i documentroot /var/cpanel/userdata/$conta/* | grep -v '.cache\|_SSL' | awk '{print $2}' | grep -v public_html); do
            tput bold
            tput setaf 4
            echo "Corrigindo docroot de subdomínio $SUBDOMINIO..."
            tput sgr0
            chown -R $verbose $conta:$conta $SUBDOMINIO
            find $SUBDOMINIO -type d -exec chmod $verbose 755 {} \;
            find $SUBDOMINIO -type f -exec chmod $verbose 644 {} \;
            find $SUBDOMINIO -name '*.cgi' -o -name '*.pl' -exec chmod $verbose 755 {} \;
            chown -R $verbose $conta:$conta $SUBDOMINIO
            chmod $verbose 755 $SUBDOMINIO
            find $SUBDOMINIO -name .htaccess -exec chown $verbose $conta:$conta {} \;
        done

        # Finalização
        tput bold
        tput setaf 3
        echo "Finalizado! (Usuário: $conta)"
        echo "--------------------------"
        tput sgr0
    fi
}

# Função para corrigir permissões de todas as contas cPanel
corrigir_todas () {
    for usuario in $(cut -d: -f1 /etc/domainusers); do
        corrigir_permissoes $usuario
    done
}

# Função principal que lida com as opções passadas
case "$1" in
    -h|--help) ajuda ;;
    -v) verbose="-v" ;;
    -all) corrigir_todas ;;
    --account| -a) corrigir_permissoes "$2" ;;
    *)
        tput bold
        tput setaf 1
        echo "Opção inválida!"
        ajuda
    ;;
esac
