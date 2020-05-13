#Start a connection with Azure
Connect-AzureRmAccount -Subscription 'Free Trial'
$rg = New-AzureRmResourceGroup `
  -Name 'ankitdemo-rg' `
  -Location 'centralus'

$rg

#2a - Create a subnet configuration
$subnetConfig = New-AzureRmVirtualNetworkSubnetConfig `
    -Name 'ankitemo-subnet-2' `
    -AddressPrefix '10.2.1.0/24'

$subnetConfig

#2b - Create a virtual network
$vnet = New-AzureRmVirtualNetwork `
    -ResourceGroupName $rg.ResourceGroupName `
    -Location $rg.Location `
    -Name 'ankitdemo-vnet-2' `
    -AddressPrefix '10.2.0.0/16' `
    -Subnet $subnetConfig
    
$vnet

#3 - Create public IP address
$pip = New-AzureRmPublicIpAddress `
    -ResourceGroupName $rg.ResourceGroupName `
    -Location $rg.Location `
    -Name 'ankitdemo-linux-2-pip-1' `
    -AllocationMethod Static

$pip

#4a - Create network security group rule for SSH 
#Example of a more granular approach to creating a security rule.
$rule1 = New-AzureRmNetworkSecurityRuleConfig `
    -Name ssh-rule `
    -Description 'Allow SSH' `
    -Access Allow `
    -Protocol Tcp `
    -Direction Inbound `
    -Priority 100 `
    -SourceAddressPrefix Internet `
    -SourcePortRange * `
    -DestinationAddressPrefix * `
    -DestinationPortRange 22

$rule1

#4a - Create network security group, with the newly created rule
$nsg = New-AzureRmNetworkSecurityGroup `
    -ResourceGroupName $rg.ResourceGroupName `
    -Location $rg.Location `
    -Name 'ankitdemo-linux-nsg-2' `
    -SecurityRules $rule1

$nsg | more

#5 - Create a virtual network card and associate with public IP address and NSG
#First, let's get an object representing our current subnet, there was typo in naming convesion(ankitemo).

$subnet = $vnet.Subnets | Where-Object { $_.Name -eq 'ankitemo-subnet-2' }

$nic = New-AzureRmNetworkInterface `
    -ResourceGroupName $rg.ResourceGroupName `
    -Location $rg.Location `
    -Name 'ankitdemo-linux-2-nic-1' `
    -Subnet $subnet `
    -PublicIpAddress $pip `
    -NetworkSecurityGroup $nsg

$nic

#6a - Create a virtual machine configuration
$LinuxVmConfig = New-AzureRmVMConfig `
    -VMName 'ankitdemo-linux-2' `
    -VMSize 'Standard_D1_v2'

#6b - set the comptuer name, OS type and, auth methods.
$password = ConvertTo-SecureString 'password123412123$%^' -AsPlainText -Force
$LinuxCred = New-Object System.Management.Automation.PSCredential ('demoadmin', $password)

$LinuxVmConfig = Set-AzureRmVMOperatingSystem `
    -VM $LinuxVmConfig `
    -Linux `
    -ComputerName 'ankitdemo-linux-2' `
    -DisablePasswordAuthentication `
    -Credential $LinuxCred


#6c - Read in our SSH Keys and add to the vm config
$sshPublicKey = Get-Content "C:/Users/Rishu/.ssh/id_rsa.pub"
Add-AzureRmVMSshPublicKey `
    -VM $LinuxVmConfig `
    -KeyData $sshPublicKey `
    -Path "/home/demoadmin/.ssh/authorized_keys"

#6d - get the VM image name, and set it in the VM config in this case RHEL/latest
Get-AzureRmVMImageSku -Location $rg.Location -PublisherName "Redhat" -Offer "rhel"

$LinuxVmConfig = Set-AzureRmVMSourceImage `
    -VM $LinuxVmConfig `
    -PublisherName 'Redhat' `
    -Offer 'rhel' `
    -Skus '7.4' `
    -Version 'latest' 

#6e - assign the created network interface to the vm
$LinuxVmConfig = Add-AzureRmVMNetworkInterface `
    -VM $LinuxVmConfig `
    -Id $nic.Id 

# Create a virtual machine, passing in the VM Configuration, network, image etc are in the config.
New-AzureRmVM `
    -ResourceGroupName $rg.ResourceGroupName `
    -Location $rg.Location `
    -VM $LinuxVmConfig

$MyIP = Get-AzureRmPublicIpAddress `
    -ResourceGroupName $rg.ResourceGroupName `
    -Name $pip.Name | Select-Object -ExpandProperty IpAddress

$MyIP