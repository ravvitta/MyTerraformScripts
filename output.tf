#OutPut File
output "services" {
  value = [data.oci_core_services.test_services.services]
}

output "cluster_kubernetes_versions" {
  value = ["${data.oci_containerengine_cluster_option.test_cluster_option.kubernetes_versions}"]
}

output "node_pool_kubernetes_version" {
  value = ["${data.oci_containerengine_node_pool_option.test_node_pool_option.kubernetes_versions}"]
}
