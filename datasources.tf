data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = 1
}

data "oci_core_services" "test_services" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}

#data "oci_core_instance" "PerfInstanceDS" {
#    #Required
#instance_id = "${var.oci_core_instance.PerfInstance0.id}"
#    instance_id = "ocid1.instance.oc1.iad.abuwcljtfqi2hrkdqjwoslk7fgcrmygwwc3x4nhz2gxibvrb7yeup32mm73q"
#}
#data "oci_core_volume" "TFBlock" {
#    #Required
#    volume_id = "ocid1.volume.oc1.iad.abuwcljtfb2iddufyghw5eu5zquvvixtjovf6fi3vk6pbl2522jstebv3o4q"
#}
