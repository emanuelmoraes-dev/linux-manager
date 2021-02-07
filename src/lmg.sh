#!/usr/bin/env bash

VERSION=0.0.16
DEFAULT_TASK_VERSION=current

# Linux-Manager@0.0.16
#
# Set of tools to automate and organize the activities performed and to be
# performed in a linux operating system
#
# Named Parameters:
#     --help:    Shows all options
#     --version: Shows the current version
#     sh:        Execute commands inside .lmg folder
#     up <name>:        Perform a task with your <name>
#         --version|-v: Sets the version of the task. Default value: current
#         --env|-e:     Defines the content (environment) to be added before
#                       the script
#         --args|-a:    Defines the script arguments
#     down <name>:      Undo a task with your <name>
#         --version|-v: Sets the version of the task. Default value: current
#         --env|-e:     Defines the content (environment) to be added before
#                       the script
#         --args|-a:    Defines the script arguments
#     task <name>:      creates a new task with your <name>
#         --version|-v: Sets the version of the task. Default value: current
#         --message|-m: Defines the task description
#         --path|-p:    Name of the file containing the content to be copied
#                       to the task
#         @:            Contains task content in literal format
#         @[program]:   Contains the content of the task in literal format,
#                       executed by <program>. Exs: @sh, @cat
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
    echo "    sh:        Execute commands inside .lmg folder"
    echo "    up <name>:        Perform a task with your <name>"
    echo "        --version|-v: Sets the version of the task. Default value: $DEFAULT_TASK_VERSION"
    echo "        --env|-e:     Defines the content (environment) to be added before"
    echo "                      the script"
    echo "        --args|-a:    Defines the script arguments"
    echo "    down <name>:      Undo a task with your <name>"
    echo "        --version|-v: Sets the version of the task. Default value: $DEFAULT_TASK_VERSION"
    echo "        --env|-e:     Defines the content (environment) to be added before"
    echo "                      the script"
    echo "        --args|-a:    Defines the script arguments"
    echo "    task <name>:      creates a new task with your <name>"
    echo "        --version|-v: Sets the version of the task. Default value: $DEFAULT_TASK_VERSION"
    echo "        --message|-m: Defines the task description"
    echo "        --path|-p:    Name of the file containing the content to be copied"
    echo "                      to the task"
	echo "        @[program=sh]:   Contains the content of the task in literal format,"
	echo "                      executed by <program>. Default value for <program>: sh"
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
	task_version="$DEFAULT_TASK_VERSION" &&
	task_program_env_up=sh &&
	task_program_env_down=sh &&
	task_name= &&
	task_message= &&
	task_content_up= &&
	task_content_down= &&
	task_path_up= &&
	task_path_down= &&

	while [ "$#" != 0 ]; do
		case "$1" in
			--message|-m) task_message="$2" && shift;;
			--version|-v) task_version="$2" && shift;;
			--path|-p)
				task_script_path="$2" &&
				shift &&
				task_script_path="$(to_absolute "$task_script_path")" &&
				if [ "$task_up" = 1 ]; then
					task_path_up="$task_script_path"
				else
					task_path_down="$task_script_path"
				fi;;
			--up|-u) task_up=1;;
			--down|-d) task_up=0;;
			*)
			if [[ "$1" == @* ]]; then
				if [ "$task_up" = 1 ]; then
					task_program_env_up="${$1:1}" &&
					if [ -z "$task_program_env_up" ]; then
						task_program_env_up=sh
					fi &&
					task_content_up="$2"
				else
					task_program_env_down="${$1:1}" &&
					if [ -z "$task_program_env_down" ]; then
						task_program_env_down=sh
					fi &&
					task_content_down="$2"
				fi &&
				shift;;
			elif [[ "$1" == -* ]]; then
				return $LMG_ERR_INVALID_TASK_ARG
			else
				task_name="$2" && shift;;
			fi
		esac &&
		shift ||
		return $?
	done &&

	if [ -z "$task_name" ]; then
		return $LMG_ERR_REQUIRE_TASK_NAME
	fi &&

	if (
		[ -z "$task_content_up" ] &&
		[ -z "$task_path_up" ] &&
		! [ -f "$LMG_TASK_FOLDER/$LMG_TASK_SCRIPT_NAME_UP" ]
	); then
		return $LMG_ERR_REQUIRE_TASK_CONTENT
	fi ||

	return $?
}

