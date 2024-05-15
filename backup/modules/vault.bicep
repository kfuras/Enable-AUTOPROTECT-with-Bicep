// Vault Module
targetScope = 'resourceGroup'

@description('Parameters')
param vaultName string
param vaultStorageType string
param skuName string
param skuTier string
param publicNetworkAccess string
param location string = resourceGroup().location

resource recoveryServicesVault 'Microsoft.RecoveryServices/vaults@2022-10-01' = {
  name: vaultName
  location: location
  sku: {
    name: skuName
    tier: skuTier
  }
  properties: {

    publicNetworkAccess: publicNetworkAccess

  }
  
}

resource vaultName_vaultstorageconfig 'Microsoft.RecoveryServices/vaults/backupconfig@2023-01-01' = {
  parent: recoveryServicesVault
  name: 'vaultconfig'
  location: location
  properties: {
    storageModelType: vaultStorageType
    softDeleteFeatureState: 'Disabled' // Enable/Disable soft delete for cloud workloads
    enhancedSecurityState: 'Disabled' // Enable/Disable soft delete and security settings for hybrid workloads
  }
}

output vaultid string = recoveryServicesVault.id
