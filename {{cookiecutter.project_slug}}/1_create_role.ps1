$role = [Microsoft.Azure.Commands.Resources.Models.Authorization.PSRoleDefinition]::new()

$role.Name = "{{cookiecutter.role_name}}"
$role.Description = "{{cookiecutter.role_desc}}"
$role.IsCustom = $true
$role.Actions = "Microsoft.Support/*"
$role.AssignableScopes = "/subscriptions/{{cookiecutter.subscription_id}}"

New-AzRoleDefinition -Role $role