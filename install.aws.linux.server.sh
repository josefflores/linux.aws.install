#!/bin/bash

### AWS NODE SERVER INSTALL SCRIPT
######
printf "\n AWS NODE SERVER INSTALL SCRIPT\n\n"

## Update base

printf " [UPDATE]  Ubuntu\n"
sudo apt-get -qq update

printf " [UPGRADE] Ubuntu\n"
sudo apt-get -qq upgrade

## Install System Software

# Install aws cli
printf " [INSTALL] AWS-CLI\n"
sudo apt-get -qq install -y awscli

# jq json parser
printf " [INSTALL] jq\n"
sudo apt-get -qq install -y jq

# Install NodeJS
printf " [INSTALL] Node.js 7\n"
curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
sudo apt-get -qq install -y nodejs

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