#!/bin/bash

### AWS NODE SERVER INSTALL SCRIPT
######

## Update base

sudo apt-get update
sudo apt-get upgrade

## Install System Software

# Install aws cli
sudo apt-get install -y awscli

# jq json parser
sudo apt-get install -y jq

# Install NodeJS
curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
sudo apt-get install -y nodejs

## Add environment variables
echo . $HOME/github/linux.aws.install/.aws_metadata.sh >> ~/.bashrc