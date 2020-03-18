$filename = "./role-base.json"
$role = (Get-Content $filename | ConvertFrom-Json)
New-AzRoleDefinition -Role $role