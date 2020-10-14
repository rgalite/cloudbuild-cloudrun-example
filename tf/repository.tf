resource "google_sourcerepo_repository" "default" {
  name = "${var.project_id}-repository"
}
