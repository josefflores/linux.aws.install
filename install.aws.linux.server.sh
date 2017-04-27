#!/bin/bash

### AWS NODE SERVER INSTALL SCRIPT
######

## Update base

sudo apt-get update

# sudo apt-get upgrade

## Install System Software

# Install aws cli
printf " [INSTALL] AWS-CLI\n"
sudo apt-get install -y awscli

# jq json parser
printf " [INSTALL] jq\n"
sudo apt-get install -y jq

# Install NodeJS
printf "  [INSTALL] Node.js 7\n"
curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
sudo apt-get install -y nodejs

## Add environment variables
TARGET=$HOME/github/linux.aws.install/.aws_metadata.sh
if grep -Fxq ". ${TARGET}" ~/.bashrc
then
    printf " [INSTALL] AWS Environment variables\n"
    echo . $TARGET >> ~/.bashrc
else
    printf " [SKIP]    AWS Environment variables previously added.\n"
fi

printf "Done...\n"