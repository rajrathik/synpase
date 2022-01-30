### Add storage account
connect-AZAccount
$rg = 'rg-azuretraining-poc-001'
$stgName = 'stgstoresales'
New-AzStorageAccount `
              -ResourceGroupName $rg   `
              -Name $stgName `
              -Location 'southcentralus'   `
              -SkuName 'Standard_LRS'   `
              -Kind 'StorageV2' `
              -AccessTier 'Cool' `
              -MinimumTlsVersion 'TLS1_2' `
              -AllowBlobPublicAccess $false `
              -AllowSharedKeyAccess $false `
              -EnableHierarchicalNamespace $true
              
$storageAccount = Get-AzStorageAccount  `
              -ResourceGroupName $rg  `
              -Name  $stgName
              
# Retrieve the Context & Scope from the Storage 
$Storagescope= $StorageAccount.Id
$storageContext = $storageAccount.Context

#Add containers by allowing sharedaccess keys during this operation. Disabling shared access after container is added
Set-AzStorageAccount  `
               -ResourceGroupName $rg  `
               -AccountName $stgName   `
               -AllowSharedKeyAccess $true   `
               -AllowBlobPublicAccess $true
New-AzStorageContainer  `
              -Name 'stgstoresales-container'  `
              -Context $storageContext  `
              -Permission Container
Set-AzStorageAccount  `
           -ResourceGroupName $rg `
           -AccountName $stgName`   `
           -AllowSharedKeyAccess $false  `
           -AllowBlobPublicAccess $false
           
#Get system managed Identity
$snypase="synp-azuretraining-poc-ws001"
$Synpaseidentity=(Get-AzSynapseWorkspace `
   -ResourceGroupName $rg  -Name $snypase).Identity
   
#Assign storage blob contributor role to Synapse workspace
New-AzRoleAssignment `
    -ObjectId $Synpaseidentity.PrincipalID `
    -RoleDefinitionName "Storage Blob Data Reader" `
    -Scope  $Storagescope
 
 
 
