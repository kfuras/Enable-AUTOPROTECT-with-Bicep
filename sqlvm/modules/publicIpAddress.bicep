targetScope = 'resourceGroup'
param publicIpAddressName string
param location string
param publicIpAddressSku string
param publicIpAddressType string

// Creates a public IP address resource
resource publicIpAddress 'Microsoft.Network/publicIPAddresses@2022-01-01' = {
  name: publicIpAddressName
  location: location
  sku: {
    name: publicIpAddressSku
  }
  properties: {
    publicIPAllocationMethod: publicIpAddressType
  }
}

// Outputs the ID of the public IP address resource
output publicIpAddressId string = publicIpAddress.id
