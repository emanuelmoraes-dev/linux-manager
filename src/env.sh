#!/bin/bash

# Localização da pasta que conterá as informações registradas na aplicação
DATA_FOLDER=$HOME/.lmg

# Nome da pasta que conterá a lista de tarefas
TASK_FOLDER=task

# Nome da pasta que conterá a lista de tarefas que foram executadas
TASK_RUNNER_FOLDER=task-runner

# Nome da pasta que conterá a lista de informações sobre o uso do sistema
INFO_FOLDER=info

# Nome do script executável para executar a tarefa do tipo "script"
TASK_SCRIPT_NAME="command.sh"

# Nome do arquivo que conterá o nome do tipo da tarefa
TASK_TYPE_FILENAME="task-type"

# Nome do arquivo que conterá o nome da tarefa
TASK_NAME_FILENAME="task-name"

# Nome do arquivo que conterá a mensagem da tarefa
TASK_MESSAGE_FILENAME="task-message"

# CÓDIGOS DE ERRO DO SCRIPT (90-119)
ERR_UNEXPECTED=90
## INVALID (9X)
ERR_INVALID_ARG=91
ERR_INVALID_TASK_TYPE=92
ERR_INVALID_TASK_ARG=93
## REQUIRE (10X)
ERR_REQUIRE_TASK_NAME=100
ERR_REQUIRE_TASK_SCRIPT_CONTENT=101

# CORES
RED="\e[31;1m"
END_COLOR="\e[m"

# TEMAS
ERROR_THEME="$RED"
