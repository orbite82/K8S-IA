# ======================
# Namespace
# ======================
resource "kubernetes_namespace_v1" "app_ns" {
  metadata {
    name = var.namespace_name
  }
}

# ======================
# Deployment: Aplicação
# ======================
resource "kubernetes_deployment_v1" "app" {
  metadata {
    name      = "my-app"
    namespace = kubernetes_namespace_v1.app_ns.metadata[0].name
    labels = {
      app = "my-app"
    }
  }

  spec {
    replicas = var.app_replicas

    selector {
      match_labels = {
        app = "my-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "my-app"
        }
      }

      spec {
        container {
          name  = "my-app"
          image = var.app_image

          port {
            container_port = var.app_container_port
          }

          resources {
            limits = {
              cpu    = "500m"
              memory = "256Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "128Mi"
            }
          }
        }
      }
    }
  }
}

# ======================
# Deployment: PostgreSQL
# ======================
resource "kubernetes_deployment_v1" "postgres" {
  metadata {
    name      = "postgres"
    namespace = kubernetes_namespace_v1.app_ns.metadata[0].name
    labels = {
      app = "postgres"
    }
  }

  spec {
    replicas = var.postgres_replicas

    selector {
      match_labels = {
        app = "postgres"
      }
    }

    template {
      metadata {
        labels = {
          app = "postgres"
        }
      }

      spec {
        container {
          name  = "postgres"
          image = var.postgres_image

          port {
            container_port = var.postgres_port
          }

          env {
            name  = "POSTGRES_USER"
            value = var.postgres_user
          }
          env {
            name  = "POSTGRES_PASSWORD"
            value = var.postgres_password
          }
          env {
            name  = "POSTGRES_DB"
            value = var.postgres_db
          }

          resources {
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "256Mi"
            }
          }
        }
      }
    }
  }
}

# ======================
# Service: Aplicação
# ======================
resource "kubernetes_service_v1" "app_service" {
  metadata {
    name      = "my-app-service"
    namespace = kubernetes_namespace_v1.app_ns.metadata[0].name
  }

  spec {
    selector = {
      app = "my-app"
    }

    port {
      port        = 80
      target_port = var.app_container_port
    }

    type = "ClusterIP"
  }
}

# ======================
# Service: PostgreSQL
# ======================
resource "kubernetes_service_v1" "postgres_service" {
  metadata {
    name      = "postgres-service"
    namespace = kubernetes_namespace_v1.app_ns.metadata[0].name
  }

  spec {
    selector = {
      app = "postgres"
    }

    port {
      port        = 5432
      target_port = var.postgres_port
    }

    type = "ClusterIP"
  }
}