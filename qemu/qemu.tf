terraform {
	required_providers {
		libvirt = {
			source = "dmacvicar/libvirt"
		}
	}
}

# For Local
# provider "libvirt" {
#	uri = "qemu:///system"
# }

# Remote via SSH (respects ~/.ssh/config)
# in this case, this is a Tailscale ip
provider "libvirt" {
	uri = "qemu+ssh://jhonatan@100.70.196.37/system"
}

resource "libvirt_domain" "laptopvm" {
	name         = "laptopvm"
	type         = "kvm"
	memory       = 1024
	memory_unit  = "MiB"
	vcpu         = 2

	libvirt_network {
		network_name = "default"
	}

  # disk...
  
	os = {
		type         = "hvm"
		type_arch    = "x86_64"
		type_machine = "q35"
	}
}


