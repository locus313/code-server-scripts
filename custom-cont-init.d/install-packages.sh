#!/bin/bash

echo "**** updating the list of packages ****"
apt-get update

echo "**** installing pre-requisite packages ****"
apt-get install -y acl apt-transport-https gpg make software-properties-common vim wget unzip

echo "**** downloading the microsoft repository gpg keys ****"
mkdir -p /etc/apt/keyrings
wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb"

echo "**** installing the microsoft repository gpg keys ****"
dpkg -i packages-microsoft-prod.deb
rm -Rf packages-microsoft-prod.deb

"**** installing the docker repository gpg keys ****"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

"**** installing the 1password repository gpg keys ****"
curl -sS https://downloads.1password.com/linux/keys/1password.asc | gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" | tee /etc/apt/sources.list.d/1password.list

"**** installing the packer repository gpg keys ****"
curl -sS https://apt.releases.hashicorp.com/gpg | gpg --dearmor --output /etc/apt/keyrings/packer-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/packer-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/packer.list

echo "**** updating the list of packages after adding repos ****"
apt-get update

echo "**** installing powershell ****"
apt-get -y install powershell

echo "**** installing direnv ****"
apt-get -y install direnv

echo "**** installing docker ****"
apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin
usermod -aG docker abc
groupmod -g 65537 docker
setfacl --modify user:abc:rw /var/run/docker.sock

echo "**** installing 1password ****"
apt-get -y install 1password-cli

echo "**** installing clang ****"
apt-get -y install clang

echo "**** installing brew ****"
CI=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

echo "**** installing tfenv ****"
git clone --depth=1 https://github.com/tfutils/tfenv.git /config/.tfenv
/config/.tfenv/bin/tfenv install 0.12.31
/config/.tfenv/bin/tfenv install 0.14.3
/config/.tfenv/bin/tfenv install 0.14.11
/config/.tfenv/bin/tfenv install 1.1.9
/config/.tfenv/bin/tfenv install 1.2.2
/config/.tfenv/bin/tfenv install 1.3.9
/config/.tfenv/bin/tfenv install 1.4.2
/config/.tfenv/bin/tfenv use 0.12.31
# chown -R 99:100 /config/.tfenv

echo "**** installing packer ****"
apt-get -y install packer

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

echo "**** installing aws-vault ****"
curl -L -o /usr/local/bin/aws-vault https://github.com/99designs/aws-vault/releases/latest/download/aws-vault-linux-amd64
chmod 755 /usr/local/bin/aws-vault

echo "**** installing lacework-cli ****"
brew install lacework/tap/lacework-cli
