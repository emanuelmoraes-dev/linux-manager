#!/bin/bash

VERSION=0.0.1

# Linux-Manager@0.0.1
#
# Disponibiliza um conjunto de ferramentas para automatizar e organizar as
# atividades realizadas e a serem realizadas em um sistema operacional linux
#
# Parâmetros Nomeados:
#     --help: Mostra todas as opções
#     --version: Mostra a versão atual
#     task: Cria uma nova tarefa
#
# Autor: Emanuel Moraes de Almeida
# Email: emanuelmoraes297@gmail.com
# Github: https://github.com/emanuelmoraes-dev

[ -z "$DIRNAME" ] && DIRNAME="$(dirname "$0")"

source "$DIRNAME/env.sh"
source "$DIRNAME/util.sh"

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

# Realiza as configurações necessárias no início da execução do programa
function config {
    mkdir -p $DATA_FOLDER/$TASK_FOLDER &&
    mkdir -p $DATA_FOLDER/$TASK_RUNNER_FOLDER &&
    mkdir -p $DATA_FOLDER/$INFO_FOLDER ||
    return $?
}

# processa os parâmetros de task
function task_parameters {
	local task_up=1 &&
	local task_script_path &&
	task_type=script &&
	task_version=1 &&
	task_name= &&
	task_message= &&

	while [ "$#" != 0 ]; do
		case "$1" in
			--name|-n) task_name="$2" && shift;;
			--message|-m) task_message="$2" && shift;;
			--type|-t) task_type="$2" && shift;;
			--version|-v) task_version="$2" && shift;;
			--path|-p)
				task_script_path="$2" &&
				shift &&
				task_script_path="$(to_absolute "$task_script_path")" &&
				if [ "$task_up" = 1 ]; then
					task_script_content_up="$(cat "$task_script_path")"
				else
					task_script_content_down="$(cat "$task_script_path")"
				fi;;
			--up|-u) task_up=1;;
			--down|-d) task_up=0;;
			@)
				if [ "$task_up" = 1 ]; then
					task_script_content_up="$2"
				else
					task_script_content_down="$2"
				fi &&
				shift;;
			*) return $ERR_INVALID_TASK_ARG
		esac &&
		shift ||
		return $?
	done &&

	if [ -z "$task_name" ]; then
		return $ERR_REQUIRE_TASK_NAME
	fi &&

	if (
		[ "$task_type" = "script" ] &&
		[ -z "$task_script_content_up" ] &&
		! [ -f "$task_folder/$TASK_SCRIPT_NAME_UP" ]
	); then
		return $ERR_REQUIRE_TASK_SCRIPT_CONTENT
	fi ||

	return $?
}

# Cria uma tarefa do tipo "script"
function create_task_script {
	local task_folder="$DATA_FOLDER/$TASK_FOLDER/$task_name/$task_version" &&
	mkdir -p "$task_folder" &&
	printf "$task_type" > "$task_folder/$TASK_TYPE_FILENAME" &&
	printf "$task_name" > "$task_folder/$TASK_NAME_FILENAME" &&
	printf "$task_message" > "$task_folder/$TASK_MESSAGE_FILENAME" &&

	if [ "$task_script_content_up" ]; then
		printf "$task_script_content_up" > "$task_folder/$TASK_SCRIPT_NAME_UP" &&
		chmod +x "$task_folder/$TASK_SCRIPT_NAME_UP"
	fi &&

	if [ "$task_script_content_down" ]; then
		printf "$task_script_content_down" > "$task_folder/$TASK_SCRIPT_NAME_DOWN" &&
		chmod +x "$task_folder/$TASK_SCRIPT_NAME_DOWN"
	fi ||

	return $?
}

# Manipula a criação de uma tarefa pelos argumentos
function task {
	task_parameters "$@" &&

	case "$task_type" in
		script) create_task_script;;
		*) return $ERR_INVALID_TASK_TYPE;;
	esac ||

	return $?
}

# Processa os parâmetros passados pelo usuário
function apply_parameters {
	if [ "$#" = 0 ]; then
		helpout --autor &&
		return 0
	fi &&

    while [ "$#" != 0 ]; do
        case "$1" in
            --help) helpout --autor && return 0;;
            --version) echo "version: $VERSION" && return 0;;
            task) shift && task "$@" && break;;
            *) return $ERR_INVALID_ARG;;
        esac &&
        shift ||
        return $?
    done ||
	return $?
}

# Função principal
function main {
	local err &&
	config &&
	apply_parameters "$@" || (
		err=$?
		case "$err" in
			$ERR_INVALID_ARG) return $(m="Erro: Argumento inválido!" e=$err helperr -v);;
			$ERR_INVALID_TASK_TYPE) return $(m="Erro: tipo de tarefa inválida!" e=$err helperr);;
			$ERR_INVALID_TASK_ARG) return $(m="Erro: Argumento de tarefa inválido!" e=$err helperr);;
			$ERR_REQUIRE_TASK_NAME) return $(m="Erro: O nome da tarefa é obrigatório!" e=$err helperr);;
			$ERR_REQUIRE_TASK_SCRIPT_CONTENT) return $(m="Erro: Uma tarefa do tipo \"script\" deve possuir um script!" e=$err helperr);;
			*) return $(helperr);;
		esac
	)
}

main "$@" # Executa a função principal
