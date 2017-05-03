#!/bin/bash

# Function to append a line and comment to a file
#
# $1 The file to add to.
# $2 The line to add.
# $3 The comment to display above the line and in script output.
AppendToFile(){
    if grep -Fxq "$2" $1
    then
        printf " [SKIP]    $3.\n"
    else
        printf " [APPEND]  $3.\n"
        echo "# $3" | sudo tee -a $1
        echo "$2" | sudo tee -a $1
    fi
}

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

# Give Jenkins sudo permissions
#sudo cp .system-sudo-users /etc/sudoers.d/system-sudo-users

# ADD TLS
sudo /etc/init.d/jenkins stop
sleep 2

COMMENT="Jenkins TLS enabled"
LINE="JAVA_ARGS=\"${JAVA_ARGS} -Dmail.smtp.starttls.enable=true\""
AppendToFile /etc/default/jenkins $LINE $COMMENT

sudo /etc/init.d/jenkins start
sleep 2

# NodeJS
printf " [INSTALL] Node.js 7\n"
curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
apt-get -qq install -y nodejs

# NPM
printf " [INSTALL] NPM (Global) - Express\n"
npm install express -g

# Add environment variables
COMMENT="AWS Environment variables"
LINE=". $HOME/github/linux.aws.install/.aws_metadata.sh"
AppendToFile ~/.bashrc $LINE $COMMENT

printf "\n Done...\n\n"