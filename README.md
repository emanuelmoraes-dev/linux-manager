# linux-manager
Conjunto de ferramentas para automatizar e organizar as atividades realizadas e a serem realizadas em um sistema operacional linux

## install

```sh
folder_instalation="/usr/local/lmg"
sudo mkdir -p "$folder_instalation"
sudo cp -rf src/* "$folder_instalation"
sudo echo "DATA_FOLDER='$folder_instalation' '$folder_instalation/lmg.sh'" '"$@"' > /usr/bin/lmg
sudo chmod +x /usr/bin/lmg
```