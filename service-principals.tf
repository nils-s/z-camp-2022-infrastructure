data "azuread_client_config" "current" {}

resource "azuread_application" "image-upload-application" {
  display_name = "container image uploader"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "image-upload-user" {
  application_id               = azuread_application.image-upload-application.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal_password" "image-upload-user-password" {
  service_principal_id = azuread_service_principal.image-upload-user.object_id
}

output "image-pusher-client-id" {
  value       = azuread_service_principal.image-upload-user.application_id
  description = "Client-ID for the user that is used to push container images into the Azure container registry; add this in GitHub"
}

output "image-pusher-password" {
  value       = azuread_service_principal_password.image-upload-user-password.value
  description = "Password to log into the Azure container registry; add this as a secret in GitHub"
  sensitive   = true
}