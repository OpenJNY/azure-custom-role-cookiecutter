# Create a new SP
$sp = New-AzADServicePrincipal -DisplayName "test_sp_{{cookiecutter.project_slug}}"
$bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($sp.Secret)
$password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
$tenantid = (Get-AzContext).Tenant.Id

# Save the credentials as files
$sp | ConvertTo-Json | Out-File sp.json -Encoding utf8
$password | Out-File sp_password.txt -Encoding utf8
$tenantid | Out-File sp_tenantid.txt -Encoding utf8

# Change the role of the SP
New-AzRoleAssignment -ApplicationId $sp.ApplicationId -RoleDefinitionName "{{cookiecutter.role_name}}"
Remove-AzRoleAssignment -ServicePrincipalName $sp.ApplicationId -RoleDefinitionName "Contributor"