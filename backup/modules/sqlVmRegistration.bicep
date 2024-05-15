// SQL VM Registration Module
targetScope = 'resourceGroup'

@description('Parameters')
param vaultName string
param resourceGroup string
param sqlServers array
@description('Variables')
var backupManagementType = 'AzureWorkload'
var containerType = 'VMAppContainer'
var backupFabric = 'Azure'

@description('Register SQL Virtual Machines in RSV')
resource protectionContainers 'Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers@2023-01-01' = [for sqlServer in sqlServers: {
  name: '${vaultName}/${backupFabric}/${containerType};compute;${resourceGroup};${sqlServer}'
  properties: {
    containerType: containerType
    backupManagementType: backupManagementType
    workloadType: 'SQLDataBase'
    friendlyName: sqlServer
    sourceResourceId: resourceId(resourceGroup, 'Microsoft.Compute/virtualMachines', sqlServer)
  }
}]
