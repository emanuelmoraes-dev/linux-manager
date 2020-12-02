# linux-manager
Set of tools to automate and organize the activities performed and to be performed in a linux operating system

## install

```sh
git clone https://github.com/emanuelmoraes-dev/linux-manager.git &&
cd linux-manager &&
./install # <folder_instalation>
```

### OBS
If "folder_instalation" is not provided for the installation script, by default, the installation will be carried out in "$HOME/.local/share/lmg" (if **not** root) or "/usr/local/share/lmg (if root)

## show help

```sh
lmg --help
```

## show version

```sh
lmg --version
```

## parameters

<pre>    --help:    Shows all options
    --version: Shows the current version
    up:        Perform a task
        --name|-n:    Defines the task name
        --version|-v: Sets the version of the task
        --env|-e:     Defines the content (environment) to be added before
                      the script
        --args|-a:    Defines the script arguments
    down:      Undo a task
        --name|-n:    Defines the task name
        --version|-v: Sets the version of the task
        --env|-e:     Defines the content (environment) to be added before
                      the script
        --args|-a:    Defines the script arguments
    task:      creates a new task
        --name|-n:    Defines the task name
        --version|-v: Sets the version of the task
        --message|-m: Defines the task description
        --type|-t:    Defines the type of task ("script" and "info")
        --path|-p:    Name of the file containing the content to be copied
                      to the task
        @:            Contains task content in literal format
        --up|-u:      Defines that the next --path|-p|@ will define the
                      content file responsible for doing the task
        --down|-d:    Defines that the next --path|-p|@ will define the
                      content file responsible for undoing the task</pre>