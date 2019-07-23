output "InstancePublicIPs" {
  value = [oci_core_instance.LBTest.*.public_ip]
}

output "InstancePrivateIPs" {
  value = [oci_core_instance.LBTest.*.private_ip]
}

output "lb_public_ip" {
  value = ["${oci_load_balancer.lb1.ip_addresses}"]
}
