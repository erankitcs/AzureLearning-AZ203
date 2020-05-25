$resourceGroupName = "cosmosdb"
$location = "westus2"
$accountName= "ankitaz203cosmosdb"
$databaseName = "myDatabase"

az group create `
 -n $resourceGroupName `
 -l $location

# Create a SQL API Cosmos DB account with session consistency and multi-master enabled
az cosmosdb create `
 -g $resourceGroupName `
 --name $accountName `
 --kind GlobalDocumentDB `
 --locations "West US=0" "North Central US=1" `
 --default-consistency-level Strong `
 --enable-multiple-write-locations true `
 --enable-automatic-failover true

 # Create a database
az cosmosdb database create `
-g $resourceGroupName `
--name $accountName `
--db-name $databaseName

az cosmosdb list-keys `
-g $resourceGroupName `
-n $accountName

az cosmosdb list-connection-strings `
-g $resourceGroupName `
-n $accountName

az cosmosdb show `
-g $resourceGroupName `
-n $accountName `
--query "documentEndpoint"

az group delete `
-g $resourceGroupName `
--yes