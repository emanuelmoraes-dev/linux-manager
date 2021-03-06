#!/usr/bin/env bash

# Localização da pasta que conterá as informações registradas na aplicação
[ -z "$LMG_DATA_FOLDER" ] && LMG_DATA_FOLDER=$DIRNAME/.lmg

# Nome da pasta que conterá a lista de tarefas
[ -z "$LMG_TASK_FOLDER" ] && LMG_TASK_FOLDER=task

# Nome da pasta que conterá a lista de tarefas que foram executadas
[ -z "$LMG_TASK_RUNNER_FOLDER" ] && LMG_TASK_RUNNER_FOLDER=task-runner

# Nome do arquivo que conterá a versão do task runner
[ -z "$LMG_TASK_RUNNER_VERSION_FILENAME" ] && LMG_TASK_RUNNER_VERSION_FILENAME="task-version"

# Nome do script em task_runner copiado do scripto de task
[ -z "$LMG_TASK_RUNNER_COMMAND_FILENAME" ] && LMG_TASK_RUNNER_COMMAND_FILENAME="command.sh"

# Nome do script executável para executar a tarefa do tipo "script"
[ -z "$LMG_TASK_SCRIPT_NAME_UP" ] && LMG_TASK_SCRIPT_NAME_UP="task-up.sh"

# Nome do script executável para executar a tarefa do tipo "script"
[ -z "$LMG_TASK_SCRIPT_NAME_DOWN" ] && LMG_TASK_SCRIPT_NAME_DOWN="task-down.sh"

# Nome do arquivo que contém o conteúdo da tarefa do tipo "info"
[ -z "$LMG_TASK_INFO_NAME_UP" ] && LMG_TASK_INFO_NAME_UP="task-up.md"

# Nome do arquivo que contém o conteúdo para reverter a tarefa do tipo "info"
[ -z "$LMG_TASK_INFO_NAME_DOWN" ] && LMG_TASK_INFO_NAME_DOWN="task-down.md"

# Nome do programa para visualizar o conteúdo da tarefa do tipo "info"
[ -z "$LMG_TASK_INFO_VIEWER" ] && LMG_TASK_INFO_VIEWER="cat"

# Nome do arquivo que conterá o nome do tipo da tarefa
[ -z "$LMG_TASK_TYPE_FILENAME" ] && LMG_TASK_TYPE_FILENAME="task-type"

# Nome do arquivo que conterá o nome da tarefa
[ -z "$LMG_TASK_NAME_FILENAME" ] && LMG_TASK_NAME_FILENAME="task-name"

# Nome do arquivo que conterá a mensagem da tarefa
[ -z "$LMG_TASK_MESSAGE_FILENAME" ] && LMG_TASK_MESSAGE_FILENAME="task-message"

# CÓDIGOS DE ERRO DO SCRIPT (90-119)
LMG_ERR_UNEXPECTED=90
## INVALID (9X)
LMG_ERR_INVALID_ARG=91
LMG_ERR_INVALID_TASK_TYPE=92
LMG_ERR_INVALID_TASK_ARG=93
## REQUIRE (10X)
LMG_ERR_REQUIRE_TASK_NAME=100
LMG_ERR_REQUIRE_TASK_SCRIPT_CONTENT=101
LMG_ERR_REQUIRE_TASK_INFO_CONTENT=102

# CORES
LMG_RED="\e[31;1m"
LMG_END_COLOR="\e[m"

# TEMAS
[ -z "$LMG_ERROR_THEME" ] && LMG_ERROR_THEME="$LMG_RED"
