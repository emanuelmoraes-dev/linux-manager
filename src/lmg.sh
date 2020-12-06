#!/usr/bin/env bash

VERSION=0.0.12

# Linux-Manager@0.0.12
#
# Set of tools to automate and organize the activities performed and to be
# performed in a linux operating system
#
# Named Parameters:
#     --help:    Shows all options
#     --version: Shows the current version
#     up:        Perform a task
#         --name|-n:    Defines the task name
#         --version|-v: Sets the version of the task
#         --env|-e:     Defines the content (environment) to be added before
#                       the script
#         --args|-a:    Defines the script arguments
#     down:      Undo a task
#         --name|-n:    Defines the task name
#         --version|-v: Sets the version of the task
#         --env|-e:     Defines the content (environment) to be added before
#                       the script
#         --args|-a:    Defines the script arguments
#     task:      creates a new task
#         --name|-n:    Defines the task name
#         --version|-v: Sets the version of the task
#         --message|-m: Defines the task description
#         --type|-t:    Defines the type of task ("script" and "info")
#         --path|-p:    Name of the file containing the content to be copied
#                       to the task
#         @:            Contains task content in literal format
#         --up|-u:      Defines that the next --path|-p|@ will define the
#                       content file responsible for doing the task
#         --down|-d:    Defines that the next --path|-p|@ will define the
#                       content file responsible for undoing the task
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
    echo "Set of tools to automate and organize the activities performed and to be"
    echo "performed in a linux operating system"
    echo
    echo "Named Parameters:"
	echo "    --help:    Shows all options"
    echo "    --version: Shows the current version"
    echo "    up:        Perform a task"
    echo "        --name|-n:    Defines the task name"
    echo "        --version|-v: Sets the version of the task"
    echo "        --env|-e:     Defines the content (environment) to be added before"
    echo "                      the script"
    echo "        --args|-a:    Defines the script arguments"
    echo "    down:      Undo a task"
    echo "        --name|-n:    Defines the task name"
    echo "        --version|-v: Sets the version of the task"
    echo "        --env|-e:     Defines the content (environment) to be added before"
    echo "                      the script"
    echo "        --args|-a:    Defines the script arguments"
    echo "    task:      creates a new task"
    echo "        --name|-n:    Defines the task name"
	echo "        --version|-v: Sets the version of the task"
    echo "        --message|-m: Defines the task description"
    echo "        --type|-t:    Defines the type of task (\"script\" and \"info\")"
    echo "        --path|-p:    Name of the file containing the content to be copied"
    echo "                      to the task"
    echo "        @:            Contains task content in literal format"
    echo "        --up|-u:      Defines that the next --path|-p|@ will define the"
    echo "                      content file responsible for doing the task"
    echo "        --down|-d:    Defines that the next --path|-p|@ will define the"
    echo "                      content file responsible for undoing the task"
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
    mkdir -p $LMG_DATA_FOLDER/$LMG_TASK_FOLDER &&
    mkdir -p $LMG_DATA_FOLDER/$LMG_TASK_RUNNER_FOLDER ||
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
			*) return $LMG_ERR_INVALID_TASK_ARG
		esac &&
		shift ||
		return $?
	done &&

	if [ -z "$task_name" ]; then
		return $LMG_ERR_REQUIRE_TASK_NAME
	fi &&

	if (
		[ "$task_type" = "script" ] &&
		[ -z "$task_content_up" ] &&
		! [ -f "$LMG_TASK_FOLDER/$LMG_TASK_SCRIPT_NAME_UP" ]
	); then
		return $LMG_ERR_REQUIRE_TASK_SCRIPT_CONTENT
	fi &&

	if (
		[ "$task_type" = "info" ] &&
		[ -z "$task_content_up" ] &&
		! [ -f "$LMG_TASK_FOLDER/$LMG_TASK_INFO_NAME_UP" ]
	); then
		return $LMG_ERR_REQUIRE_TASK_INFO_CONTENT
	fi ||

	return $?
}

# Cria uma tarefa do tipo "script"
function create_task_script {
	local LMG_TASK_FOLDER="$LMG_DATA_FOLDER/$LMG_TASK_FOLDER/$task_name/$task_version" &&
	mkdir -p "$LMG_TASK_FOLDER" &&
	printf "$task_type" > "$LMG_TASK_FOLDER/$LMG_TASK_TYPE_FILENAME" &&
	printf "$task_name" > "$LMG_TASK_FOLDER/$LMG_TASK_NAME_FILENAME" &&
	printf "$task_message" > "$LMG_TASK_FOLDER/$LMG_TASK_MESSAGE_FILENAME" &&

	if [ "$task_content_up" ]; then
		printf "$task_content_up" > "$LMG_TASK_FOLDER/$LMG_TASK_SCRIPT_NAME_UP" &&
		chmod +x "$LMG_TASK_FOLDER/$LMG_TASK_SCRIPT_NAME_UP"
	fi &&

	if [ "$task_content_down" ]; then
		printf "$task_content_down" > "$LMG_TASK_FOLDER/$LMG_TASK_SCRIPT_NAME_DOWN" &&
		chmod +x "$LMG_TASK_FOLDER/$LMG_TASK_SCRIPT_NAME_DOWN"
	fi ||

	return $?
}

