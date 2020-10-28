resource "google_redis_instance" "redis" {
  name           = "memory-cache"
  memory_size_gb = 1

  depends_on = [
    google_project_service.redis
  ]
}
