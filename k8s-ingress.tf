resource "kubernetes_ingress_v1" "webapp_ingress" {
  metadata {
    name = "webapp-ingress"

    annotations = {
      "alb.ingress.kubernetes.io/scheme"       = "internet-facing"
      "alb.ingress.kubernetes.io/listen-ports" = jsonencode([{ "HTTP" = 80 }])
      "alb.ingress.kubernetes.io/target-type"  = "ip"
      "alb.ingress.kubernetes.io/subnets"      = "subnet-0b3e9ab7f164afebf,subnet-08c59f3ad14d9b889"

      "alb.ingress.kubernetes.io/healthcheck-path"     = "/"
      "alb.ingress.kubernetes.io/healthcheck-port"     = "8080"
      "alb.ingress.kubernetes.io/healthcheck-protocol" = "HTTP"

    }
  }

  spec {
    ingress_class_name = "alb"

    rule {
      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service.webapp.metadata[0].name
              port {
                number = 8080
              }
            }
          }
        }
      }
    }
  }
}
