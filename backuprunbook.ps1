<# Ensure below mentioned modules are imported in the same order because of the dependency and Automation account has a Run-As account created which is used for authenticating with Azure to manage resources.
Az.Accounts
Az.RecoveryServices
AddDays is the retention which gets set for all the backups which are triggered using this method.
Script can be further customised by adding retension as well as other parameters as variable.
#>
Import-Module Az.RecoveryServices
$connection = Get-AutomationConnection -Name AzureRunAsConnection
Connect-AzAccount -ServicePrincipal -Tenant $connection.TenantID -ApplicationID $connection.ApplicationID -CertificateThumbprint $connection.CertificateThumbprint
$vault=Get-AzRecoveryServicesVault -Name "VaultName" 
Set-AzRecoveryServicesVaultContext -Vault $vault
$endDate = (Get-Date).AddDays(10).ToUniversalTime()
$backupcontainer = Get-AzRecoveryServicesBackupContainer -ContainerType "AzureVM" -FriendlyName "VMName" -VaultId $vault.ID
$item = Get-AzRecoveryServicesBackupItem -Container $backupcontainer -WorkloadType "AzureVM" -VaultId $vault.ID
Backup-AzRecoveryServicesBackupItem -Item $item -ExpiryDateTimeUTC $endDate
