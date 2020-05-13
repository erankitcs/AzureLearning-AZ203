#Login interactively and set a subscription to be the current active subscription
az login

#Let's create a Linux VM, starting off with creating a Resource Group.
az group create --name "ankitdemo-rg" --location "centralus"

az group list -o table

#2 - Create virtual network (vnet) and Subnet
az network vnet create --resource-group "ankitdemo-rg" --name "ankitdemo-vnet-1"`
     --address-prefix "10.1.0.0/16" --subnet-name "ankitdemo-subnet-1" `
    --subnet-prefix "10.1.1.0/24"

az network vnet list -o table

#3 - Create public IP address
az network public-ip create `
    --resource-group "ankitdemo-rg" `
    --name "ankitdemo-linux-1-pip-1"

az network public-ip list -o Table

#Public IPs can take a few minutes to provision, we'll check on this after we provision the VM

#4 - Create network security group
az network nsg create `
    --resource-group "ankitdemo-rg" `
    --name "ankitdemo-linux-nsg-1"
az network nsg list --output table

#5 - Create a virtual network interface and associate with public IP address and NSG
az network nic create `
  --resource-group "ankitdemo-rg" `
  --name "ankitdemo-linux-1-nic-1" `
  --vnet-name "ankitdemo-vnet-1" `
  --subnet "ankitdemo-subnet-1" `
  --network-security-group "ankitdemo-linux-nsg-1" `
  --public-ip-address "ankitdemo-linux-1-pip-1"

az network nic list --output table
#6 - Create a virtual machine
az vm create `
    --resource-group "ankitdemo-rg" `
    --location "centralus" `
    --name "ankitdemo-linux-1" `
    --nics "ankitdemo-linux-1-nic-1" `
    --image "rhel" `
    --admin-username "demoadmin" `
    --authentication-type "ssh" `
    --ssh-key-value C:\Users\Rishu\.ssh\id_rsa.pub

az vm create --help | more 

#7 - Open port 22 to allow SSH traffic to host
az vm open-port `
    --resource-group "ankitdemo-rg" `
    --name "ankitdemo-linux-1" `
    --port "22"

## Time to create the Windows VM ##
#1 - we're going to place this server in the existing resource group.

#2 - we're going to place this server in the same vnet

#3 - Create public IP address
az network public-ip create `
    --resource-group "ankitdemo-rg" `
    --name "ankitdemo-win-1-pip-1"

#4 - Create network security group, so we can have seperate security policies
az network nsg create `
    --resource-group "ankitdemo-rg" `
    --name "ankitdemo-win-nsg-1"

#5 - Create a virtual network card and associate with public IP address and NSG
az network nic create `
  --resource-group "ankitdemo-rg" `
  --name "ankitdemo-win-1-nic-1" `
  --vnet-name "ankitdemo-vnet-1" `
  --subnet "ankitdemo-subnet-1" `
  --network-security-group "ankitdemo-win-nsg-1" `
  --public-ip-address "ankitdemo-win-1-pip-1"

#6 - Create a virtual machine
az vm create `
    --resource-group "ankitdemo-rg" `
    --name "ankitdemo-win-1" `
    --location "centralus" `
    --nics "ankitdemo-win-1-nic-1" `
    --image "win2016datacenter" `
    --admin-username "demoadmin" `
    --admin-password "password123412123$%^&*"

#7 - Open port 3389 to allow RDP traffic to host
az vm open-port `
    --port "3389" `
    --resource-group "ankitdemo-rg" `
    --name "ankitdemo-win-1"

az vm list-ip-addresses --name "ankitdemo-win-1"  --output table