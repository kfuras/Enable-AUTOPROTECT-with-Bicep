// Protection Intent Module
targetScope = 'resourceGroup'
@description('Creates a backup protection intent for a specific item')
param vaultName string
param protectionIntentItems string
param rsvProviderNamespace string
param fabricName string
param autoProtectionContainers string
param policyName string
param backupManagementType string
param protectionIntentItemType string
param autoProtectedItems string
param protectionIntentItemTypes string


resource protectionIntent'Microsoft.RecoveryServices/vaults/backupFabrics/backupProtectionIntent@2023-01-01' = {
  name: '${vaultName}/${fabricName}/${protectionIntentItems}'
  properties: {
    protectionIntentItemType: protectionIntentItemTypes
    backupManagementType: backupManagementType
    parentName: resourceId('${rsvProviderNamespace}/vaults/backupFabrics/protectionContainers', vaultName, fabricName, autoProtectionContainers)
    itemId: resourceId('${rsvProviderNamespace}/vaults/backupFabrics/protectionContainers/protectableItems', vaultName, fabricName, autoProtectionContainers, autoProtectedItems)
    policyId: resourceId('${rsvProviderNamespace}/vaults/backupPolicies', vaultName, policyName)
  }
}
