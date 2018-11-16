# Usage: Install Docker 
# Notes: Uses Default Sub

#!/bin/bash
echo "---- Install Docker Script ------- "
echo " "

echo "----   Update the apt package index  --------"
echo " "

sudo apt-get update

echo "----   Allow APT To Use Repo  --------"
echo " "

sudo apt-get install \ apt-transport-https \ ca-certificates \ curl \ software-properties-common

echo "----   Docker’s official GPG key  --------"
echo " "

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo apt-key fingerprint 0EBFCD88


echo "----   Docker’s -  set up the stable repository  --------"
echo " "

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
 
echo "----   Docker’s -  Install  --------"
echo " "
echo " "
echo " "

echo "----   Update the apt package index  --------"
echo " "

sudo apt-get update

echo "----   Install Docker CE Latest  --------"
echo " "

sudo apt-get install docker-ce

echo "----   Test Docker CE Install  --------"
echo " "

sudo docker run hello-world

