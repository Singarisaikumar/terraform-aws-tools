#!/bin/bash
curl -o /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
yum install fontconfig java-21-openjdk jenkins -y
yum install jenkins
systemctl daemon-reload
systemctl enable jenkins
systemctl start jenkins
