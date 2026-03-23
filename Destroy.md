1️⃣ Destruir recursos criados pelo Terraform

Dentro da pasta terraform/:

```
cd ~/K8S-IA/terraform
terraform destroy
```

O Terraform vai mostrar um plano de destruição dos recursos (Deployments, Services, Namespace).
Quando solicitado, digite yes.

Isso vai remover:

Namespace app-namespace
Deployment da aplicação Python
Deployment do PostgreSQL
Services my-app-service e postgres-service

2️⃣ Parar e deletar o cluster Minikube

Se você está usando Minikube para o cluster local:

# Parar o cluster

```
minikube stop --profile k8s-ia
```
# Deletar o cluster

```
minikube delete --profile k8s-ia
```

Isso remove todos os pods, deployments, services e volumes criados dentro do Minikube.

3️⃣ Limpar imagens locais (opcional)

Se você quer liberar espaço no Docker:

# Listar imagens

```
docker images
```

# Remover a imagem da aplicação local

```
docker rmi my-local-app:latest
```