# Cria uma tarefa do tipo "info"
function create_task_info {
	local LMG_TASK_FOLDER="$LMG_DATA_FOLDER/$LMG_TASK_FOLDER/$task_name/$task_version" &&
	mkdir -p "$LMG_TASK_FOLDER" &&
	printf "$task_type" > "$LMG_TASK_FOLDER/$LMG_TASK_TYPE_FILENAME" &&
	printf "$task_name" > "$LMG_TASK_FOLDER/$LMG_TASK_NAME_FILENAME" &&
	printf "$task_message" > "$LMG_TASK_FOLDER/$LMG_TASK_MESSAGE_FILENAME" &&

	if [ "$task_content_up" ]; then
		printf "$task_content_up" > "$LMG_TASK_FOLDER/$LMG_TASK_INFO_NAME_UP"
	fi &&

	if [ "$task_content_down" ]; then
		printf "$task_content_down" > "$LMG_TASK_FOLDER/$LMG_TASK_INFO_NAME_UP"
	fi ||

	return $?
}

# cria uma tarefa
function task {
	task_parameters "$@" &&

	case "$task_type" in
		script) create_task_script;;
		info) create_task_info;;
		*) return $LMG_ERR_INVALID_TASK_TYPE;;
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
			*) return $LMG_ERR_INVALID_TASK_ARG
		esac &&
		shift ||
		return $?
	done &&

	if [ -z "$task_name" ]; then
		return $LMG_ERR_REQUIRE_TASK_NAME
	fi ||

	return $?
}

# executa uma tarefa
function up {
	up_down_parameters "$@" &&
	local LMG_TASK_FOLDER="$LMG_DATA_FOLDER/$LMG_TASK_FOLDER/$task_name/$task_version" &&
	local task_type="$(cat "$LMG_TASK_FOLDER/$LMG_TASK_TYPE_FILENAME")" &&
	local LMG_TASK_RUNNER_FOLDER="$LMG_DATA_FOLDER/$LMG_TASK_RUNNER_FOLDER/$task_name/$(date '+%Y-%m-%d_%H:%M:%S')" &&

	mkdir -p "$LMG_TASK_RUNNER_FOLDER" &&
	cp "$LMG_TASK_FOLDER/$LMG_TASK_TYPE_FILENAME" "$LMG_TASK_RUNNER_FOLDER/" &&
	cp "$LMG_TASK_FOLDER/$LMG_TASK_NAME_FILENAME" "$LMG_TASK_RUNNER_FOLDER/" &&
	cp "$LMG_TASK_FOLDER/$LMG_TASK_MESSAGE_FILENAME" "$LMG_TASK_RUNNER_FOLDER/" &&
	printf "$task_version" > "$LMG_TASK_RUNNER_FOLDER/$LMG_TASK_RUNNER_VERSION_FILENAME" &&

	local task_content_up &&

	case "$task_type" in
		script)
			cp "$LMG_TASK_FOLDER/$LMG_TASK_SCRIPT_NAME_UP" "$LMG_TASK_RUNNER_FOLDER/$LMG_TASK_RUNNER_COMMAND_FILENAME" &&

			task_content_up='"$(dirname $0)"'"/$LMG_TASK_RUNNER_COMMAND_FILENAME" &&
			if [ "$task_env" ]; then
				task_content_up="$task_env $task_content_up"
			fi &&
			if [ "$task_args" ]; then
				task_content_up="$task_content_up $task_args"
			fi &&
			printf '%s\n%s' '#!/usr/bin/env bash' \
				"$task_content_up" > "$LMG_TASK_RUNNER_FOLDER/$LMG_TASK_SCRIPT_NAME_UP" &&
			chmod +x "$LMG_TASK_RUNNER_FOLDER/$LMG_TASK_SCRIPT_NAME_UP" &&
			"$LMG_TASK_RUNNER_FOLDER/$LMG_TASK_SCRIPT_NAME_UP"
			;;
		info)
			cp "$LMG_TASK_FOLDER/$LMG_TASK_INFO_NAME_UP" "$LMG_TASK_RUNNER_FOLDER/" &&

			if which "$LMG_TASK_INFO_VIEWER" 1> /dev/null 2> /dev/null; then
				"$LMG_TASK_INFO_VIEWER" "$LMG_TASK_RUNNER_FOLDER/$LMG_TASK_INFO_NAME_UP"
			else
				cat "$LMG_TASK_RUNNER_FOLDER/$LMG_TASK_INFO_NAME_UP"
			fi
	esac ||

	return $?
}

