#!/bin/bash
# Craoutch
# 15/03/2021
# Permet de mettre en place la base de données MariaDB et de configurer Netdata.

mot_passe="mot_de_passe"

echo "192.168.2.11  gitea
192.168.2.13  nginx
192.168.2.14  serveur" | sudo tee -a /etc/hosts;

sudo yum install -y mariadb-server

sudo yum install nfs-utils -y

sudo systemctl enable mariadb.service

sudo systemctl start mariadb.service

echo -e "CREATE USER 'gitea'@'192.168.2.11' IDENTIFIED BY \"${mot_passe}\";\n CREATE DATABASE depot CHARACTER SET 'utf8mb4'     COLLATE 'utf8mb4_unicode_ci';\n GRANT ALL PRIVILEGES ON depot.* TO 'gitea'@'192.168.2.11';\n FLUSH PRIVILEGES;\n exit    \n " | mysql -u root

sudo firewall-cmd --add-port=3306/tcp --permanent

sudo firewall-cmd --reload

mkdir -p /media/nfs

sudo mount 192.168.2.14:/opt/mariadb /media/nfs

sudo systemctl restart mariadb.service
