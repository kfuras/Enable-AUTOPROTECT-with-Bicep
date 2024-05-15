// SQL Server Policy Module
targetScope = 'resourceGroup'

@description('Parameters')
param vaultName string
param sqlpolicyName string

@description ('Existing Recovery Services Vault')
resource recoveryServicesVault 'Microsoft.RecoveryServices/vaults@2022-10-01' existing = {
  name: vaultName
}


@description ('BackupPolicy for Azure SQL VMs')
resource sqlbackupPolicy 'Microsoft.RecoveryServices/vaults/backupPolicies@2022-10-01' = {
  parent: recoveryServicesVault
  name: sqlpolicyName
  properties: {
    backupManagementType: 'AzureWorkload'
    protectedItemsCount: 0
    settings: {
      isCompression: true
      issqlcompression: true
      timeZone: 'UTC'
    }
    subProtectionPolicy: [
      {
        policyType: 'Full'
        retentionPolicy: {
          dailySchedule: {
            retentionDuration: {
              count: 30
              durationType: 'Days'
            }
            retentionTimes: [
              '2023-02-02T02:00:00Z'
            ]
          }
          monthlySchedule: {
            retentionDuration: {
              count: 12
              durationType: 'Months'
            }
            retentionScheduleDaily: {
              daysOfTheMonth: [
                {
                  date: 1
                  isLast: false
                }
              ]
            }
            retentionScheduleFormatType: 'Daily'
            retentionTimes: [
              '2023-02-02T02:00:00Z'
            ]
          }
          retentionPolicyType: 'LongTermRetentionPolicy'
        }
        schedulePolicy: {
          schedulePolicyType: 'SimpleSchedulePolicy'
          scheduleRunFrequency: 'Daily'
          scheduleRunTimes: [
            '2023-02-02T02:00:00Z'
          ]
          scheduleWeeklyFrequency: 0
        }
        tieringPolicy: {
          ArchivedRP: {
            duration: 0
            durationType: 'Invalid'
            tieringMode: 'DoNotTier'
          }
        }
      }
      {
        policyType: 'Log'
        retentionPolicy: {
          retentionDuration: {
            count: 7
            durationType: 'Days'
          }
          retentionPolicyType: 'SimpleRetentionPolicy'
        }
        schedulePolicy: {
          scheduleFrequencyInMins: 30
          schedulePolicyType: 'LogSchedulePolicy'
        }
      }
    ]
    workLoadType: 'SQLDataBase'
  }
}
