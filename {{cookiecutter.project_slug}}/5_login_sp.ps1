# Log-out to reflect the current custom role definition to SP
Disconnect-AzAccount

# Load the credentials
$sp = Get-Content sp.json | ConvertFrom-Json
$password = Get-Content sp_password.txt
$tenantid = Get-Content sp_tenantid.txt

# Log-in with the credentials
$securepass = ConvertTo-SecureString $password -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential($sp.ApplicationId, $securepass)
Connect-AzAccount -ServicePrincipal -Credential $cred -Tenant $tenantid 