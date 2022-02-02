locals {
  directories = {
    "source"   = "${var.project_root}/src"
    "work"   = "${var.project_root}/work"
    "export" = "${var.project_root}/work/${var.vm_name}"
  }
}

source "vsphere-clone" "sqlserver-template" {
  vm_name   = var.vm_name
  template  = var.base_template

  CPUs                 = var.numvcpus
  RAM                  = var.memsize
  disk_controller_type = ["pvscsi"]

  network      = var.vsphere_network

  vapp {
     properties = {
        hostname  = var.vm_name
        password  = var.default_password
        user-data = base64encode(var.user_data)
     }
   }

  ssh_username         = "ubuntu"
  ssh_private_key_file = var.ssh_private_key_file
  ssh_timeout          = "10m"

  vcenter_server      = var.vsphere_server
  username            = var.vsphere_username
  password            = var.vsphere_password
  datacenter          = var.vsphere_datacenter
  cluster             = var.vsphere_cluster
  datastore           = var.vsphere_datastore

  export {
    name  = var.vm_name
    images = false
    force = true

    output_directory  = var.output_directory
  }
}

build {
  sources = ["source.vsphere-clone.sqlserver-template"]

  provisioner "shell" {
    inline = [
      "cloud-init status --wait",
    ]
  }

  provisioner "shell" {
    scripts = [
      "${local.directories.source}/scripts/configure-server.sh ${var.mssql_edition} ${var.sa_password}",
    ]
  }

  provisioner "shell" {
    scripts = [
      "${local.directories.source}/scripts/install-client.sh",
    ]
  }

  provisioner "shell" {
    inline = [
      "sudo cloud-init clean",
      "sudo cloud-init clean -l",
    ]
  }

}

