resource "google_sourcerepo_repository" "default" {
  name = "${var.project_id}-repository"

  depends_on = [
    google_project_service.sourcerepo,
  ]
}
