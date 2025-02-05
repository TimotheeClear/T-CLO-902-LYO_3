# Connecter Terraform à Azure (localement)

Il faut installer l’Azure CLI. 

[https://learn.microsoft.com/fr-fr/cli/azure/install-azure-cli](https://learn.microsoft.com/fr-fr/cli/azure/install-azure-cli)

Lancer : `az login --user <myAlias@myCompany.com> -password <myPassword>` 

Cette commande va nous rediriger vers notre navigateur et va nous demander de nous connecter à notre compte Azure.

Sur Azure, on fonctionne avec des “subscription”, dans notre cas on possiblement deux subscriptions : celui pour notre projet kubequest et celui de notre azure student. Pour lister les subscription sur notre compte Azure il faut faire : 

`az account list`

Il faut se placer dans un subscription pour que Terraform construit les services dans le subscription et qu’on puisse utiliser les crédits sur cette subscription, on va se placer dans la subscription “Azure student”, pour faire cela on fait : 

`az account set --subscription "My Demos"` 

Pour vérifier qu’on est bien dans la subscription on fait : `az account show`

On se déplace vers les répertoires qui contient nos fichier Terraform, puis on lance les commandes :

`terraform init` 

`terraform validate`

`terraform plan`

`terraform validate`

`terraform apply` 

Tous cela va déployer des services sur le compte Azure avec laquel on s’est connecté avec 

`az login`

Lorsque nos testes sont fini il suffit de faire : 

`terraform destroy` 

Pour détruire tous ce qui a été construit sur le compte Azure.