<div align="center">
<img src="https://user-images.githubusercontent.com/47891196/139104117-aa9c2943-37da-4534-a584-e4e5ff5bf69a.png" width="350px" />
</div>

# K8S-IA
Treinar subir um k8s via IA

Repositório de estudo e deploy local de Kubernetes com Terraform, Minikube e uma aplicação Python + PostgreSQL, incluindo monitoramento via Helm (Prometheus + Grafana).

Estrutura do projeto

```
K8S-IA/
├── app/                     # Aplicação Python
│   ├── app.py
│   ├── Dockerfile
│   └── requirements.txt
├── helm/                    # Charts Helm para monitoramento
│   └── prometheus-grafana.tf
├── kind-config.yaml         # Config Kind (opcional)
├── LICENSE
├── README.md
└── terraform/               # Terraform para Kubernetes
    ├── main.tf
    ├── output.tf
    ├── providers.tf
    ├── variables.tf
    ├── terraform.tfstate
    └── setup-minikube.sh    # Script para criar/configurar Minikube
```
Requisitos
Docker instalado
Minikube ou Kind instalado
Kubectl instalado
Terraform >= 1.6.0

O script setup-minikube.sh automatiza a criação do cluster Minikube e configuração do kubectl.

Passo a passo para executar
✅ 1. Clonar o repositório

```
git clone https://github.com/orbite82/K8S-IA.git
cd K8S-IA/terraform
```
✅ 2. Build da aplicação Docker

Dentro da pasta app/:

```
cd ../app
docker build -t my-local-app:latest .
docker images
```
✅ 3. Inicializar Minikube

Dentro da pasta terraform/:

```cd ../terraform
chmod +x setup-minikube.sh
./setup-minikube.sh
```
O script faz:

Verifica/instala Minikube (se necessário)
Cria o cluster k8s-ia
Configura o kubectl para usar o cluster
Mostra nodes ativos e namespace padrão

Você também pode iniciar manualmente com:

```
minikube start --profile k8s-ia --driver=docker
kubectl get nodes
kubectl get namespaces
```

✅ 4. Configurar provider do Terraform

No arquivo terraform/providers.tf:

```
provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "k8s-ia"
}

```
Isso garante que o Terraform se conecte ao cluster correto.

✅ 5. Inicializar Terraform

Dentro da pasta terraform/:

```
terraform init
```

Baixa plugins e providers necessários
Se houver problema de versão do provider, rode:

```
terraform init -upgrade
```
✅ 6. Visualizar o plano

```
terraform plan
```
Confirme que serão adicionados 5 recursos:
 Namespace app-namespace
 Deployment my-app
 Deployment postgres
 Service my-app-service
 Service postgres-service

✅ 7. Aplicar os recursos no cluster

```
terraform apply
```
Digite yes quando solicitado
O Terraform cria todos os recursos no cluster k8s-ia

✅ 8. Verificar os recursos no Kubernetes

```
kubectl get namespaces
kubectl get deployments -n app-namespace
kubectl get pods -n app-namespace
kubectl get svc -n app-namespace
```
Confirme que deployments, pods e services estão rodando no namespace app-namespace.

✅ 9. Acessar a aplicação localmente

```
kubectl port-forward svc/my-app-service 8080:80 -n app-namespace
```
Abra no navegador:

```
http://localhost:8080
```

✅ 10. Acessar o PostgreSQL

```
kubectl port-forward svc/postgres-service 5432:5432 -n app-namespace
```

Conectar via cliente PostgreSQL:

```
Host: localhost
Port: 5432
User: admin
Password: admin123
Database: mydb
```

✅ 11. Monitoramento (opcional)

Se você tiver Helm configurado, rode os charts em:

```
helm/prometheus-grafana.tf
```

🧠 Dicas importantes

Sempre que mudar arquivos .tf, rode:

```
terraform plan
terraform apply
```

Se mudar o contexto do cluster, verifique:

```
kubectl config current-context
kubectl config use-context k8s-ia
```

Para remover todos os recursos do cluster:

```
terraform destroy
```

🚀 Próximos passos

Depois de implantar com sucesso, você pode:

Automatizar em um pipeline CI/CD
Adicionar Ingress para expor a aplicação
Adicionar Secrets/ConfigMaps via Terraform
Gerenciar volumes persistentes