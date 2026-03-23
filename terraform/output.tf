# ======================
# Outputs: Namespace
# ======================
output "namespace_name" {
  description = "Nome do namespace criado no Kubernetes"
  value       = kubernetes_namespace_v1.app_ns.metadata[0].name
}

# ======================
# Outputs: Aplicação
# ======================
output "app_service_name" {
  description = "Nome do Service da aplicação"
  value       = kubernetes_service_v1.app_service.metadata[0].name
}

output "app_service_cluster_ip" {
  description = "ClusterIP do Service da aplicação"
  value       = kubernetes_service_v1.app_service.spec[0].cluster_ip
}

# ======================
# Outputs: PostgreSQL
# ======================
output "postgres_service_name" {
  description = "Nome do Service do PostgreSQL"
  value       = kubernetes_service_v1.postgres_service.metadata[0].name
}

output "postgres_service_cluster_ip" {
  description = "ClusterIP do Service do PostgreSQL"
  value       = kubernetes_service_v1.postgres_service.spec[0].cluster_ip
}