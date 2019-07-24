resource "oci_core_virtual_network" "vcn1" {
  cidr_block     = "10.10.0.0/16"
  dns_label      = "vcn1"
  compartment_id = var.compartment_ocid
}

resource "oci_core_subnet" "subnet1" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  cidr_block          = "10.10.1.0/24"
  display_name        = "subnet1"
  dns_label           = "subnet1"
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_virtual_network.vcn1.id
  security_list_ids   = [oci_core_security_list.LBSecurityList.id]
  route_table_id      = oci_core_route_table.LBRouteTable.id
  dhcp_options_id     = oci_core_virtual_network.vcn1.default_dhcp_options_id
}

// An AD based subnet will supply an Availability Domain
resource "oci_core_subnet" "subnet2" {
  availability_domain = data.oci_identity_availability_domain.ad2.name
  cidr_block          = "10.10.2.0/24"
  display_name        = "subnet2"
  dns_label           = "subnet2"
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_virtual_network.vcn1.id
  security_list_ids   = [oci_core_security_list.LBSecurityList.id]
  route_table_id      = oci_core_route_table.LBRouteTable.id
  dhcp_options_id     = oci_core_virtual_network.vcn1.default_dhcp_options_id
}

resource "oci_core_internet_gateway" "LBIG" {
  compartment_id = var.compartment_ocid
  display_name   = "LBExampleIG"
  vcn_id         = oci_core_virtual_network.vcn1.id
}

resource "oci_core_route_table" "LBRouteTable" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn1.id
  display_name   = "LBExampleRouteTable"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.LBIG.id
  }
}

resource "oci_core_security_list" "LBSecurityList" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn1.id
  display_name   = "LBSecurityList"

  // allow outbound tcp traffic on all ports
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all" 
    }
  
  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 80
      max = 80
    }
  }

  ingress_security_rules {
    protocol  = "6" // tcp
    source    = "0.0.0.0/0"
    stateless = false
    tcp_options {
      min = 22
      max = 22
    }
  }

  ingress_security_rules {
    protocol  = 1
    source    = "0.0.0.0/0"
    stateless = true

    icmp_options {
      type = 3
      code = 4
    }
  }
}

resource "oci_core_instance" "LBTest" {
  count               = var.NumInstances
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_ocid
  display_name        = "LBtest${count.index}"
  shape               = var.instance_shape

  create_vnic_details {
    subnet_id        = oci_core_subnet.subnet1.id
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = "subnet1instance${count.index}"
  }
  
  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = base64encode(file(var.BootStrapFile))
  }

  source_details {
    source_type = "image"
    source_id   = "${var.instance_image_ocid}"
  }
}


resource  "null_resource" "firewalld" {
   count               = var.NumInstances
   connection {
    type        = "ssh"
    host        = "${oci_core_instance.LBTest[count.index].public_ip}"
    user        = "opc"
    private_key = "${file("~/.ssh/id_rsa")}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo firewall-cmd --permanent --zone=public --add-service=http",
      "sudo firewall-cmd --reload",
    ]
  }
}
