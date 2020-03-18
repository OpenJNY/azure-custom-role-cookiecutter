# $filename = "./role.json"
# $role = (Get-Content $filename | ConvertFrom-Json)
# $name = $role.Name
$name = "{{cookiecutter.role_name}}"

Write-Output (Get-AzRoleDefinition -Name $name)