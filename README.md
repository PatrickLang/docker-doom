# docker-doom
A server configuration and deployment tool utilizing a docker-based back-end.




## Configuration & Usage


Worklog:

- [ ] Building steps
- [ ] Run locally
- [ ] Default config for deathmatch
- [ ] Stacked configs for admin password




## Running on Azure Container Instance

Worklog:

- [x] Uploading wads to Azure Files
- [ ] Build container image
- [ ] Start container steps


### Uploading wads

Need to clean this up into steps

```
PS > az login
To sign in, use a web browser to open the page https://aka.ms/devicelogin and enter the code BWLS49K7Q to authenticate.
[
  {
    "cloudName": "AzureCloud",
    ...
  }
]


PS > az group create --location westus2 --name DoomServers
{
  "id": "/subscriptions/.../resourceGroups/DoomServers",
  "location": "westus2",
  "managedBy": null,
  "name": "DoomServers",
  "properties": {
    "provisioningState": "Succeeded"
  },
  "tags": null
}

PS > # Using https://docs.microsoft.com/en-us/azure/storage/common/storage-azure-cli


PS > az storage account create --location westus2 --name iwads --resource-group DoomServers --sku Standard_LRS
{| Finished ..
  "accessTier": null,
  "creationTime": "2017-08-28T03:27:27.619195+00:00",
  "customDomain": null,
  "enableHttpsTrafficOnly": false,
  "encryption": null,
  "id": "/subscriptions/.../resourceGroups/doomservers/providers/Microsoft.Storage/storageAccounts/iwads",
  "identity": null,
  "kind": "Storage",
  "lastGeoFailoverTime": null,
  "location": "westus2",
  "name": "iwads",
  "networkAcls": {
    "bypass": "AzureServices",
    "defaultAction": "Allow",
    "ipRules": [],
    "virtualNetworkRules": []
  },
  "primaryEndpoints": {
    "blob": "https://iwads.blob.core.windows.net/",
    "file": "https://iwads.file.core.windows.net/",
    "queue": "https://iwads.queue.core.windows.net/",
    "table": "https://iwads.table.core.windows.net/"
  },
  "primaryLocation": "westus2",
  "provisioningState": "Succeeded",
  "resourceGroup": "doomservers",
  "secondaryEndpoints": null,
  "secondaryLocation": null,
  "sku": {
    "name": "Standard_LRS",
    "tier": "Standard"
  },
  "statusOfPrimary": "available",
  "statusOfSecondary": null,
  "tags": {},
  "type": "Microsoft.Storage/storageAccounts"
}

PS > $cs = az storage account show-connection-string --name iwads --resource-group DoomServers | ConvertFrom-Json
PS > $ENV:AZURE_STORAGE_CONNECTION_STRING = $cs.connectionString

PS > az storage share create --name iwads
{
  "created": true
}

PS > az storage share list
[
  {
    "metadata": null,
    "name": "iwads",
    "properties": {
      "etag": "\"0x8D4EDC566C92B35\"",
      "lastModified": "2017-08-28T03:32:25+00:00",
      "quota": 5120
    }
  }
]


PS > az storage account create --location westus2 --name pwads --resource-group DoomServers --sku Standard_LRS
{| Finished ..
  "accessTier": null,
  "creationTime": "2017-08-28T03:53:15.054194+00:00",
  "customDomain": null,
  "enableHttpsTrafficOnly": false,
  "encryption": null,
  "id": "/subscriptions/.../resourceGroups/doomservers/providers/Microsoft.Storage/storageAccounts/pwads",
  "identity": null,
  "kind": "Storage",
  "lastGeoFailoverTime": null,
  "location": "westus2",
  "name": "pwads",
  "networkAcls": {
    "bypass": "AzureServices",
    "defaultAction": "Allow",
    "ipRules": [],
    "virtualNetworkRules": []
  },
  "primaryEndpoints": {
    "blob": "https://pwads.blob.core.windows.net/",
    "file": "https://pwads.file.core.windows.net/",
    "queue": "https://pwads.queue.core.windows.net/",
    "table": "https://pwads.table.core.windows.net/"
  },
  "primaryLocation": "westus2",
  "provisioningState": "Succeeded",
  "resourceGroup": "doomservers",
  "secondaryEndpoints": null,
  "secondaryLocation": null,
  "sku": {
    "name": "Standard_LRS",
    "tier": "Standard"
  },
  "statusOfPrimary": "available",
  "statusOfSecondary": null,
  "tags": {},
  "type": "Microsoft.Storage/storageAccounts"
}
PS > $cs = az storage account show-connection-string --name pwads --resource-group DoomServers | ConvertFrom-Json
PS > $env:AZURE_STORAGE_CONNECTION_STRING = $cs
PS > az storage share create --name pwads
{
  "created": true
}


# Uploaded a file through portal

PS > az storage  file list --share-name pwads
[
  {
    "metadata": null,
    "name": "dwango5.wad",
    "properties": {
      "contentLength": 2109396,
      "contentRange": null,
      "contentSettings": {
        "cacheControl": null,
        "contentDisposition": null,
        "contentEncoding": null,
        "contentLanguage": null,
        "contentMd5": null,
        "contentType": null
      },
      "copy": {
        "completionTime": null,
        "id": null,
        "progress": null,
        "source": null,
        "status": null,
        "statusDescription": null
      },
      "etag": null,
      "lastModified": null,
      "serverEncrypted": null
    },
    "type": "file"
  }
]

PS > az storage  file upload --source C:\ZDaemon\wads\dwangopackv2.wad --share-name pwads

PS > az storage  file list --share-name pwads
[
  {
    "metadata": null,
    "name": "dwango5.wad",
    "properties": {
      "contentLength": 2109396,
      "contentRange": null,
      "contentSettings": {
        "cacheControl": null,
        "contentDisposition": null,
        "contentEncoding": null,
        "contentLanguage": null,
        "contentMd5": null,
        "contentType": null
      },
      "copy": {
        "completionTime": null,
        "id": null,
        "progress": null,
        "source": null,
        "status": null,
        "statusDescription": null
      },
      "etag": null,
      "lastModified": null,
      "serverEncrypted": null
    },
    "type": "file"
  },
  {
    "metadata": null,
    "name": "dwangopackv2.wad",
    "properties": {
      "contentLength": 4517857,
      "contentRange": null,
      "contentSettings": {
        "cacheControl": null,
        "contentDisposition": null,
        "contentEncoding": null,
        "contentLanguage": null,
        "contentMd5": null,
        "contentType": null
      },
      "copy": {
        "completionTime": null,
        "id": null,
        "progress": null,
        "source": null,
        "status": null,
        "statusDescription": null
      },
      "etag": null,
      "lastModified": null,
      "serverEncrypted": null
    },
    "type": "file"
  }
]
```