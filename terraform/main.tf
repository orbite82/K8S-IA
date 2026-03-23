terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.19"
    }
  }
};

# ======================
# Namespace
# ======================
resource "kubernetes_namespace_v1" "app_ns" {
  metadata {
    name = "app-namespace"
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
    replicas = 2

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
          image = "my-local-app:latest"

          port {
            container_port = 8080
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
    replicas = 1

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
          image = "postgres:15-alpine"

          port {
            container_port = 5432
          }

          env {
            name  = "POSTGRES_USER"
            value = "admin"
          }
          env {
            name  = "POSTGRES_PASSWORD"
            value = "admin123"
          }
          env {
            name  = "POSTGRES_DB"
            value = "mydb"
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
# Services
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
      target_port = 8080
    }

    type = "ClusterIP"
  }
}

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
      target_port = 5432
    }

    type = "ClusterIP"
  }
}