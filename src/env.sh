#!/usr/bin/env bash

# Localização da pasta que conterá as informações registradas na aplicação
[ -z "$DATA_FOLDER" ] && DATA_FOLDER=$DIRNAME/.lmg

# Nome da pasta que conterá a lista de tarefas
[ -z "$TASK_FOLDER" ] && TASK_FOLDER=task

# Nome da pasta que conterá a lista de tarefas que foram executadas
[ -z "$TASK_RUNNER_FOLDER" ] && TASK_RUNNER_FOLDER=task-runner

# Nome do arquivo que conterá a versão do task runner
[ -z "$TASK_RUNNER_VERSION_FILENAME" ] && TASK_RUNNER_VERSION_FILENAME="task-version"

# Nome do script em task_runner copiado do scripto de task
[ -z "$TASK_RUNNER_COMMAND_FILENAME" ] && TASK_RUNNER_COMMAND_FILENAME="command.sh"

# Nome do script executável para executar a tarefa do tipo "script"
[ -z "$TASK_SCRIPT_NAME_UP" ] && TASK_SCRIPT_NAME_UP="task-up.sh"

# Nome do script executável para executar a tarefa do tipo "script"
[ -z "$TASK_SCRIPT_NAME_DOWN" ] && TASK_SCRIPT_NAME_DOWN="task-down.sh"

# Nome do arquivo que contém o conteúdo da tarefa do tipo "info"
[ -z "$TASK_INFO_NAME_UP" ] && TASK_INFO_NAME_UP="task-up.md"

# Nome do arquivo que contém o conteúdo para reverter a tarefa do tipo "info"
[ -z "$TASK_INFO_NAME_DOWN" ] && TASK_INFO_NAME_DOWN="task-down.md"

# Nome do programa para visualizar o conteúdo da tarefa do tipo "info"
[ -z "$TASK_INFO_VIEWER" ] && TASK_INFO_VIEWER="cat"

# Nome do arquivo que conterá o nome do tipo da tarefa
[ -z "$TASK_TYPE_FILENAME" ] && TASK_TYPE_FILENAME="task-type"

# Nome do arquivo que conterá o nome da tarefa
[ -z "$TASK_NAME_FILENAME" ] && TASK_NAME_FILENAME="task-name"

# Nome do arquivo que conterá a mensagem da tarefa
[ -z "$TASK_MESSAGE_FILENAME" ] && TASK_MESSAGE_FILENAME="task-message"

# CÓDIGOS DE ERRO DO SCRIPT (90-119)
ERR_UNEXPECTED=90
## INVALID (9X)
ERR_INVALID_ARG=91
ERR_INVALID_TASK_TYPE=92
ERR_INVALID_TASK_ARG=93
## REQUIRE (10X)
ERR_REQUIRE_TASK_NAME=100
ERR_REQUIRE_TASK_SCRIPT_CONTENT=101
ERR_REQUIRE_TASK_INFO_CONTENT=102

# CORES
RED="\e[31;1m"
END_COLOR="\e[m"

# TEMAS
[ -z "$ERROR_THEME" ] && ERROR_THEME="$RED"
