#!/bin/bash
# Craoutch
# 15/03/2021
# Permet de mettre en place le serveur NFS et d'associer un dossier à chaque VM.

echo "192.168.2.11  gitea
192.168.2.12  mariadb
192.168.2.13  nginx" | sudo tee -a /etc/hosts;

sudo yum install nfs-utils -y

sudo firewall-cmd --add-service=nfs --permanent

sudo firewall-cmd --reload

sudo sed -i "s/#Domain = local.domain.edu/Domain = proj.b2/" /etc/idmapd.conf;

sudo mkdir /opt/gitea /opt/mariadb /opt/nginx

echo "/opt/gitea  192.168.2.0/24(rw,async,no_subtree_check) \
*proj.b2(rw,async,no_subtree_check)
/opt/mariadb  192.168.2.0/24(rw,async,no_subtree_check) \
*proj.b2(rw,async,no_subtree_check)
/opt/nginx  192.168.2.0/24(rw,async,no_subtree_check) \
*proj.b2(rw,async,no_subtree_check)" | sudo tee /etc/exports

sudo chown backup:backup /opt/mariadb /opt/nginx

sudo chown nfsnobody:nfsnobody /opt/gitea

sudo systemctl enable rpcbind nfs-server --now
