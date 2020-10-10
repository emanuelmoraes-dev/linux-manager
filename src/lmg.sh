#!/usr/bin/env bash

VERSION=0.0.4

# Linux-Manager@0.0.4
#
# Disponibiliza um conjunto de ferramentas para automatizar e organizar as
# atividades realizadas e a serem realizadas em um sistema operacional linux
#
# Parâmetros Nomeados:
#     --help:    Mostra todas as opções
#     --version: Mostra a versão atual
#     up:        Executa uma tarefa
#         --name|-n:    Define o nome da tarefa
#         --version|-v: Define a versão da tarefa
#         --env|-e:     Define o conteúdo (enviroment)
#                       a ser adicionado antes do script
#         --args|-a:    Define os argumentos do script
#     down:      Desfaz a execução de uma tarefa
#         --name|-n:    Define o nome da tarefa
#         --version|-v: Define a versão da tarefa
#         --env|-e:     Define o conteúdo (enviroment)
#                       a ser adicionado antes do script
#         --args|-a:    Define os argumentos do script
#     task:      Cria uma nova tarefa
#         --name|-n:    Define o nome da tarefa
#         --version|-v: Define a versão da tarefa
#         --message|-m: Define a descrição da tarefa
#         --type|-t:    Define o tipo de tarefa (script e info)
#         --path|-p:    Nome do arquivo que contém o conteúdo a
#                       ser copiado para a tarefa
#         @:            Contém o conteúdo da tarefa em formato literal
#         --up|-u:      Define que o próximo --path|-p|@ definirá
#                       o arquivo do conteúdo responsável por fazer
#                       a tarefa
#         --down|-d:    Define que o próximo --path|-p|@ definirá
#                       o arquivo do conteúdo responsável por desfazer
#                       a tarefa
#
# Autor: Emanuel Moraes de Almeida
# Email: emanuelmoraes297@gmail.com
# Github: https://github.com/emanuelmoraes-dev

# Diretório da aplicação
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
	echo "    --help:    Mostra mensagem de ajuda com a descrição de todas as opções"
    echo "    --version: Mostra a versão atual"
    echo "    up:        Executa uma tarefa"
    echo "        --name|-n:    Define o nome da tarefa"
    echo "        --version|-v: Define a versão da tarefa"
    echo "        --env|-e:     Define o conteúdo (enviroment)"
    echo "                      a ser adicionado antes do script"
    echo "        --args|-a:    Define os argumentos do script"
    echo "    down:      Desfaz a execução de uma tarefa"
    echo "        --name|-n:    Define o nome da tarefa"
    echo "        --version|-v: Define a versão da tarefa"
	echo "        --env|-e:     Define o conteúdo (enviroment)"
    echo "                      a ser adicionado antes do script"
    echo "        --args|-a:    Define os argumentos do script"
    echo "    task:      Cria uma nova tarefa"
    echo "        --name|-n:    Define o nome da tarefa"
	echo "        --version|-v: Define a versão da tarefa"
    echo "        --message|-m: Define a descrição da tarefa"
    echo "        --type|-t:    Define o tipo de tarefa (script e info)"
    echo "        --path|-p:    Nome do arquivo que contém o conteúdo a"
    echo "                      ser copiado para a tarefa"
    echo "        @:            Contém o conteúdo da tarefa em formato literal"
    echo "        --up|-u:      Define que o próximo --path|-p|@ definirá"
    echo "                      o arquivo do conteúdo responsável por fazer"
    echo "                      a tarefa"
    echo "        --down|-d:    Define que o próximo --path|-p|@ definirá"
    echo "                      o arquivo do conteúdo responsável por desfazer"
    echo "                      a tarefa"
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
    mkdir -p $DATA_FOLDER/$TASK_RUNNER_FOLDER ||
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
					task_content_up="$(cat "$task_script_path")"
				else
					task_content_down="$(cat "$task_script_path")"
				fi;;
			--up|-u) task_up=1;;
			--down|-d) task_up=0;;
			@)
				if [ "$task_up" = 1 ]; then
					task_content_up="$2"
				else
					task_content_down="$2"
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
		[ -z "$task_content_up" ] &&
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

	if [ "$task_content_up" ]; then
		printf "$task_content_up" > "$task_folder/$TASK_SCRIPT_NAME_UP" &&
		chmod +x "$task_folder/$TASK_SCRIPT_NAME_UP"
	fi &&

	if [ "$task_content_down" ]; then
		printf "$task_content_down" > "$task_folder/$TASK_SCRIPT_NAME_DOWN" &&
		chmod +x "$task_folder/$TASK_SCRIPT_NAME_DOWN"
	fi ||

	return $?
}

# Cria uma tarefa do tipo "info"
function create_task_info {
	local task_folder="$DATA_FOLDER/$TASK_FOLDER/$task_name/$task_version" &&
	mkdir -p "$task_folder" &&
	printf "$task_type" > "$task_folder/$TASK_TYPE_FILENAME" &&
	printf "$task_name" > "$task_folder/$TASK_NAME_FILENAME" &&
	printf "$task_message" > "$task_folder/$TASK_MESSAGE_FILENAME" &&

	if [ "$task_content_up" ]; then
		printf "$task_content_up" > "$task_folder/$TASK_INFO_NAME_UP"
	fi &&

	if [ "$task_content_down" ]; then
		printf "$task_content_down" > "$task_folder/$TASK_INFO_NAME_UP"
	fi ||

	return $?
}

