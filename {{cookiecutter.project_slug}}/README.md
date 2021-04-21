# {{cookiecutter.project_name}}

## Steps

You can create your Custom Role according to the following steps:

- **Step 1:** Open a PowerShell session, and run `Login-AzAccount` and `Select-AzSubscription` to login with your admin account which can manage Custome Role and Service Principal. We'll call this PowerShell session as [ADMIN Session].
- **Step 2 [ADMIN Session]:** Run `.\1_create_role.ps1` to create an initial Custom Role where only one meaningless action (i.e. `Microsoft.Support/*`) is allowed.
- **Step 3 [ADMIN Session]:** Run `.\2_create_sp.ps1` to create a new Service Principal (SP) and assign the role to it. Don't remove files that this script output.
- **Step 4 :** Customize `do_action.ps1` and make sure it will perform your desired operation. Note that your goal is to execute `.\do_action.ps1` with the above service principal without any error.
- **Step 5:** Open a new PowerShell session for SP, which is referred to as [SP Session].
- **Setp 6:** Repeat these sub steps until the role definition is completed:
    - **Step 6.1 [SP Session]:** Run `.\login_sp.ps1`. The purpose is not only the first login, but also to reflect the current custom role definitions in the SP.
    - **Step 6.2 [SP Session]:** Run `.\do_action.ps1`:
        - If an error regarding authz occurs, edit parameters (e.g. `Actions`) in `role.json` according to the error message.
        - If an other error occurs, please take a look at your code in `do_action.ps` and make sure it works correctly.
        - Otherwise, your custom role has been completed! Move to **Step 7**.
    - **Step 7.3 [ADMIN Session]:** Run `.\update_role.ps1` to update the definition of Custom Role. You can use `get_role.ps1` to check the current definition on Azure platform, as sometimes it takes a few mins to reflect.
- **Step 7 [ADMIN Session]:** Run `.\cleanup.ps` to clean up resources. Now `role.json` is your desired Custom Role definition.

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
$bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($sp.Secret)
$password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
$tenantid = (Get-AzContext).Tenant.Id

# Save the credentials
$sp | ConvertTo-Json | Out-File sp.json -Encoding utf8
$password | Out-File sp_password.txt -Encoding utf8
$tenantid | Out-File sp_tenantid.txt -Encoding utf8

# Load the credentials
$sp = Get-Content sp.json | ConvertFrom-Json
$password = Get-Content sp_password.txt
$tenantid = Get-Content sp_tenantid.txt

# Change the role of the SP
New-AzRoleAssignment -ApplicationId $sp.ApplicationId -RoleDefinitionName "{{cookiecutter.role_name}}"
Remove-AzRoleAssignment -ServicePrincipalName $sp.ApplicationId -RoleDefinitionName "Contributor"

# Get the assigned role of the SP
Get-AzRoleAssignment -ServicePrincipalName $sp.ApplicationId

# Sign-in with the SP
$securepass = ConvertTo-SecureString $password -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential($sp.ApplicationId, $securepass)
Connect-AzAccount -ServicePrincipal -Credential $cred -Tenant $tenantid 

# Remove the SP
Remove-AzADSpCredential -DisplayName $sp.DisplayName
@("sp.json", "sp_password.txt", "sp_tenantid.txt") | Remove-Item -Confirm
```

## Sample Role

```json
{
  "Name": "Virtual Machine Operator",
  "Id": "88888888-8888-8888-8888-888888888888",
  "IsCustom": true,
  "Description": "Can monitor and restart virtual machines.",
  "Actions": [
    "Microsoft.Storage/*/read",
    "Microsoft.Network/*/read",
    "Microsoft.Compute/*/read",
    "Microsoft.Compute/virtualMachines/start/action",
    "Microsoft.Compute/virtualMachines/restart/action",
    "Microsoft.Authorization/*/read",
    "Microsoft.ResourceHealth/availabilityStatuses/read",
    "Microsoft.Resources/subscriptions/resourceGroups/read",
    "Microsoft.Insights/alertRules/*",
    "Microsoft.Insights/diagnosticSettings/*",
    "Microsoft.Support/*"
  ],
  "NotActions": [],
  "DataActions": [],
  "NotDataActions": [],
  "AssignableScopes": [
    "/subscriptions/{subscriptionId1}",
    "/subscriptions/{subscriptionId2}/resourceGroups/{resourceGroup2}",
    "/providers/Microsoft.Management/managementGroups/{groupId3}"
  ]
}
```


## References

- [Tutorial: Create an Azure custom role with Azure PowerShell - Azure RBAC | Microsoft Docs](https://docs.microsoft.com/en-us/azure/role-based-access-control/tutorial-custom-role-powershell)
- [Create or update Azure custom roles using Azure PowerShell - Azure RBAC | Microsoft Docs](https://docs.microsoft.com/en-us/azure/role-based-access-control/custom-roles-powershell)
- [Azure custom roles - Azure RBAC | Microsoft Docs](https://docs.microsoft.com/en-us/azure/role-based-access-control/custom-roles)
- [Use Azure service principals with Azure PowerShell | Microsoft Docs](https://docs.microsoft.com/en-us/powershell/azure/create-azure-service-principal-azureps)
- [Azure resource provider operations | Microsoft Docs](https://docs.microsoft.com/en-us/azure/role-based-access-control/resource-provider-operations)