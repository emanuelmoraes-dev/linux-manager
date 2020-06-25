#!/bin/bash

# Mostra mensagem de ajuda com a descrição de todas as opções
function helpout {
    echo "Linux-Manager@$VERSION"
    echo
    echo "Disponibiliza um conjunto de ferramentas para automatizar e organizar as"
    echo "atividades realizadas e a serem realizadas em um sistema operacional linux"
    echo
    echo "Parâmetros Nomeados:"
    echo "    --help: Mostra mensagem de ajuda com a descrição de todas as opções"
    echo "    --version: Mostra a versão atual"
    echo "    task: Cria uma nova tarefa"
    echo
    if [ "$1" = "--autor" ]; then
        echo "Autor: Emanuel Moraes de Almeida"
        echo "Email: emanuelmoraes297@gmail.com"
        echo "Github: https://github.com/emanuelmoraes-dev"
        echo
    fi
}

function logerr {
    local message="$@"
    printf >&2 "${ERROR_THEME}\n${message}${END_COLOR}\n"
}

# Ecoa mensagem de erro em erro padrão e código do erro em saída padrão
#
# Parâmetros:
#     -v: Mostra mensagem de ajuda com a descrição de todas as opções
#
#EX: m="Erro interno! Algo inesperado ocorreu" e=100 helperr -v
function helperr {
    local err="$?"

    if [ -z "$err" ] || [ "$err" = "0" ]; then
        err=$ERR_UNEXPECTED
    fi

    if [ "$e" ]; then
        err=$e
    fi

    local message="$m"

    if [ -z "$message" ]; then
        message="Erro interno! Algo inesperado ocorreu!"
    fi

    if [ "$1" == "-v" ]; then
        helpout >&2
    fi

    logerr "$message [Código do erro: $err]"
    echo $err
}

# Transforma path relativo em path absoluto
function to_absolute {
	local rt="$1"

	if [ -f "$rt"  ] && [[ "$rt" != /*  ]]; then
	    if [ "$(pwd)" = "/"  ]; then
	        rt="/$rt"
	    else
	        rt="$(pwd)/$rt"
	    fi
	fi

	echo "$rt"
}