# cria uma tarefa
function task {
	task_parameters "$@" &&

	case "$task_type" in
		script) create_task_script;;
		info) create_task_info;;
		*) return $ERR_INVALID_TASK_TYPE;;
	esac ||

	return $?
}

# processa os parâmetros de up e down
function up_down_parameters {
	task_name= &&
	task_version=1 &&

	while [ "$#" != 0 ]; do
		case "$1" in
			--name|-n) task_name="$2" && shift;;
			--version|-v) task_version="$2" && shift;;
			--env|-e) task_env="$2" && shift;;
			--args|-a) task_args="$2" && shift;;
			*) return $ERR_INVALID_TASK_ARG
		esac &&
		shift ||
		return $?
	done &&

	if [ -z "$task_name" ]; then
		return $ERR_REQUIRE_TASK_NAME
	fi ||

	return $?
}

# executa uma tarefa
function up {
	up_down_parameters "$@" &&
	local task_folder="$DATA_FOLDER/$TASK_FOLDER/$task_name/$task_version" &&
	local task_type="$(cat "$task_folder/$TASK_TYPE_FILENAME")" &&
	local task_runner_folder="$DATA_FOLDER/$TASK_RUNNER_FOLDER/$task_name/$(date '+%Y-%m-%d_%H:%M:%S')" &&
	local task_content_up &&

	case "$task_type" in
		script)
			mkdir -p "$task_runner_folder" &&

			cp "$task_folder/$TASK_TYPE_FILENAME" "$task_runner_folder" &&
			cp "$task_folder/$TASK_NAME_FILENAME" "$task_runner_folder" &&
			cp "$task_folder/$TASK_MESSAGE_FILENAME" "$task_runner_folder" &&
			cp "$task_folder/$TASK_SCRIPT_NAME_UP" "$task_runner_folder/$TASK_RUNNER_COMMAND_FILENAME" &&
			printf "$task_version" > "$task_runner_folder/$TASK_RUNNER_VERSION_FILENAME" &&

			task_content_up='"$(dirname $0)"'"/$TASK_RUNNER_COMMAND_FILENAME" &&
			if [ "$task_env" ]; then
				task_content_up="$task_env $task_content_up"
			fi &&
			if [ "$task_args" ]; then
				task_content_up="$task_content_up $task_args"
			fi &&
			printf '%s\n%s' '#!/usr/bin/env bash' \
				"$task_content_up" > "$task_runner_folder/$TASK_SCRIPT_NAME_UP" &&
			chmod +x "$task_runner_folder/$TASK_SCRIPT_NAME_UP" &&
			"$task_runner_folder/$TASK_SCRIPT_NAME_UP"
			;;
		info)
			if which "$TASK_INFO_VIEWER" 1> /dev/null 2> /dev/null; then
				"$TASK_INFO_VIEWER" "$task_folder/$TASK_INFO_NAME_UP"
			else
				cat "$task_folder/$TASK_INFO_NAME_UP"
			fi
	esac ||

	return $?
}

# desfaz a execução de uma tarefa
function down {
	up_down_parameters "$@" &&
	local task_folder="$DATA_FOLDER/$TASK_FOLDER/$task_name/$task_version" &&
	local task_type="$(cat "$task_folder/$TASK_TYPE_FILENAME")" &&
	local task_runner_folder="$DATA_FOLDER/$TASK_RUNNER_FOLDER/$task_name/$(date '+%Y-%m-%d_%H:%M:%S')" &&
	local task_content_down &&

	case "$task_type" in
		script)
			mkdir -p "$task_runner_folder" &&

			cp "$task_folder/$TASK_TYPE_FILENAME" "$task_runner_folder" &&
			cp "$task_folder/$TASK_NAME_FILENAME" "$task_runner_folder" &&
			cp "$task_folder/$TASK_MESSAGE_FILENAME" "$task_runner_folder" &&
			cp "$task_folder/$TASK_SCRIPT_NAME_DOWN" "$task_runner_folder/$TASK_RUNNER_COMMAND_FILENAME" &&
			printf "$task_version" > "$task_runner_folder/$TASK_RUNNER_VERSION_FILENAME" &&

			task_content_down='"$(dirname $0)"'"/$TASK_RUNNER_COMMAND_FILENAME" &&
			if [ "$task_env" ]; then
				task_content_down="$task_env $task_content_down"
			fi &&
			if [ "$task_args" ]; then
				task_content_down="$task_content_down $task_args"
			fi &&
			printf '%s\n%s' '#!/usr/bin/env bash' \
				"$task_content_down" > "$task_runner_folder/$TASK_SCRIPT_NAME_DOWN" &&
			chmod +x "$task_runner_folder/$TASK_SCRIPT_NAME_DOWN" &&
			"$task_runner_folder/$TASK_SCRIPT_NAME_DOWN"
			;;
		info)
			if which "$TASK_INFO_VIEWER" 1> /dev/null 2> /dev/null; then
				"$TASK_INFO_VIEWER" "$task_folder/$TASK_INFO_NAME_DOWN"
			else
				cat "$task_folder/$TASK_INFO_NAME_DOWN"
			fi
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
            --version) printf "version: $VERSION\n" && return 0;;
			up) shift && up "$@" && break;;
			down) shift && down "$@" && break;;
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
