output "workload_identity_pool_name" {
  value = google_iam_workload_identity_pool.main.name 
}
output "service_account_name" {
  value = google_service_account.github_actions_sa.email
}

