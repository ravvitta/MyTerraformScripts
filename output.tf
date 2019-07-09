output "services" {
  value = [data.oci_core_services.test_services.services]
}

