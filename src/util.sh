#!/usr/bin/env bash

function logerr {
    local message="$@"
    printf >&2 "${LMG_ERROR_THEME}\n%s${LMG_END_COLOR}\n" "$message"
}

# Ecoa mensagem de erro em erro padrão e código do erro em saída padrão
#
# Parâmetros:
#     -v: Mostra mensagem de ajuda com a descrição de todas as opções
#
# Ex: m="Erro interno! Algo inesperado ocorreu" e=100 helperr -v
function helperr {
    local err="$?"

    if [ -z "$err" ] || [ "$err" = "0" ]; then
        err=$LMG_ERR_UNEXPECTED
    fi

    if [ "$e" ]; then
        err=$e
    fi

    local message="$m"

    if [ -z "$message" ]; then
        message="$LMG_ERR_UNEXPECTED_MESSAGE"
    fi

    if [ "$1" == "-v" ]; then
        helpout >&2
    fi

    local sufix="$(printf "$LMG_SUFIX_ERR" "$err")"

    logerr "${message}${sufix}"
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

