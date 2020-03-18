$filename = "./role.json"
$role = (Get-Content $filename | ConvertFrom-Json)
$role.Id = (Get-AzRoleDefinition -Name $role.Name).Id
Set-AzRoleDefinition -Role $role