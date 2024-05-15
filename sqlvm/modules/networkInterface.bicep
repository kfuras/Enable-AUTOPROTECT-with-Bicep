targetScope = 'resourceGroup'
param networkInterfaceName string
param location string
param subnetRef string
param publicIpAddressId string
param nsgId string

// Creates a network interface resource with the specified properties.
resource networkInterface 'Microsoft.Network/networkInterfaces@2022-01-01' = {
  name: networkInterfaceName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnetRef
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIpAddressId
          }
        }
      }
    ]
    enableAcceleratedNetworking: true
    networkSecurityGroup: {
      id: nsgId
    }
  }
}

// Outputs the ID of the created network interface resource.
output networkInterfaceId string = networkInterface.id