# Cria uma tarefa
function create_task_script {
	local LMG_TASK_FOLDER="$LMG_DATA_FOLDER/$LMG_TASK_FOLDER/$task_name/$task_version" &&
	mkdir -p "$LMG_TASK_FOLDER" &&
	printf "$task_name" > "$LMG_TASK_FOLDER/$LMG_TASK_NAME_FILENAME" &&
	printf "$task_message" > "$LMG_TASK_FOLDER/$LMG_TASK_MESSAGE_FILENAME" &&

	if [ "$task_content_up" ]; then
		printf "$task_program_env_up\n%s" "$task_content_up" > "$LMG_TASK_FOLDER/$LMG_TASK_SCRIPT_NAME_UP" &&
		chmod +x "$LMG_TASK_FOLDER/$LMG_TASK_SCRIPT_NAME_UP"
	elif [ "$task_path_up" ]; then
		cp "$task_path_up" "$LMG_TASK_FOLDER/$LMG_TASK_SCRIPT_NAME_UP" &&
		chmod +x "$LMG_TASK_FOLDER/$LMG_TASK_SCRIPT_NAME_UP"
	fi &&

	if [ "$task_content_down" ]; then
		printf "$task_program_env_down\n%s" "$task_content_down" > "$LMG_TASK_FOLDER/$LMG_TASK_SCRIPT_NAME_DOWN" &&
		chmod +x "$LMG_TASK_FOLDER/$LMG_TASK_SCRIPT_NAME_DOWN"
	elif [ "$task_path_down" ]; then
		cp "$task_path_down" "$LMG_TASK_FOLDER/$LMG_TASK_SCRIPT_NAME_DOWN" &&
		chmod +x "$LMG_TASK_FOLDER/$LMG_TASK_SCRIPT_NAME_DOWN"
	fi ||

	return $?
}

# cria uma tarefa
function task {
	task_parameters "$@" &&
	create_task_script ||
	return $?
}

# processa os parâmetros de up e down
function up_down_parameters {
	task_name= &&
	task_version="$DEFAULT_TASK_VERSION" &&

	while [ "$#" != 0 ]; do
		case "$1" in
			--version|-v) task_version="$2" && shift;;
			--env|-e) task_env="$2" && shift;;
			--args|-a) task_args="$2" && shift;;
			*)
			if [[ "$1" == -* ]]; then
				return $LMG_ERR_INVALID_TASK_ARG
			else
				task_name="$2" && shift;;
			fi
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
	local LMG_TASK_RUNNER_FOLDER="$LMG_DATA_FOLDER/$LMG_TASK_RUNNER_FOLDER/$task_name/$(date '+%Y-%m-%d_%H:%M:%S')" &&

	cp "$LMG_TASK_FOLDER/$LMG_TASK_NAME_FILENAME" "$LMG_TASK_RUNNER_FOLDER/" &&
	cp "$LMG_TASK_FOLDER/$LMG_TASK_MESSAGE_FILENAME" "$LMG_TASK_RUNNER_FOLDER/" &&
	printf "$task_version" > "$LMG_TASK_RUNNER_FOLDER/$LMG_TASK_RUNNER_VERSION_FILENAME" &&

	local task_content_up &&

	cp "$LMG_TASK_FOLDER/$LMG_TASK_SCRIPT_NAME_UP" "$LMG_TASK_RUNNER_FOLDER/$LMG_TASK_RUNNER_COMMAND_FILENAME" &&

	task_content_up='"$(dirname $0)"'"/$LMG_TASK_RUNNER_COMMAND_FILENAME" &&
	if [ "$task_env" ]; then
		task_content_up="$task_env $task_content_up"
	fi &&
	if [ "$task_args" ]; then
		task_content_up="$task_content_up $task_args"
	fi &&
	printf '%s\n%s' '#!/usr/bin/env sh' \
		"$task_content_up" > "$LMG_TASK_RUNNER_FOLDER/$LMG_TASK_SCRIPT_NAME_UP" &&
	chmod +x "$LMG_TASK_RUNNER_FOLDER/$LMG_TASK_SCRIPT_NAME_UP" &&
	"$LMG_TASK_RUNNER_FOLDER/$LMG_TASK_SCRIPT_NAME_UP" ||

	return $?
}

