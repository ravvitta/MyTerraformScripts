resource "oci_load_balancer" "lb1" {
  shape          = "100Mbps"
  compartment_id = "${var.compartment_ocid}"

  subnet_ids = [
    "${oci_core_subnet.subnet1.id}",
    "${oci_core_subnet.subnet2.id}",
  ]

  display_name = "LBTest"
  depends_on = ["oci_core_instance.LBTest"]
}

resource "oci_load_balancer_backend_set" "lb-bes1" {
  name             = "LB-Bes1"
  load_balancer_id = "${oci_load_balancer.lb1.id}"
  policy           = "ROUND_ROBIN"

  health_checker {
    port                = "80"
    protocol            = "HTTP"
    response_body_regex = ".*"
    url_path            = "/"
  }
}

resource "oci_load_balancer_listener" "lb-listener1" {
  load_balancer_id         = "${oci_load_balancer.lb1.id}"
  name                     = "http"
  default_backend_set_name = "${oci_load_balancer_backend_set.lb-bes1.name}"
  port                     = 80
  protocol                 = "HTTP"

  connection_configuration {
    idle_timeout_in_seconds = "2"
  }
}

resource "null_resource" "count" {
  count = "${length(oci_core_instance.LBTest)}"
}

resource "oci_load_balancer_backend" "lb-be1" {
  count = "${length(oci_core_instance.LBTest)}"
  load_balancer_id = "${oci_load_balancer.lb1.id}"
  backendset_name  = "${oci_load_balancer_backend_set.lb-bes1.name}"
  ip_address       = "${oci_core_instance.LBTest[count.index].private_ip}"
  port             = 80
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}

#resource "oci_load_balancer_backend" "lb-be2" {
#  count = "${length(oci_core_instance.LBTest)}"
#  load_balancer_id = "${oci_load_balancer.lb1.id}"
#  backendset_name  = "${oci_load_balancer_backend_set.lb-bes1.name}"
#  ip_address       = "${oci_core_instance.LBTest[count.index].private_ip}"
#  port             = 80
#  backup           = false
#  drain            = false
#  offline          = false
#  weight           = 1
#}
