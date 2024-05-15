targetScope = 'managementGroup'

param subid string = 'b7f543e7-29f0-4e13-8b16-e8e94170be88' // DemoCrayon
param vmsRG string = 'kf-vms-rg'
param location string = 'norwayeast'
param virtualMachineSize string = 'Standard_Ds1_v2'
param existingVirtualNetworkName string = 'kf-dev-vnet'
param existingVnetResourceGroup string = 'kf-vnet-rg'
param existingSubnetName string = 'kf-dev-vm-snet'
param existingnsgName string = 'nsg1'
param imageOffer string = 'sql2019-ws2019'
param sqlSku string = 'Standard'
param adminUsername string = 'azadmin'
param adminPassword string = 'Aa1234567890#'
param storageWorkloadType string = 'General'
param dataPath string = 'F:\\SQLData'
param logPath string = 'G:\\SQLLog'
param sqlDataDisksCount int = 1
param sqlLogDisksCount int = 1
param tempDbPath string = 'D:\\SQLTemp'

var dataDisksLuns = range(0, sqlDataDisksCount)
var logDisksLuns = range(sqlDataDisksCount, sqlLogDisksCount)
var subscriptionId = 'b7f543e7-29f0-4e13-8b16-e8e94170be88'

@description('Array of SQL Servers')
param sqlServers array = [
  {
    name: 'sqlservervm1'
  }
  {
    name: 'sqlservervm2'
  }
]
// Module for Public IP Address
module publicIpAddress 'modules/publicIpAddress.bicep' = [for sqlServer in sqlServers: {
  name: '${sqlServer.name}-publicIpAddressModule'
  scope: resourceGroup(subid, vmsRG)
  params: {
    publicIpAddressName: '${sqlServer.name}-publicip'
    location: location
    publicIpAddressSku: 'Standard'
    publicIpAddressType: 'Static'
  }
}]

// Module for Network Interface
module networkInterface 'modules/networkInterface.bicep' = [for (sqlServer, idx) in sqlServers: {
  name: '${sqlServer.name}-networkInterfaceModule'
  scope: resourceGroup(subid, vmsRG)
  params: {
    networkInterfaceName: '${sqlServer.name}-nic'
    location: location
    subnetRef: '/subscriptions/${subscriptionId}/resourceGroups/${existingVnetResourceGroup}/providers/Microsoft.Network/virtualNetworks/${existingVirtualNetworkName}/subnets/${existingSubnetName}'
    publicIpAddressId: publicIpAddress[idx].outputs.publicIpAddressId  // Correctly accessing the output using an index
    nsgId: '/subscriptions/${subscriptionId}/resourceGroups/${existingVnetResourceGroup}/providers/Microsoft.Network/networkSecurityGroups/${existingnsgName}'
  }
}]

// Module for Virtual Machine
module virtualMachine 'modules/virtualMachine.bicep' = [for (sqlServer, idx) in sqlServers: {
  name: '${sqlServer.name}-virtualMachineModule'
  scope: resourceGroup(subid, vmsRG)
  params: {
    virtualMachineName: sqlServer.name
    location: location
    virtualMachineSize: virtualMachineSize
    imageOffer: imageOffer
    sqlSku: sqlSku
    adminUsername: adminUsername
    adminPassword: adminPassword
    networkInterfaceId: networkInterface[idx].outputs.networkInterfaceId // Correctly referencing network interface output
    dataDisks: {
      createOption: 'Empty'
      caching: 'ReadOnly'
      writeAcceleratorEnabled: false
      diskSizeGB: 100
      storageAccountType: 'Premium_LRS'
    }
    sqlDataDisksCount: sqlDataDisksCount
    sqlLogDisksCount: sqlLogDisksCount
  }
}]

// Module for SQL Virtual Machine
module sqlVirtualMachine 'modules/sqlVirtualMachine.bicep' = [for (sqlServer, idx) in sqlServers: {
  name: '${sqlServer.name}-sqlVirtualMachineModule'
  scope: resourceGroup(subid, vmsRG)
  params: {
    virtualMachineName: sqlServer.name
    location: location
    virtualMachineId: virtualMachine[idx].outputs.virtualMachineId // Correct integer indexing
    diskConfigurationType: 'NEW'
    storageWorkloadType: storageWorkloadType
    dataDisksLuns: dataDisksLuns
    dataPath: dataPath
    logDisksLuns: logDisksLuns
    logPath: logPath
    tempDbPath: tempDbPath
  }
}]

output adminUsernameOutput string = adminUsername
