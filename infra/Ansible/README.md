This Ansible projet is for the preparation of the VMs to initiate a kubernetes cluster.
It's can initiate and delete the cluster.

Lorsque les clés ssh ont été télécheragé par terraform, il faut faire :

`chmod 400 /home/michael/Documents/Epitech/CLO/T-CLO-902/kubequest_902/terraform/infra/*.pem`

Il faut lancer : 

`source .env`

Cette commande charge les variables du fichier .env dans l'environnement actuel du shell. 
Elles seront disponibles pour les commandes suivantes. 
Comme cela la commande ansible sera capable de lire les variable dans .env
