terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.42.0"
    }
  }
}

# ServiceAccountとProviderをGithubSecretに登録する場合はこちら
data "github_repository" "repository" {
  full_name = var.repository_full_name 
}

resource "github_actions_secret" "identity_provider" {
  repository = data.github_repository.repository.name
  secret_name = "GCP_IDENTITY_PROVIDER"
  plaintext_value = var.workload_identity_pool_provider_name
}

resource "github_actions_secret" "service_account" {
  repository = data.github_repository.repository.name
  secret_name = "GCP_SERVICE_ACCOUNT"
  plaintext_value = var.service_account_email
}
