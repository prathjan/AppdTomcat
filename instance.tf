#get the data fro the global vars WS
data "terraform_remote_state" "global" {
  backend = "remote"
  config = {
    organization = "Lab14"
    workspaces = {
      name = var.globalwsname
    }
  }
}

#get the db serer name
data "terraform_remote_state" "dbvm" {
  backend = "remote"
  config = {
    organization = "Lab14"
    workspaces = {
      name = var.dbvmwsname
    }
  }
}


data "vsphere_datacenter" "dc" {
  name = var.datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.datastore_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = var.resource_pool
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.network_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.template_name
  datacenter_id = data.vsphere_datacenter.dc.id
}


resource "random_string" "folder_name_prefix" {
  length    = 10
  min_lower = 10
  special   = false
  lower     = true

}


resource "vsphere_folder" "vm_folder" {
  path          =  "${var.vm_folder}-${random_string.folder_name_prefix.id}"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
}


resource "vsphere_virtual_machine" "vm_deploy" {
  count            = var.vm_count
  name             = "${var.vm_prefix}-${random_string.folder_name_prefix.id}-${count.index + 1}"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder           = vsphere_folder.vm_folder.path
  firmware = "bios"


  num_cpus = var.vm_cpu
  memory   = var.vm_memory
  guest_id = data.vsphere_virtual_machine.template.guest_id

  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      linux_options {
        host_name = "${var.vm_prefix}-${random_string.folder_name_prefix.id}-${count.index + 1}"
        domain    = var.vm_domain
      }
      network_interface {}
    }
  }

}


resource "null_resource" "vm_node_init" {
  count = "${var.vm_count}"

  provisioner "file" {
    source = "scripts/"
    destination = "/tmp"
    connection {
      type = "ssh"
      host = "${vsphere_virtual_machine.vm_deploy[count.index].default_ip_address}"
      user = "root"
      password = "${var.root_password}"
      port = "22"
      agent = false
    }
  }
  provisioner "file" {
    source = "appwars/"
    destination = "/tmp"
    connection {
      type = "ssh"
      host = "${vsphere_virtual_machine.vm_deploy[count.index].default_ip_address}"
      user = "root"
      password = "${var.root_password}"
      port = "22"
      agent = false
    }
  }


  provisioner "remote-exec" {
    inline = [
	"chmod +x /tmp/appd.sh",
        "/tmp/appd.sh",
    ]
    connection {
      type = "ssh"
      host = "${vsphere_virtual_machine.vm_deploy[count.index].default_ip_address}"
      user = "root"
      password = "${var.root_password}"
      port = "22"
      agent = false
    }
  }
  provisioner "remote-exec" {
    inline = [
        "chmod +x /tmp/rbac.sh",
        "${local.download}",
	"/tmp/rbac.sh ${local.nbrapm} ${local.nbrma} ${local.nbrsim} ${local.nbrnet}",
	". /home/ec2-user/environment/workshop/application.env",
	"echo echoing install",
	"echo ${local.install}",
	"echo echoing accesskey",
	"echo $APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY",
	"echo replacement",
	"echo ${local.install} > /tmp/installcmd.sh",
	"sed 's/fillmein/'$APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY'/g' /tmp/installcmd.sh > /tmp/installexec.sh",
	"chmod +x /tmp/installexec.sh",
	"echo installing",
	"/tmp/installexec.sh",
    ]
    connection {
      type = "ssh"
      host = "${vsphere_virtual_machine.vm_deploy[count.index].default_ip_address}"
      user = "root"
      password = "${var.root_password}"
      port = "22"
      agent = false
    }
  }
  provisioner "remote-exec" {
    inline = [
	"chmod +x /tmp/tom.sh",
        "/tmp/tom.sh",
    ]
    connection {
      type = "ssh"
      host = "${vsphere_virtual_machine.vm_deploy[count.index].default_ip_address}"
      user = "root"
      password = "${var.root_password}"
      port = "22"
      agent = false
    }
  }

  provisioner "remote-exec" {
    inline = [
        "chmod +x /tmp/grant.sh",
        "/tmp/grant.sh ${vsphere_virtual_machine.vm_deploy[count.index].default_ip_address} ${local.dbvmip} teadb teauser teapassword",
    ]
    connection {
      type = "ssh"
      host = "${local.dbvmip}"
      user = "root"
      password = "${var.root_password}"
      port = "22"
      agent = false
    }
  }


  provisioner "remote-exec" {
    inline = [
        "chmod +x /tmp/tominstance.sh",
    ]
    connection {
      type = "ssh"
      host = "${vsphere_virtual_machine.vm_deploy[count.index].default_ip_address}"
      user = "root"
      password = "${var.root_password}"
      port = "22"
      agent = false
    }
  }

  provisioner "remote-exec" {
    inline = [
        "chmod +x /tmp/startsvc.sh",
    ]
    connection {
      type = "ssh"
      host = "${vsphere_virtual_machine.vm_deploy[count.index].default_ip_address}"
      user = "root"
      password = "${var.root_password}"
      port = "22"
      agent = false
    }
  }

  provisioner "remote-exec" {
    inline = [<<EOT
        %{ for app in local.appwars ~} 
            /tmp/tominstance.sh ${app.svcname} ${app.svcport} ${app.svrport} ${app.appwar} ${local.dbvmip}
        %{ endfor ~} 
    EOT
    ]
    connection {
      type = "ssh"
      host = "${vsphere_virtual_machine.vm_deploy[count.index].default_ip_address}"
      user = "root"
      password = "${var.root_password}"
      port = "22"
      agent = false
    }
  }

  provisioner "remote-exec" {
    inline = [<<EOT
        %{ for app in local.appwars ~}
            /tmp/startsvc.sh ${app.svcname} ${app.svcport} ${app.svrport} ${app.appwar} ${local.dbvmip}
        %{ endfor ~}
    EOT
    ]
    connection {
      type = "ssh"
      host = "${vsphere_virtual_machine.vm_deploy[count.index].default_ip_address}"
      user = "root"
      password = "${var.root_password}"
      port = "22"
      agent = false
    }
  }


}

output "vm_deploy" {
  value = [vsphere_virtual_machine.vm_deploy.*.name, vsphere_virtual_machine.vm_deploy.*.default_ip_address]
}

output "app_deploy" {
  value = tomap({
    for appwar, appcontext in local.appwars : appwar => appcontext
  })
}


locals {
  download = yamldecode(data.terraform_remote_state.global.outputs.download)
  install = yamldecode(data.terraform_remote_state.global.outputs.install)
  appwars = data.terraform_remote_state.global.outputs.apps
  dbvmname = data.terraform_remote_state.dbvm.outputs.vm_name[0]
  dbvmip = data.terraform_remote_state.dbvm.outputs.vm_ip[0]
  nbrapm = data.terraform_remote_state.global.outputs.nbrapm
  nbrma = data.terraform_remote_state.global.outputs.nbrma
  nbrsim = data.terraform_remote_state.global.outputs.nbrsim
  nbrnet = data.terraform_remote_state.global.outputs.nbrnet
  mysql_pass = yamldecode(data.terraform_remote_state.global.outputs.mysql_pass)
}

