#!/usr/bin/bash

# User Checking---
user="$(whoami)"      # whoami command is user variable.

# Checking that the script is running as root.
if [ "$user" != "root" ]; then

  echo "You are now signed as a $user user."
  echo "**This script run only root user**"
  "$(sudo su)"

else
  echo "You are now signed as a $user user."
fi

#Check Docker is install---
DockerInstall() { 
# Docker installation process
  which docker
  if [ ! -x /usr/bin/docker ]; then
      # Install the required dependencies for docker
        apt-get -y install \
            ca-certificates \
            curl \
            gnupg \
            apt-transport-https\
            software-properties-common\
            lsb-release
        mkdir -p /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        echo \
          "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
          $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        chmod a+r /etc/apt/keyrings/docker.gpg
        apt-get -y update
        apt-get -y install docker docker-ce docker-compose
        systemctl start docker
        systemctl enable docker
    
else 
  version="$(docker -v)"
  echo "$version is already installed on your Ubuntu server."
fi
}
 
DockerSignIn() {
    docker login --username=$DOCKER_USER --password=$DOCKER_PASS
  }
DockerSigOut(){
    docker logout
  }


# Docker UI section
echo "Docker Manu"
PS3='Enter your choice: '
DockerUI=("Docker Installation" "Docker SignIn" "Docker SigOut" "Quit")
select function in "${DockerUI[@]}"
do
    case $function in
    "Docker Installation")
              DockerInstall
              ;;
    "Docker SignIn")
              DockerSignIn
              break;
              ;;
    "Docker SigOut")
              DockerSigOut
              break;
              ;;
             "Quit")
              break;
              ;;
              *) echo "Types Unknown command"; 
              ;;
    esac
done