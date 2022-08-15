#!/bin/bash

echo "**** updating the list of packages ****"
apt-get update

echo "**** installing pre-requisite packages ****"
apt-get install -y wget apt-transport-https software-properties-common vim unzip

echo "**** downloading the microsoft repository gpg keys ****"
wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb"

echo "**** installing the microsoft repository gpg keys ****"
dpkg -i packages-microsoft-prod.deb

echo "**** updating the list of packages after adding repos ****"
apt-get update

echo "**** installing powershell ****"
apt-get -y install powershell

echo "**** installing direnv ****"
apt-get -y install direnv

echo "**** installing brew ****"
CI=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

echo "**** installing tfenv ****"
git clone --depth=1 https://github.com/tfutils/tfenv.git /config/.tfenv
/config/.tfenv/bin/tfenv install 0.12.31
/config/.tfenv/bin/tfenv install 0.14.3
/config/.tfenv/bin/tfenv install 1.1.2
/config/.tfenv/bin/tfenv use 0.12.31
chown -R 99:100 /config/.tfenv
