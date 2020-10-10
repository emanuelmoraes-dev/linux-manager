# linux-manager
Conjunto de ferramentas para automatizar e organizar as atividades realizadas e a serem realizadas em um sistema operacional linux

## install

```sh
folder_instalation="$HOME/.local/share/lmg"
git clone https://github.com/emanuelmoraes-dev/linux-manager.git
cd linux-manager
mkdir -p "$folder_instalation"
cp -rf src/* "$folder_instalation"
printf "$(./template.sh)" "$folder_instalation" > lmg
chmod +x lmg
sudo mv lmg /usr/bin
```