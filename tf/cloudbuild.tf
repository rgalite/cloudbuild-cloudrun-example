resource "google_cloudbuild_trigger" "default" {
  trigger_template {
    branch_name = "main"
    repo_name   = google_sourcerepo_repository.default.name
    dir = "app"
  }

  build {
    step {
      name = "gcr.io/cloud-builders/docker"
      args = ["build", "-t", "gcr.io/${var.project_id}/app:$COMMIT_SHA", "."]
    }

    step {
      name = "gcr.io/cloud-builders/docker"
      args = [
        "run",
        "gcr.io/${var.project_id}/app",
        "./vendor/bin/phpunit"
      ]
    }

    step {
      name = "gcr.io/cloud-builders/docker"
      args = [
        "push",
        "gcr.io/${var.project_id}/app:$COMMIT_SHA"
      ]
    }

    step {
      name = "gcr.io/google.com/cloudsdktool/cloud-sdk"
      entrypoint = "gcloud"
      args = [
        "run",
        "deploy",
        "${var.project_id}-srv",
        "--image",
        "gcr.io/${var.project_id}/app:$COMMIT_SHA",
        "--region",
        var.region,
        "--platform",
        "managed"
      ]
    }
  }

  depends_on = [
    google_project_service.sourcerepo,
    google_sourcerepo_repository.default
  ]
}

resource "google_project_iam_binding" "cloudbuild_iam" {
  project = var.project_id
  role    = "roles/run.admin"

  members = [
    "serviceAccount:${var.project_number}@cloudbuild.gserviceaccount.com"
  ]
}

resource "google_project_iam_binding" "cloudbuild_sa" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"

  members = [
    "serviceAccount:${var.project_number}@cloudbuild.gserviceaccount.com"
  ]
}
