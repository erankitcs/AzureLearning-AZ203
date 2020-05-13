#examine virtual machine from cloud shell.
#Started
Get-AzureRmVM -ResourceGroupName "ankitdemo-rg" -Name "ankitdemo-linux-2" -Status 

#Stopping
Get-ChildItem 'Azure:/Free Trial/VirtualMachines/ankitdemo-linux-2' | Stop-AzureRmVM -StayProvisioned -Force -AsJob

#We can use our Get-AzureRmVM cmdlet
Get-AzureRmVM -ResourceGroupName "ankitdemo-rg" -Name "ankitdemo-linux-2"  -Status 

#Stopped
Get-ChildItem 'Azure:/Free Trial/VirtualMachines/ankitdemo-linux-2'

#VM state is cached, so we can use -Force to update
Get-ChildItem 'Azure:/Free Trial/VirtualMachines/ankitdemo-linux-2' -Force

#Deallocating - can take several minutes
Get-ChildItem 'Azure:/Free Trial/VirtualMachines/ankitdemo-linux-2' | Stop-AzureRmVM -Force -AsJob

#Deallocated
Get-AzureRmVM -ResourceGroupName "ankitdemo-rg" -Name "ankitdemo-linux-2" -Status

#Starting
Start-AzureRmVM -ResourceGroupName "ankitdemo-rg" -Name "ankitdemo-linux-2" -AsJob

Get-AzureRmVM -ResourceGroupName "ankitdemo-rg" -Name "ankitdemo-linux-2"  -Status 


#Remove the VM
Get-ChildItem 'Azure:/Free Trial/VirtualMachines/ankitdemo-linux-2' | Remove-AzureRmVM -Force -AsJob 