# desfaz a execução de uma tarefa
function down {
	up_down_parameters "$@" &&
	local LMG_TASK_FOLDER="$LMG_DATA_FOLDER/$LMG_TASK_FOLDER/$task_name/$task_version" &&
	local task_type="$(cat "$LMG_TASK_FOLDER/$LMG_TASK_TYPE_FILENAME")" &&
	local LMG_TASK_RUNNER_FOLDER="$LMG_DATA_FOLDER/$LMG_TASK_RUNNER_FOLDER/$task_name/$(date '+%Y-%m-%d_%H:%M:%S')" &&

	mkdir -p "$LMG_TASK_RUNNER_FOLDER" &&
	cp "$LMG_TASK_FOLDER/$LMG_TASK_TYPE_FILENAME" "$LMG_TASK_RUNNER_FOLDER/" &&
	cp "$LMG_TASK_FOLDER/$LMG_TASK_NAME_FILENAME" "$LMG_TASK_RUNNER_FOLDER/" &&
	cp "$LMG_TASK_FOLDER/$LMG_TASK_MESSAGE_FILENAME" "$LMG_TASK_RUNNER_FOLDER/" &&
	printf "$task_version" > "$LMG_TASK_RUNNER_FOLDER/$LMG_TASK_RUNNER_VERSION_FILENAME" &&

	local task_content_down &&

	case "$task_type" in
		script)
			cp "$LMG_TASK_FOLDER/$LMG_TASK_SCRIPT_NAME_DOWN" "$LMG_TASK_RUNNER_FOLDER/$LMG_TASK_RUNNER_COMMAND_FILENAME" &&

			task_content_down='"$(dirname $0)"'"/$LMG_TASK_RUNNER_COMMAND_FILENAME" &&
			if [ "$task_env" ]; then
				task_content_down="$task_env $task_content_down"
			fi &&
			if [ "$task_args" ]; then
				task_content_down="$task_content_down $task_args"
			fi &&
			printf '%s\n%s' '#!/usr/bin/env bash' \
				"$task_content_down" > "$LMG_TASK_RUNNER_FOLDER/$LMG_TASK_SCRIPT_NAME_DOWN" &&
			chmod +x "$LMG_TASK_RUNNER_FOLDER/$LMG_TASK_SCRIPT_NAME_DOWN" &&
			"$LMG_TASK_RUNNER_FOLDER/$LMG_TASK_SCRIPT_NAME_DOWN"
			;;
		info)
			cp "$LMG_TASK_FOLDER/$LMG_TASK_INFO_NAME_DOWN" "$LMG_TASK_RUNNER_FOLDER/" &&

			if which "$LMG_TASK_INFO_VIEWER" 1> /dev/null 2> /dev/null; then
				"$LMG_TASK_INFO_VIEWER" "$LMG_TASK_RUNNER_FOLDER/$LMG_TASK_INFO_NAME_DOWN"
			else
				cat "$LMG_TASK_RUNNER_FOLDER/$LMG_TASK_INFO_NAME_DOWN"
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
            *) return $LMG_ERR_INVALID_ARG;;
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
			$LMG_ERR_INVALID_ARG) return $(m="Erro: Argumento inválido!" e=$err helperr -v);;
			$LMG_ERR_INVALID_TASK_TYPE) return $(m="Erro: tipo de tarefa inválida!" e=$err helperr);;
			$LMG_ERR_INVALID_TASK_ARG) return $(m="Erro: Argumento de tarefa inválido!" e=$err helperr);;
			$LMG_ERR_REQUIRE_TASK_NAME) return $(m="Erro: O nome da tarefa é obrigatório!" e=$err helperr);;
			$LMG_ERR_REQUIRE_TASK_SCRIPT_CONTENT) return $(m="Erro: Uma tarefa do tipo \"script\" deve possuir um script!" e=$err helperr);;
			$LMG_ERR_REQUIRE_TASK_INFO_CONTENT) return $(m="Erro: Uma tarefa do tipo \"info\" deve possuir um conteúdo!" e=$err helperr);;
			*) return $(helperr);;
		esac
	)
}

main "$@" # Executa a função principal
