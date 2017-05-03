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
        echo "# $3" | tee -a $1
        echo "$2" | tee -a $1
    fi
}

# Grants group access to a user
#
# $1 User.
# $2 Group name.
GrantGroup(){
    if groups $1 | grep -c sudo
    then
        printf " [SKIP]    $1 $2.\n"
    else
        printf " [GRANT]   $1 $2.\n"
        usermod -aG $2 $1
    fi
}

### AWS NODE SERVER INSTALL SCRIPT
######
USER_ID=id -u $USER
printf "\n AWS NODE SERVER INSTALL SCRIPT\n"
printf "Running as $USER::$USER_ID\n\n"

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
wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | apt-key add -
sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
apt-get -qq update -y
apt-get -qq install -y jenkins

# Give Jenkins sudo permissions
if (($USER_ID == 1000))
then
    # GrantGroup jenkins sudo
    cp .jenkins /etc/sudoers.d/jenkins
    chmod 440 /etc/sudoers.d/jenkins
    /etc/init.d/jenkins stop
fi

# ADD TLS
COMMENT="Jenkins TLS enabled"
LINE="JAVA_ARGS=\"${JAVA_ARGS} -Dmail.smtp.starttls.enable=true\""
AppendToFile /etc/default/jenkins $LINE $COMMENT


if (($USER_ID == 1000))
then
    /etc/init.d/jenkins start
    sleep 2
fi

# NodeJS
printf " [INSTALL] Node.js 7\n"
curl -sL https://deb.nodesource.com/setup_7.x | bash -
apt-get -qq install -y nodejs

# NPM
printf " [INSTALL] NPM (Global) - Express\n"
npm install express -g

# Add environment variables
COMMENT="AWS Environment variables"
LINE=". $HOME/github/linux.aws.install/.aws_metadata.sh"
AppendToFile ~/.bashrc $LINE $COMMENT

printf "\n Done...\n\n"