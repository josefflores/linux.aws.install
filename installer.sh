#!/bin/bash

### AWS NODE SERVER INSTALL SCRIPT
######
printf "\n AWS NODE SERVER INSTALL SCRIPT\n\n"

## Update base

printf " [UPDATE]  Ubuntu\n"
apt-get -qq update -y

printf " [UPGRADE] Ubuntu\n"
apt-get -qq upgrade -y

## Install System Software

# Install aws cli
printf " [INSTALL] AWS-CLI\n"
apt-get -qq install -y awscli

# jq json parser
printf " [INSTALL] jq\n"
apt-get -qq install -y jq

# Jenkins
printf " [INSTALL] Jenkins\n"
wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
apt-get -qq update -y
apt-get -qq install -y jenkins

# ADD TLS

TARGET=/etc/default/jenkins

PROPERTY="-Dmail.smtp.starttls.enable"
VALUE="true"
CONFIG="JAVA_ARGS=\"${JAVA_ARGS} ${PROPERTY}=${VALUE}\""

if grep -Fxq "${CONFIG}" TARGET
then
    printf " [SKIP]    Jenkins TLS enabled config in place.\n"
else
    printf " [CONFIG]  Jenkins TLS enabled.\n"
    echo "# Jenkins TLS enabled" >> TARGET
    echo CONFIG >> TARGET
fi

# NodeJS
printf " [INSTALL] Node.js 7\n"
curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
apt-get -qq install -y nodejs

# NPM
printf " [INSTALL] NPM (Global) - Express\n"
npm install express -g

## Add environment variables
TARGET=$HOME/github/linux.aws.install/.aws_metadata.sh
if grep -Fxq ". ${TARGET}" ~/.bashrc
then
    printf " [SKIP]    AWS Environment variables previously added.\n"
else
    printf " [INSTALL] AWS Environment variables\n"
    echo "# IMPORT AWS VARIABLES" >> ~/.bashrc
    echo . $TARGET >> ~/.bashrc
fi

printf "\n Done...\n\n"