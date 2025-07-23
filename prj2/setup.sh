#!/bin/bash
sudo useradd -m -s /bin/bash user1
echo 'user1:1234' | sudo chpasswd
sudo usermod -aG sudo user1
sudo yum install python3
sudo yum install python3-pip
sudo dnf install dnf-utils
sudo dnf update
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io
sudo systemctl enable docker
sudo cd /app
sudo docker build -t  docker_http .
sudo docker run -d -p 8080:8080 -t docker_http 



