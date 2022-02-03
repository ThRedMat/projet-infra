#!/bin/bash
# Craoutch
# 5/03/2021
# Permet de mettre en place le reverse proxy avec nginx et de faire sa sauvegarde vers la VM serveur

echo "192.168.2.11  gitea
192.168.2.12  mariadb
192.168.2.14  serveur" | sudo tee -a /etc/hosts;

sudo yum install -y epel-release

sudo yum install -y nginx

sudo yum install nfs-utils -y

echo "
worker_processes 1;
error_log nginx_error.log;
pid /run/nginx.pid;
events {
    worker_connections 1024;
}

http {
# Indique sur quel port écoute le serveur http et indique le nom du serveur.
    server {
      listen 80;
      server_name gitea;

    location / {
      # Permet de redirigé la connection sur la VM vers le service Gitea
        proxy_pass http://192.168.2.11:3000;
    }
  }
}"  | sudo tee /etc/nginx/nginx.conf


sudo firewall-cmd --add-port=80/tcp --permanent

sudo firewall-cmd --reload

mkdir -p /media/nfs

sudo mount 192.168.2.14:/opt/nginx /media/nfs

mkdir /opt/backup

sudo chown backup:backup /opt/backup

echo "#!/bin/bash
# Craoutch
# 15/03/2021
# Script Sauvegarde Reverse Proxy

heure=\$(date +%H%M);
jour=\$(date +%Y%m%d);
nom_sauvegarde=\"reverse_proxy_\${jour}_\${heure}\";
chemin_fermer=\"/opt/backup/bloque\";
chemin_sauvegarde=\"/media/nfs/\";
chemin_reverse_proxy=\"/etc/nginx/nginx.conf\";

if test -f \${chemin_fermer};
then
        exit 22;
fi

touch \${chemin_fermer};

tar Pzcvf \${chemin_sauvegarde}\${nom_sauvegarde} \${chemin_reverse_proxy} --ignore-failed-read | tee /dev/null;

if test \$? -eq 0;
then
        echo \"La sauvegarde \${chemin_sauvegarde}\${nom_sauvegarde} c'est bien passé.\";
else
        echo \"La sauvegarde \${chemin_sauvegarde}\${nom_sauvegarde} a échoué.\" >&2;
fi

rm -rf \${chemin_fermer};" | sudo tee /opt/backup/sauvegarde.sh

sudo chown backup:backup /opt/backup/sauvegarde.sh

sudo chmod 700 /opt/backup/sauvegarde.sh

echo "  0  0  *  *  * backup bash /opt/backup/sauvegarde.sh" | sudo tee -a /etc/crontab

sudo systemctl start nginx
