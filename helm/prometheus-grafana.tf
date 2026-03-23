resource "helm_release" "kube_prometheus_stack" {
  name       = "prometheus-stack"
  namespace  = "monitoring"
  create_namespace = true
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "55.3.0"  # ajuste conforme a versão mais recente do chart

  values = [
    <<EOF
grafana:
  adminUser: admin
  adminPassword: admin
  service:
    type: NodePort
EOF
  ]
}