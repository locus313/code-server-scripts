#!/bin/bash

echo "**** updating the list of packages ****"
apt-get update

echo "**** installing pre-requisite packages ****"
apt-get install -y wget apt-transport-https software-properties-common vim unzip

echo "**** downloading the microsoft repository gpg keys ****"
wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb"

echo "**** installing the microsoft repository gpg keys ****"
dpkg -i packages-microsoft-prod.deb
rm -Rf packages-microsoft-prod.deb

"**** installing the docker repository gpg keys ****"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

echo "**** updating the list of packages after adding repos ****"
apt-get update

echo "**** installing powershell ****"
apt-get -y install powershell

echo "**** installing direnv ****"
apt-get -y install direnv

echo "**** installing docker ****"
apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin

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

echo "**** installing awscli ****"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
rm -Rf awscliv2.zip

echo "**** installing aws session manager plugin ****"
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
dpkg -i session-manager-plugin.deb
rm -Rf session-manager-plugin.deb

echo "**** installing aws-vault ****"
curl -L -o /usr/local/bin/aws-vault https://github.com/99designs/aws-vault/releases/latest/download/aws-vault-linux-amd64
chmod 755 /usr/local/bin/aws-vault
