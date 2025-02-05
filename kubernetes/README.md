# Configuration du cluster

## Créer un accés pour un Admins

### Créer un utilisateur et lui donner le role Cluster-admin

Pour réaliser cela il faut ***se connecter sur le Control Plane du cluster kubernetes***.  
Nous profitons de cette manipulation pour créer un groupe pour les administrateurs que l'on utilisera plus tard avec l'authentification Dex. 
 
1) Cette commande va créer un utilisateur administrateur et un groupe pour des administrateurs.  
```bash
kubectl create clusterrolebinding admin-role --clusterrole=cluster-admin --user={username} --group="kubequestlyo3:admins"
```

2) Cette commande va créer un fichier de configuration pour kubectl.  
```bash
sudo kubeadm kubeconfig user --client-name={username} | tee /home/{VM_USER}/admin.conf
```

3) Cette commande va modifier l'URL d'accès au cluster kubernetes dans le fichier de configuration pour kubectl.  
```bash
sed -i "s|https://[0-9.]\+:6443|https://<Cluster IP>:6443|" /home/{VM_USER}/admin.conf
```

## Devs RBAC

### Installer les RBACs pour les devs

Nous allons définir les roles pour les devs. Les fichiers que l'on a besoin sont stoqué dans le répertoire rbac/  
Tous d'abord, il nous faut créer le role que les devs.   
```bash
kubectl apply -f ./rbac/clusterrole_dev.yaml
```

Puis il nous faut créer un groupe pour les devs. Et on va appliqué le role à ce groupe.  
```bash
kubectl apply -f ./rbac/clusterrolebindin_dev.yaml
```

## Approuver les certificats des nodes

### Lister les certifications utiliser par nodes

Lorsque le cluster se construit, les nodes doivent s'authentifier à l'API Server. Pour cela les nodes demandent des certificats qu'il faut approuver manuellement.  
Pour lister les certificats lancer par les nodes, il faut faire :
```bash
kubectl get csr
```

Pour approuver les certificats, il faut faire :
```bash
kubectl certificat approve <certificat-node-0-name> <certificat-node-1-name> <certificat-node-master-name>
```

## Azure Cloud Provider 

