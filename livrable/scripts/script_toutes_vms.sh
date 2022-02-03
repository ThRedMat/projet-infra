#!/bin/bash
# Craoutch
# 15/03/2021
# Permet de spécifier l'adresse du DNS, de créer l'utilisateur backup, et de configurer Netdata.

# La variable qui sera utilisée dans le script.

url='https://discord.com/api/webhooks/820947639193174026/Lycb7yRWlPhnUDFnke2JzJscf7mVzF6ZrtR-qKoNH63jb47M8A1LM6JheHU7LMYtVgxo';

echo "nameserver 1.1.1.1" | sudo tee /etc/resolv.conf

sudo useradd backup -M

/etc/netdata/edit-config health_alarm_notify.conf;

sudo sed -i "s/DEFAULT_RECIPIENT_DISCORD=\"\"/DEFAULT_RECIPIENT_DISCORD=\"alarms\"/" /etc/netdata/health_alarm_notify.conf

sudo sed -i "s/DISCORD_WEBHOOK_URL=\"\"/DISCORD_WEBHOOK_URL=\"${url}\"/" /etc/netdata/health_alarm_notify.conf

sudo firewall-cmd --add-port=19999/tcp --permanent

sudo firewall-cmd --reload;
