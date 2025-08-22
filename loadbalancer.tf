resource "kubernetes_service" "webapp" {
  metadata {
    name = "webapp-service"
  }

  spec {
    selector = {
      app = "webapp"
    }

    port {
      port        = 80
      target_port = 8080
    }

    type = "ClusterIP"
  }
}
