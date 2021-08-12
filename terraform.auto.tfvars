#
# Example .tfvars file
# Can be copied to terraform.tfvars and edited so that Terraform will automatically use variables from this file.
#



globalwsname = "AppdTomcatGlobal"


vsphere_server = "10.88.168.24"	
datacenter = "Piso14-Lab"	
resource_pool = "ccmsuite"	
datastore_name = "CCPHXM4"	
network_name = "vm-network-6"	
template_name = "ubuntu-tmp"	
vm_folder = "terraform"	
vm_prefix = "terraform-"	
vm_domain = "lab14.lc"	
vm_cpu = 2	
vm_count = 1	
root_password = "XXXXX"	
vsphere_user = "administrator@vsphere.local"	
vsphere_password = "YYYYY"
vm_memory = 4096


