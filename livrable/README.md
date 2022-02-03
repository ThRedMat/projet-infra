# Documentation

## Installe Vagrant

En téléchargant les modules pour le vagrante, vous devrier aussi faire quelque petit trucs :

- Aller dans votre disque C:\
- Creer un dossier "clef"
- Copier dedans ce dossier votre id_rsa.pub

Vous trouverez ce fichier dans : C:\Users\votre-user\.ssh

Une fois fais la racine devrais être comme ceci :

```bash
C:\clef\id_rsa.pub
```

## Installe Jenkins (seulement sur Windows 10 Pro)

1. Lien de téléchargement : [liens](https://www.jenkins.io/download/)

2. Unzip le dossier et lance le fichier Jenkins.

3. Cliquez sur le bouton “Suivant” to start the installation.

4. Cliquez sur le bouton «Modifier…» si vous souhaitez installer Jenkins dans un autre dossier. Dans cet exemple, je vais garder l'option par défaut et cliquer sur le bouton «Suivant».

5. Cliquez sur le bouton «Installer» pour démarrer le processus d'installation.

6. L'installation se poursuivra.

7. Une fois terminé, cliquez sur le bouton «Terminer» pour terminer le processus d'installation.

8. Vous serez automatiquement redirigé vers une page Jenkins locale, ou vous pouvez coller l'URL http: // localhost: 8080 dans un navigateur.

9. Pour déverrouiller Jenkins, copiez le mot de passe du fichier C: \ Program Files (x86) \ Jenkins \ secrets \ initialAdminPassword et collez-le dans le champ Mot de passe administrateur. Ensuite, cliquez sur le bouton «Continuer».

10. Vous pouvez installer les plugins suggérés ou les plugins sélectionnés de votre choix. Pour faire simple, nous installerons les plugins suggérés.

11. Attendez que les plugins soient complètement installés.

12. La prochaine chose que vous devez faire est de créer un utilisateur Admin pour Jenkins. Ensuite, entrez vos coordonnées et cliquez sur «Enregistrer et continuer».

13. Cliquez sur «Enregistrer et terminer» pour terminer l'installation de Jenkins.

14. Maintenant, cliquez sur «Commencer à utiliser Jenkins» pour démarrer Jenkins.

15. Enfin, voici la page Jenkins par défaut.

## Installe Localtunnel

Pour installez Localtunnel globalement (nécessite NodeJS) pour le rendre accessible n'importe où:

```
npm install -g localtunnel
```

Démarrez un serveur Web sur un port local (par exemple http: // localhost: 8080) et utilisez l'interface de ligne de commande pour demander un tunnel vers votre serveur local:

```
lt --port 8080
```

Vous recevrez une URL, par exemple https://gqgh.localtunnel.me, que vous pourrez partager avec n'importe qui tant que votre instance locale de lt reste active. Toutes les demandes seront acheminées vers votre service local au port spécifié.
