output "repository_name" {
  description = "Nom du dépôt GitHub créé"
  value       = github_repository.vm_neutron_repo.name
}

output "repository_url" {
  description = "URL du dépôt GitHub"
  value       = github_repository.vm_neutron_repo.html_url
}

output "repository_id" {
  description = "Identifiant interne GitHub du dépôt"
  value       = github_repository.vm_neutron_repo.node_id
}