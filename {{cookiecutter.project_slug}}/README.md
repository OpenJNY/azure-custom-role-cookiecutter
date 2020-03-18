# {{cookiecutter.project_name}}

You can create a custom role according to the following steps:

- Select a subscription which can create custom roles.
- Run `.\create.ps1` to create a base role
- Assign the role to a test user (e.g. service principal)
- Repeat this until the role definition is completed:
  - The user performs desired operation.
    - If an error occurs, edit parameters (e.g. `Actions`) in `role.json` according to the error message.
    - If not, your custom role is completed!
  - Run `.\update.ps1` to update the role, updating roles may take a few miunites.
    - **Note:** You can use `.\get.ps` to check the current definition of the role on Azure.
  - The user sign-out and sign-in again for the changes to take effect.

## Cheatsheets

### Custom Role

```powershell
# Select subscription
Select-AzSubscription -Subscription {{cookiecutter.subscription_id}}

# Listing all custom role names
Get-AzRoleDefinition | ? { $_.IsCustom -eq $true } | FT Name, IsCustom

# Create new role from json
New-AzRoleDefinition -InputFile "role.json"

# Get custome role
Get-AzRoleDefinition "{{cookiecutter.role_name}}"

# Update custome role
$role = Get-AzRoleDefinition "{{cookiecutter.role_name}}"
$role.Actions.Add("Microsoft.Insights/diagnosticSettings/*")
Set-AzRoleDefinition -Role $role

# Delete custom role
Get-AzRoleDefinition "{{cookiecutter.role_name}}" | Remove-AzRoleDefinition
```

### Service Principal

```powershell
# Create a new SP
$sp = New-AzADServicePrincipal -DisplayName "test_sp_{{cookiecutter.project_slug}}"

# Save the credentials
$sp | ConvertTo-Json | Out-File sp.json -Encoding utf8
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($sp.Secret)
$UnsecureSecret = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
$UnsecureSecret | Out-File sp_password.txt -Encoding utf8

# Load the credentials
$sp = Get-Content sp.json | ConvertFrom-Json
$UnsecureSecret = Get-Content sp_password.txt

# Change the role of the SP
New-AzRoleAssignment -ApplicationId $sp.ApplicationId -RoleDefinitionName "{{cookiecutter.role_name}}"
Remove-AzRoleAssignment -ApplicationId $sp.ApplicationId -RoleDefinitionName "Contributor"

# Remove the SP
Remove-AzADSpCredential -DisplayName $sp.DisplayName
```


## References

- [Custom roles for Azure resources | Microsoft Docs](https://docs.microsoft.com/{{cookiecutter.lang}}/azure/role-based-access-control/custom-roles)
- [Azure Resource Manager resource provider operations | Microsoft Docs](https://docs.microsoft.com/{{cookiecutter.lang}}/azure/role-based-access-control/resource-provider-operations)
- [Create or update custom roles for Azure resources with Azure PowerShell | Microsoft Docs](https://docs.microsoft.com/{{cookiecutter.lang}}/azure/role-based-access-control/custom-roles-powershell)
- [Use Azure service principals with Azure PowerShell | Microsoft Docs](https://docs.microsoft.com/en-us/powershell/azure/create-azure-service-principal-azureps?view=azps-3.6.1)