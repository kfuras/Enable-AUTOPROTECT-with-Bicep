// Main Bicep file for deploying Azure Recovery Services Vault, SQL Server Policy, SQL VM Registration and Protection Intent
targetScope = 'managementGroup'

@description('Parameters for Recovery Services Vault, SQL Server Policy, SQL VM Registration')
param subid string = 'b7f543e7-29f0-4e13-8b16-e8e94170be88' // DemoCrayon
param vmsRG string = 'kf-vms-rg'
param rsvRG string = 'kf-rsv-rg'
param location string = 'norwayeast'
param vaultName string = 'myVault'
param vaultStorageType string = 'LocallyRedundant'
param skuName string = 'Standard'
param skuTier string = 'Standard'
param publicNetworkAccess string = 'Enabled'
param sqlpolicyName string = 'SQLVMPolicy'

@description('Protection Intent Parameters')
param rsvProviderNamespace string = 'Microsoft.RecoveryServices'
param fabricName string = 'Azure'
param backupManagementType string = 'AzureWorkload'
param protectionIntentItemType string = 'SQLInstance'
param protectionIntentItemTypes string = 'RecoveryServiceVaultItem'

@description('Array Intent Parameters')
param sqlServers array = [
  {
    name: 'sqlservervm1'
    resourceGroup: 'kf-vms-rg'
    protectedItems: 'sqlinstance;mssqlserver'
    protectionIntentItems: '123'
  }
  {
    name: 'sqlservervm2'
    resourceGroup: 'kf-vms-rg'
    protectedItems: 'sqlinstance;mssqlserver'
    protectionIntentItems: '456'
  }
]

@description('Vault Module')
module recoveryServicesVault 'modules/vault.bicep' = {
  name: 'vault'
  scope: resourceGroup(subid,rsvRG)
  params: {
    vaultName: vaultName
    vaultStorageType: vaultStorageType
    skuName: skuName
    skuTier: skuTier
    publicNetworkAccess: publicNetworkAccess
    location: location
  }
}

@description('Policy Module')
module policy 'modules/sqlServerPolicy.bicep' = {
  name: 'policyModule'
  scope: resourceGroup(subid,rsvRG)
  dependsOn: [
    recoveryServicesVault  // Ensure vault is deployed before policy
  ]
  params: {
    vaultName: vaultName
    sqlpolicyName: sqlpolicyName
  }
}

@description('SQL VM Registration Module')
module sqlVmRegistration 'modules/sqlVmRegistration.bicep' = [for sqlServer in sqlServers: {
  name: 'sqlVmRegistrationModule-${sqlServer.name}'
  scope: resourceGroup(subid,rsvRG)
  dependsOn: [
    recoveryServicesVault, policy  // Ensure vault is deployed before policy
  ]
  params: {
    vaultName: vaultName
    resourceGroup: vmsRG
    sqlServers: [sqlServer.name]
  }
}]

@description('Protection Intent Module')
module protectionIntentModules 'modules/protectionIntent.bicep' = [for sqlServer in sqlServers: {
  scope: resourceGroup(subid, rsvRG)
  name: 'protectionIntentModule-${sqlServer.name}'
  dependsOn: [
    recoveryServicesVault, policy, sqlVmRegistration  // Ensure vault is deployed before policy
  ]
  params: {
    autoProtectionContainers: 'vmappcontainer;compute;${sqlServer.resourceGroup};${sqlServer.name}'
    autoProtectedItems: sqlServer.protectedItems
    protectionIntentItems: sqlServer.protectionIntentItems
    backupManagementType: backupManagementType
    fabricName: fabricName
    policyName: sqlpolicyName
    protectionIntentItemType: protectionIntentItemType
    rsvProviderNamespace: rsvProviderNamespace
    vaultName: vaultName
    protectionIntentItemTypes: protectionIntentItemTypes
  }
}]
