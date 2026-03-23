##########################################
# OUTPUTS.TF - Informações úteis pós deploy
##########################################

# Namespace da aplicação
output "app_namespace" {
  description = "Namespace da aplicação"
  value       = kubernetes_namespace.app_ns.metadata[0].name
}

# Nome do deployment da aplicação
output "app_deployment_name" {
  description = "Nome do deployment da aplicação"
  value       = kubernetes_deployment.app.metadata[0].name
}

# NodePort da aplicação (acesso externo)
output "app_node_port" {
  description = "NodePort para acessar a aplicação"
  value       = kubernetes_service.app_svc.spec[0].port[0].node_port
}

# ClusterIP do PostgreSQL
output "postgres_service_cluster_ip" {
  description = "ClusterIP do PostgreSQL"
  value       = kubernetes_service.postgres_svc.spec[0].cluster_ip
}

# Nome do deployment PostgreSQL
output "postgres_deployment_name" {
  description = "Nome do deployment PostgreSQL"
  value       = kubernetes_deployment.postgres.metadata[0].name
}