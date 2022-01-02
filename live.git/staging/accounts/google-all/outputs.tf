output "workspace-users" {
  value = module.google-workspaces.workspace-users
  sensitive = true
}

output "workspace-admin-roles" {
  value = module.google-workspaces.workspace-admin-roles
  sensitive = true
}
