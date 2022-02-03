#!/bin/bash
# Craoutch
# 15/03/2021
# Permet de mettre en place le service Gitea, de faire sa sauvegarde vers la VM serveur et de vérifier l'empreinte du binaire Gitea.

echo "192.168.2.12  mariadb
192.168.2.13  nginx
192.168.2.14  serveur" | sudo tee -a /etc/hosts

sudo yum install wget -y

sudo yum install git -y

sudo yum install nfs-utils -y

wget -O gitea https://dl.gitea.io/gitea/1.12.5/gitea-1.12.5-linux-amd64

mkdir /opt/bonus

wget -O /opt/bonus/gitea.sha256 https://dl.gitea.io/gitea/1.12.5/gitea-1.12.5-linux-arm64.sha256

sha256sum gitea | sudo tee /opt/bonus/empreite_binaire

echo "#!/bin/bash
# Craoutch
# 115/03/2021
# Script Différence Empreinte

diff /opt/bonus/empreite_binaire /opt/bonus/gitea.sha256" | sudo tee /opt/bonus/empreinte.sh

sudo chmod 700 /opt/bonus/empreinte.sh

chmod +x gitea

sudo adduser --system --shell /bin/bash --home /home/git git

sudo mkdir -p /var/lib/gitea/{custom,data,log}

sudo chown -R git:git /var/lib/gitea/

sudo chmod -R 750 /var/lib/gitea/

sudo mkdir /etc/gitea

sudo chown root:git /etc/gitea

sudo chmod 770 /etc/gitea

echo "APP_NAME = Gitea Depot
RUN_USER = root
RUN_MODE = prod

[oauth2]
JWT_SECRET = w3s7rSw71mI1Ecpuk8Mm5WeeCheQvSAJiHVqe1jQ3G0

[security]
INTERNAL_TOKEN = eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYmYiOjE2MDM1NjQ0MTZ9.Zl6Oc6WWcErfm6BZaHa82sOzfrkj7McdevJ9OzuGbAA
INSTALL_LOCK   = true
SECRET_KEY     = RrxsgPycYzslGB43FLMUnLy2LlejftIJEy7gDuHCw8IHPSU0UGOdmwEbPsdMwdkj

[database]
DB_TYPE  = mysql
HOST     = 192.168.2.12:3306
NAME     = depot
USER     = gitea
PASSWD   = mot_de_passe
SCHEMA   =
SSL_MODE = disable
CHARSET  = utf8
PATH     = /usr/local/bin/data/gitea.db

[repository]
ROOT = /root/gitea-repositories

[server]
SSH_DOMAIN       = 192.168.2.13
DOMAIN           = proj_b2
HTTP_PORT        = 3000
ROOT_URL         = http://192.168.2.13:80/
DISABLE_SSH      = false
SSH_PORT         = 22
LFS_START_SERVER = true
LFS_CONTENT_PATH = /usr/local/bin/data/lfs
LFS_JWT_SECRET   = m5oMw88giXGETRULOPcOVtd5vDwnko2wgq6Mo_VwIho
OFFLINE_MODE     = false

[mailer]
ENABLED = false

[service]
REGISTER_EMAIL_CONFIRM            = false
ENABLE_NOTIFY_MAIL                = false
DISABLE_REGISTRATION              = false
ALLOW_ONLY_EXTERNAL_REGISTRATION  = false
ENABLE_CAPTCHA                    = false
REQUIRE_SIGNIN_VIEW               = false
DEFAULT_KEEP_EMAIL_PRIVATE        = false
DEFAULT_ALLOW_CREATE_ORGANIZATION = true
DEFAULT_ENABLE_TIMETRACKING       = true
NO_REPLY_ADDRESS                  = noreply.localhost

[picture]
DISABLE_GRAVATAR        = false
ENABLE_FEDERATED_AVATAR = true

[openid]
ENABLE_OPENID_SIGNIN = true
ENABLE_OPENID_SIGNUP = true

[session]
PROVIDER = file

[log]
MODE      = file
LEVEL     = info
ROOT_PATH = /usr/local/bin/log" | sudo tee /etc/gitea/app.ini

sudo firewall-cmd --add-port=3000/tcp --permanent

sudo firewall-cmd --reload

echo "[Unit]
# Permet de rédiger la description du service gitea.
Description=Service Git qui se nomme Gitea
# Permet d'indiquer que le service Gitea se lancera après ces services.
After=syslog.target
After=network.target
# Indique que le service requis le service MariaDB.
#Requires=mariadb.service

[Service]
RestartSec=2s
Type=simple
User=git
Group=git
WorkingDirectory=/var/lib/gitea/
ExecStart=/usr/bin/sudo /usr/local/bin/gitea web --config /etc/gitea/app.ini
Restart=always
Environment=\"USER=git\"
HOME=/home/git
GITEA_WORK_DIR=/var/lib/gitea
[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/gitea.service

echo "git     ALL=(ALL)  NOPASSWD: ALL
nfsnobody     ALL=(ALL)  NOPASSWD: ALL" | sudo tee -a /etc/sudoers

sudo cp gitea /usr/local/bin/gitea

sudo chmod 750 /etc/gitea

sudo chmod 640 /etc/gitea/app.ini

mkdir -p /media/nfs

sudo mount 192.168.2.14:/opt/gitea /media/nfs

mkdir /opt/backup

sudo chown nfsnobody:nfsnobody /opt/backup

echo "#!/bin/bash
# Craoutch
# 15/03/2021
# Script Sauvegarde Gitea

# Les variables qui seront utilisé dans le script.

heure=\$(date +%H%M);
jour=\$(date +%Y%m%d);
nom_sauvegarde=\"gitea_\${jour}_\${heure}\";
chemin_fermer=\"/opt/backup/bloque\";
chemin_sauvegarde=\"/media/nfs/\";

if test -f \${chemin_fermer};
then
        exit 22;
fi

touch \${chemin_fermer};

sudo ./gitea dump -c /etc/gitea/app.ini;

fichier=\$(sudo ls /home/vagrant/ | grep .zip)

sudo cp \${fichier} \${chemin_sauvegarde}\${nom_sauvegarde};

sudo rm -rf \${fichier};

if test \$? -eq 0;
then
        echo \"La sauvegarde \${chemin_sauvegarde}\${nom_sauvegarde} c'est bien passé.\";
else
        echo \"La sauvegarde \${chemin_sauvegarde}\${nom_sauvegarde} a échoué.\" >&2;
fi


rm -rf \${chemin_fermer};" | sudo tee /opt/backup/sauvegarde.sh

sudo chown nfsnobody:nfsnobody /opt/backup/sauvegarde.sh

sudo chmod 700 /opt/backup/sauvegarde.sh

echo "  0  0  *  *  * nfsnobody bash /opt/backup/sauvegarde.sh" | sudo tee -a /etc/crontab

sudo usermod -G git nfsnobody

sudo systemctl daemon-reload

sudo systemctl enable gitea.service

sudo systemctl start gitea.service
