# $filename = "./role.json"
# $role = (Get-Content $filename | ConvertFrom-Json)
# $name = $role.Name
$name = "{{cookiecutter.role_name}}"

Get-AzRoleDefinition -Name $name | Remove-AzRoleDefinition