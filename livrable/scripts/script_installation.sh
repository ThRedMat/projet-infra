#!/bin/bash
# Craoutch
# 15/03/2021
# Fait les mises à jour, installe vim et netdata
# Désactive le SELINUX et lance le firewall au boot.

echo "nameserver 1.1.1.1" | sudo tee /etc/resolv.conf

sudo yum update -y;

sudo yum install -y vim;

bash <(curl -Ss https://my-netdata.io/kickstart.sh) --dont-wait;

sudo setenforce 0;

sudo sed -i "s/SELINUX=enforcing/SELINUX=permissive/" /etc/selinux/config;

sudo systemctl enable firewalld;