# desfaz a execução de uma tarefa
function down {
	up_down_parameters "$@" &&
	local LMG_TASK_FOLDER="$LMG_DATA_FOLDER/$LMG_TASK_FOLDER/$task_name/$task_version" &&
	local LMG_TASK_RUNNER_FOLDER="$LMG_DATA_FOLDER/$LMG_TASK_RUNNER_FOLDER/$task_name/$(date '+%Y-%m-%d_%H:%M:%S')" &&

	mkdir -p "$LMG_TASK_RUNNER_FOLDER" &&
	cp "$LMG_TASK_FOLDER/$LMG_TASK_NAME_FILENAME" "$LMG_TASK_RUNNER_FOLDER/" &&
	cp "$LMG_TASK_FOLDER/$LMG_TASK_MESSAGE_FILENAME" "$LMG_TASK_RUNNER_FOLDER/" &&
	printf "$task_version" > "$LMG_TASK_RUNNER_FOLDER/$LMG_TASK_RUNNER_VERSION_FILENAME" &&

	local task_content_down &&

	cp "$LMG_TASK_FOLDER/$LMG_TASK_SCRIPT_NAME_DOWN" "$LMG_TASK_RUNNER_FOLDER/$LMG_TASK_RUNNER_COMMAND_FILENAME" &&

	task_content_down='"$(dirname $0)"'"/$LMG_TASK_RUNNER_COMMAND_FILENAME" &&
	if [ "$task_env" ]; then
		task_content_down="$task_env $task_content_down"
	fi &&
	if [ "$task_args" ]; then
		task_content_down="$task_content_down $task_args"
	fi &&
	printf '%s\n%s' '#!/usr/bin/env sh' \
		"$task_content_down" > "$LMG_TASK_RUNNER_FOLDER/$LMG_TASK_SCRIPT_NAME_DOWN" &&
	chmod +x "$LMG_TASK_RUNNER_FOLDER/$LMG_TASK_SCRIPT_NAME_DOWN" &&
	"$LMG_TASK_RUNNER_FOLDER/$LMG_TASK_SCRIPT_NAME_DOWN" ||

	return $?
}

# Processa os parâmetros passados pelo usuário
function apply_parameters {
  local commands

    if [ "$#" = 0 ]; then
        helpout --autor &&
        return 0
    fi &&

    while [ "$#" != 0 ]; do
        case "$1" in
            --help) helpout --autor && return 0;;
            --version) printf "version: $VERSION\n" && return 0;;
            sh) shift && commands="$@" && sh -c "cd $LMG_DATA_FOLDER && $commands" && break;;
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
			$LMG_ERR_INVALID_ARG) return $(m="$LMG_ERR_INVALID_ARG_MESSAGE" e=$err helperr -v);;
			$LMG_ERR_INVALID_TASK_ARG) return $(m="$LMG_ERR_INVALID_TASK_ARG_MESSAGE" e=$err helperr);;
			$LMG_ERR_REQUIRE_TASK_NAME) return $(m="$LMG_ERR_REQUIRE_TASK_NAME_MESSAGE" e=$err helperr);;
			$LMG_ERR_REQUIRE_TASK_CONTENT) return $(m="$LMG_ERR_REQUIRE_TASK_SCRIPT_CONTENT_MESSAGE" e=$err helperr);;
			*) return $(helperr);;
		esac
	)
}

main "$@" # Executa a função principal
