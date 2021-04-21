# Remove custom role
$name = "{{cookiecutter.role_name}}"
Get-AzRoleDefinition -Name $name | Remove-AzRoleDefinition

# Remove service principal and its credentials
$sp = Get-Content sp.json | ConvertFrom-Json
Remove-AzADSpCredential -DisplayName $sp.DisplayName
@("sp.json", "sp_password.txt", "sp_tenantid.txt") | Remove-Item -Confirm