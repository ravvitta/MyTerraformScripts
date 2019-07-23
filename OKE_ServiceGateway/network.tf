resource "oci_core_virtual_network" "OKEvcn" {
  cidr_block     = "100.100.0.0/16"
  dns_label      = "OKEvcn"
  compartment_id = var.compartment_ocid
}

resource "oci_core_subnet" "subnet1" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  cidr_block          = "100.100.24.0/24"
  display_name        = "AD1"
  dns_label           = "AD1subnet"
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_virtual_network.OKEvcn.id
  security_list_ids   = [oci_core_security_list.OKESecurityList.id]
  route_table_id      = oci_core_route_table.OKERouteTable.id
  dhcp_options_id     = oci_core_virtual_network.OKEvcn.default_dhcp_options_id
}

resource "oci_core_subnet" "subnet2" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  cidr_block          = "100.100.25.0/24"
  display_name        = "AD2"
  dns_label           = "AD2subnet"
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_virtual_network.OKEvcn.id
  security_list_ids   = [oci_core_security_list.OKESecurityList.id]
  route_table_id      = oci_core_route_table.OKERouteTable.id
  dhcp_options_id     = oci_core_virtual_network.OKEvcn.default_dhcp_options_id
}

resource "oci_core_subnet" "subnet3" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  cidr_block          = "100.100.26.0/24"
  display_name        = "AD3"
  dns_label           = "AD3subnet"
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_virtual_network.OKEvcn.id
  security_list_ids   = [oci_core_security_list.OKESecurityList.id]
  route_table_id      = oci_core_route_table.OKERouteTable.id
  dhcp_options_id     = oci_core_virtual_network.OKEvcn.default_dhcp_options_id
}

resource "oci_core_subnet" "subnet4" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  cidr_block          = "100.100.27.0/24"
  display_name        = "AD4"
  dns_label           = "AD4subnet"
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_virtual_network.OKEvcn.id
  security_list_ids   = [oci_core_security_list.OKESecurityList.id]
  route_table_id      = oci_core_route_table.OKERouteTable.id
  dhcp_options_id     = oci_core_virtual_network.OKEvcn.default_dhcp_options_id
}

resource "oci_core_subnet" "subnet5" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  cidr_block          = "100.100.28.0/24"
  display_name        = "AD5"
  dns_label           = "AD5subnet"
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_virtual_network.OKEvcn.id
  security_list_ids   = [oci_core_security_list.OKESecurityList.id]
  route_table_id      = oci_core_route_table.OKERouteTable.id
  dhcp_options_id     = oci_core_virtual_network.OKEvcn.default_dhcp_options_id
}

resource "oci_core_service_gateway" "ServiceGwy" {
  compartment_id = var.compartment_ocid
  services {
    service_id = data.oci_core_services.test_services.services[0].id
  }
  display_name = "OKEServiceGateway"
  vcn_id       = oci_core_virtual_network.OKEvcn.id
}

resource "oci_core_route_table" "OKERouteTable" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.OKEvcn.id
  display_name   = "OKERouteTable"

  route_rules {
    destination       = data.oci_core_services.test_services.services[0]["cidr_block"]
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = oci_core_service_gateway.ServiceGwy.id
  }
}

resource "oci_core_security_list" "OKESecurityList" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.OKEvcn.id
  display_name   = "OKESecurityList"

  // allow outbound tcp traffic on all ports
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "6"
  }


  // allow inbound ssh traffic from a specific port
  ingress_security_rules {
    protocol  = "6" // tcp
    source    = "0.0.0.0/0"
    stateless = false

    tcp_options {
      // These values correspond to the destination port range.
      min = 22
      max = 22
    }
  }

  // allow inbound icmp traffic of a specific type
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