Pour qu'on puisse créer des services Azure depuis l'intérieur du cluster, il nous faut installer un module. Pour configurer le module, il faut créer un fichier ***azure.json***, il faut placer le fichier sur le control panel dans le répertoire */etc/kubernetes/*. 
Le module que l'on va installer est Azure Cloud Provider. On utilise Helm pour installer l'Azure Cloud Provider. 
```bash
helm install --repo https://raw.githubusercontent.com/kubernetes-sigs/cloud-provider-azure/master/helm/repo cloud-provider-azure --generate-name --set cloudControllerManager.clusterCIDR="192.168.0.0/16"
```

## Installer le plugin réseau

Pour que les pods puissent communiquer entre eux, il nous faut installer un plugin réseau. Nous avons choisit d'utiliser le projet Calico comme plugin réseau pour ce projet. On va installer le plugin grace à Helm. 
```bash
helm repo add projectcalico https://docs.tigera.io/calico/charts
helm repo update
helm install calico projectcalico/tigera-operator --version v3.27.3 -f https://raw.githubusercontent.com/kubernetes-sigs/cluster-api-provider-azure/main/templates/addons/calico/values.yaml --namespace tigera-operator --create-namespace
```
Après l'installation de Calico, la Table de Routage de l'architecture du projet va mettre à jour.  

## Installer metric-servers

Pour qu'on puisse réaliser de l'autoscaling dans notre cluster kubernetes, il nous faut installer *metrics-server*. Ce module permet à l'objet kubernetes qui réalise l'autoscaling (HPA) a récupéré les métriques des pods pour réaliser l'autoscaling.
Pour installer metrics-server :
```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.7.1/components.yaml
```

## Installer Cert-manager

Pour permettre la gestion des certificats dans notre cluster kubernetes, on va utiliser Cert-Manager avec *Let's encrypt*.  
Pour installer Cert-manager :
```bash
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.15.0 --set crds.enabled=true
```

## Installer Ingress Controller Nginx

Nous avons besoin d'exposer nos applications sur internet. Pour faire cela, il nous faut installer un Ingress Controller. Nous avions choisit d'utiliser Nginx comme Ingress Controller.  
```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install ingress-nginx ingress-nginx/ingress-nginx \
            --version 4.10.1 \
            --namespace ingress-nginx \
            --create-namespace \
            --set controller.replicaCount=2 \
            --set rbac.create=true \
            --set controller.stats.enabled=true \
            --set controller.metrics.enabled=true \
            --set controller.nodeSelector."kubernetes\.io/os"=linux \
            --set controller.service.externalTrafficPolicy="Local" \
            --set controller.image.image=ingress-nginx/controller \
            --set controller.image.tag=v1.10.1 \
            --set controller.image.digest="" \
            --set controller.admissionWebhooks.patch.nodeSelector."kubernetes\.io/os"=linux \
            --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-resource-group"="kubequest_rg_ip" \
            --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-pip-name"="kubequest_ip_2" \
            --set controller.service.loadBalancerIP=20.47.81.24 \
            --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz \
            --set controller.admissionWebhooks.patch.image.image=ingress-nginx/kube-webhook-certgen \
            --set controller.admissionWebhooks.patch.image.tag=v1.4.1 \
            --set controller.admissionWebhooks.patch.image.digest="" \
            --set defaultBackend.nodeSelector."kubernetes\.io/os"=linux \
            --set defaultBackend.image.image=defaultbackend-amd64 \
            --set defaultBackend.image.tag=1.5 \
            --set defaultBackend.image.digest="" \
            --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer"="true"
```  
Un Azure Load Balancer va être créer dans l'architecture du projet car dans le cluster kubernetes Nginx va créer un service Load Balancer. Ce service Load Balancer va avoir comme adresse IP publique la même adresse IP publique que l'Azure Load Balancer. Lorsque l'Azure Load Balancer est crée, il faut ajouter à la main les VMs de notre cluster dans le Backend Pool de cette Azure Load Balancer à la main.  

## Installer OPA Gatekeeper

Nous avons besoin d'appliquer des permissions de manière générale sur notre cluster kubernetes. Le module qui nous permet de réaliser cela est *OPA Gatekeeper*.  
Pour installer OPA Gatekeeper :
```bash
helm repo add gatekeeper https://open-policy-agent.github.io/gatekeeper/charts
helm repo update
helm install gatekeeper/gatekeeper --name-template=gatekeeper --namespace gatekeeper-system --create-namespace
```
Pour définir nos règles, nous devont créer un *constraintTemplate* qui va valider la créaton d'objet kubernetes. OPA Gatekeeper réalise cela avec du code *Rego*.  
Nos fichier YAML à installer sont dans le répertoire OPA_rules/  
Installer le ConstraintTemplate :
```bash
kubectl apply -f OPA_rules/labels/constraintTemplate.yaml
```
Pour définir sur quel objet les validations doivent être faite, on doit installer un *constraint*.  
Installer le Constraint :
```bash
kubectl apply -f OPA_rules/labels/constraint.yaml
```  
Si on a besoin de faire d'autre type de validation sur des objets kubernetes, il nous faut créer d'autre fichier *constraintTemplate* et *constraint*.  

## Installer Dex avec Github et dex_k8s_authenticator

Nous avons besoin de mettre en place de l'authentification sur l'API Server de notre cluster kubernetes. Nous allons utiliser Github comme fournisseur d'indentité. Nous avons créer une organisation sur Github. Pour chaque équipe dans notre projet nous avons créer une Teams dans l'organisation. Une Teams pour les administrateurs, une Teams pour les developpers...  
Pour que l'on puisse identifier une personne sur notre API Server Kubernetes, on a besoin d'un module. Ce module sera installer sur le cluster kubernetes. Nous devons utiliser Dex.  
Pour offrir une manipulation plus user friendly nous avons décidé d'utiliser un frontend à Dex.  
On a choisit d'utiliser dex_k8s_authenticator comme front end à dex. 

Nous avons besoin de deux DNS valident pour mettre en place le module dex et dex_k8s_authenticator.  
Pour dex nous avons le DNS : dex.kubequest.net  
Pour dex_k8s_authenticator nous avons le DNS : dexfront.kubequest.net  

Nous avons utiliser des Ingress pour exposer nos deux modules. Nous avons créés deux Ingress avec les deux DNS.  

Pour pouvoir créer ces ingress, nous avons besoin de créer des certificats avec Cert-manager donc nous devons créer des Issuers. Vous pouvez voir les fichiers de configuration des Issurs dans les répertoires :  
- Issuer Dex : dex/issuer.yaml
- Issuer Dex_k8s_authenticator : dex/dex_k8s_kubernetes/issuer.yaml

Pour installer les issuers, il faut faire :
```bash
kubectl apply -f dex/issuer.yaml -f dex/dex_k8s_kubernetes/issuer.yaml
```

Pour installer dex et dex_k8s_authentificator nous devons utiliser Helm.  
Les helm charts de ces modules ont besoin des fichiers values. 
Ce fichier nous sert à définir des paramètres que l'on a besoin pour notre projet.  
Le fichier values pour le module dex se trouve dans dex/values.yaml  
Le fichier values pour le module dex_k8s_authenticator se trouve dans dex/dex_k8s_authenticator/values_news.yaml  

Maintenant que l'on a tous ce qu'il nous faut, nous allons installer dex et dex_k8s_authenticator :  

```bash
helm repo add dex https://charts.dexidp.io
helm repod update
helm install dex --namespace dex --create-namespace --values dex/values.yaml dex/dex
```  
```bash
helm repo add wiremind https://wiremind.github.io/wiremind-helm-charts
helm repo update
helm install dex-k8s-authenticator wiremind/dex-k8s-authenticator --version 1.7.0 --namespace dex --values dex/dex_k8s_kubernetes/values_news.yaml
```  
Pour vérifier que tous fonctionne, il suffit d'aller sur le DNS de dex_k8s_authentificator et se connecter avec Github via l'organisation du projet.  

## Installer kubernetes dashboard

On a besoin de monitorer les containers de notre cluster kubernetes. Pour cela, nous allons installer kubernetes-dashboard.  
Nous devons exposer cette solution sur internet pour que l'on puisse y acceder depuis l'extérieure. Nous avons besoin d'un ingress et d'un issuer.  
Nous avons aussi besoin d'un DNS.  
Nous avons ce DNS : kube-dash.sample-click.net  
Les fichiers que l'on a besoin pour cela pour ce module se trouvent dans le répertoire : monitoring/kube-dash/  
Nous allons installer kubernetes-dashboard avec helm :  
```bash
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm repo update
helm install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard
```
Puis nous installons l'Ingress et l'Issuer :  
```bash
kubectl apply -f monitoring/kube-dash/issuer.yaml -f monitoring/kube-dash/ingress.yaml
```  
Après quelques secondes nous pouvons aller sur le DNS.  
Pour se connecter au kubernetes-dashboard, nous devons créer un Token de service. Pour avoir ce Token, nous devons créer un Service Account Kubernetes qui va endosser ce Token.  
Le fichier pour créer le service account est dans : monitoring/kube-dash/  
Pour l'installer nous devons faire :  
```bash
kubectl apply -f monitoring/kube-dash/service_account.yaml
```
Maintenant nous pouvons créer un Token de connexion sur le kubernetes-dashboard :  
```bash
kubectl -n kubernetes-dashboard create token dashboard-admin
```
Cette commande va retourner le Token que l'on a besoin. En retournant sur la page de connexion de kubernetes-dashboard on utiliser le Token et nous serons connecter.  
Nous pourrons alors monitorer les containers du cluster kubernetes.  

## Installer Prometheus Grafana

Pour collecter et visualiser les métriques de notre cluster nous avons besoin d'installer prometheus-grafana.  
Nous avons décider d'utiliser prometheus-grafana-stack.  
Nous avons besoin d'accéder à cette solution via internet. Donc on a besoin d'un DNS, d'un Ingress et d'un Issuer.  
Le DNS : grafana-prome.sample-click.net  
L'Ingress et l'Issuer sont dans monitoring/prometheus-grafana/  

Pour installer prometheus-grafana :  
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus-grafana prometheus-community/kube-prometheus-stack --create-namespace --namespace kube-prometheus
```
Pour installer l'Ingress et l'Issuer :  
```bash
kubectl apply -f monitoring/prometheus-grafana/ingress.yaml -f monitoring/prometheus-grafana/issuer.yaml
```
On va sur le DNS pour ouvrir notre prometheus-grafana. Pour se connecter, nous avons besoin d'aller chercher un secret qui a été crée par l'installation de prometheus-grafana :  
```bash
kubectl get secret prometheus-grafana -n kube-prometheus -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```
Grace à cela nous pouvons nous connecter avec l'user : admin et le mot de passe afficher par la commande précédante.  

## Installer Loki 

Nous avons besoin de monitorer les logs de chaques applications dans notre cluster kubernetes. Pour cela nous allons utiliser loki-grafana.  
Nous avons besoin d'un DNS, d'un Ingress et d'un Issuer pour pouvoir exposer notre loki-grafana sur internet.  
Le DNS : grafana-loki.sample-click.net
Les fichiers ingress et issuer sont dans : monitoring/loki-grafana/

Pour installer loki-grafana : 
```bash
helm repo add loki-grafana https://grafana.github.io/helm-charts
helm repo update
helm install loki loki-grafana/loki-stack --namespace loki --create-namespace --set grafana.enabled=true
```
Pour installer l'Ingress et l'Issuer :  
```bash
kubectl apply -f monitoring/loki-grafana/ingress.yaml -f monitoring/loki-grafana/issuer.yaml
```
On va sur le DNS pour ouvrir notre loki-grafana. Pour se connecter, nous avons besoin d'aller chercher un secret qui a été crée par l'installation de loki-grafana :  
```bash
kubectl get secret loki-grafana -n loki -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```
Grace à cela nous pouvons nous connecter avec l'user : admin et le mot de passe afficher par la commande précédante.  

## Installer MySQL DB

Nous avons besoin d'installer une base de donnée pour notre application. Nous avons crée un manifest pour configurer notre base de donnée selon ce que nous avons besoin.  
Nous avons besoin de créer un fichier secret pour notre base de donnée.  
Tous nos fichiers pour cette installation sont dans : mysql-db/
Pour installer la base de donnée :  
```bash
kubectl apply -f mysql-db/mysql_secrets.yaml -f mysql.yaml
```
Nous avons besoin de migrer la base de donnée de notre application sur cette nouvelle base de donnée.  
Pour faire cela, nous avons besoin de lancer un pod ephémer de notre application et de lancer la commande de migration.  
```bash
kubectl run -it --rm --image=michaelepitech/sample-app:0.0.2 --restart=Never migrate --env="APP_DEBUG=''" --env="APP_ENV=''" --env="APP_KEY=''" --env="DB_HOST=mysql-service.mysql-namespace.svc.cluster.local" --env="DB_CONNECTION=mysql" --env="DB_PORT=3306" --env="DB_DATABASE=''" --env="DB_USERNAME=''" --env="DB_PASSWORD=''" -- php artisan migrate
```
Bien évidement nous devons matcher les variables d'environnements de cette commande aux secrets que l'on a definit pour l'installation de la base de donnée.  

## Installer Sample-app 

Le helm chart de notre application est stocké sur artefacthub de helm. Avant d'installer notre application avec helm, il nous faut créer un fichier values.yaml avec les valeurs que l'on veut mettre en place.  
Pour installer l'application avec helm :  
```bash
helm repo add sample-app https://michaelranivoepitech.github.io/
helm repo update
helm install sample-app kubeuest/sample-app --version 0.1.2 -f values.yaml
```