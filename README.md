# Enable-AUTOPROTECT-with-Bicep
## Bicep Code for AUTOPROTECT in Azure Recovery Services

This repository contains the Bicep code discussed in the blog post "[Enable AUTOPROTECT with Bicep: A Step-by-Step Guide](https://kjetilfuras.com/enable-autoprotect-with-bicep/)". 
The blog post provides a comprehensive tutorial on setting up AUTOPROTECT for Azure Recovery Services using Bicep. 
The code here allows you to deploy the necessary Azure infrastructure, including SQL Servers, a Recovery Services Vault, and backup policies, as detailed in the guide.

### Blog Post Overview
The blog post covers:
- Deploying SQL Servers running on Windows in Azure.
- Creating a Recovery Services Vault and SQL Server Backup Policy.
- Registering SQL Servers to the Vault.
- Enabling the AUTOPROTECT feature to automatically detect and back up SQL Server databases.

For more detailed explanations and step-by-step instructions, please visit the blog post [here](https://kjetilfuras.com/enable-autoprotect-with-bicep/).

Each module is designed for easy customization and can be adapted to fit different deployment environments or requirements as described in the blog post.

### Usage
To deploy the Bicep code:
1. Clone this repository to your local machine.
2. Use the Azure CLI to run the deployment commands as described in the blog post.

For deployment instructions, refer to the "Running the Code" section of the [Enable AUTOPROTECT with Bicep](https://kjetilfuras.com/enable-autoprotect-with-bicep/) blog post.
