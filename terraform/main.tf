terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.10.0"
    }
  }
}

resource "google_iam_workload_identity_pool" "main" {
  project = var.project_id
  workload_identity_pool_id = "firebase-pool" 
  description = "For Firebase Projects"
  display_name = "firebase-pool"
}

resource "google_iam_workload_identity_pool_provider" "github_provider" {
  project = var.project_id
  workload_identity_pool_id = google_iam_workload_identity_pool.main.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-actions-provider"
  display_name = "Github Identity Provider"
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
    allowed_audiences = []
  }
  attribute_mapping = {
    "google.subject"       = "assertion.sub",
    "attribute.actor"      = "assertion.actor",
    "attribute.repository" = "assertion.repository",
  }
}

resource "google_service_account" "github_actions_sa" {
  project = var.project_id
  account_id = "github-actions"
  description = "GithubActionsデプロイ用"
}

resource "google_project_iam_member" "github_actions_sa" {
  project = var.project_id
  role = "roles/firebase.admin"
  member = "serviceAccount:${google_service_account.github_actions_sa.email}"
}

resource "google_service_account_iam_binding" "github_actions_sa" {
  service_account_id = google_service_account.github_actions_sa.name
  members =  ["principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.main.name}/attribute.repository/${var.github_repository}"]
  role = "roles/iam.workloadIdentityUser"
}
