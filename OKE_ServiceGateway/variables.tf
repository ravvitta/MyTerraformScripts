variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "compartment_ocid" {}
variable "ssh_public_key" {}

variable "region" {
  default = "us-ashburn-1"
}

variable "cluster_options_add_ons_is_kubernetes_dashboard_enabled" {
  default = true
}

variable "cluster_options_add_ons_is_tiller_enabled" {
  default = true
}

variable "availability_domain" {
  default = 3
}

variable "node_pool_initial_node_labels_key" {
  default = "key"
}

variable "node_pool_initial_node_labels_value" {
  default = "value"
}

variable "node_pool_name" {
  default = "OKEPool"
}

variable "node_pool_node_image_name" {
  default = "Oracle-Linux-7.4"
}

variable "node_pool_node_shape" {
  default = "VM.Standard2.1"
}

variable "node_pool_quantity_per_subnet" {
  default = 2
}

variable "node_pool_ssh_public_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDBinYkGJvM1pdPK2NkRJdoaO1EJSir4WMkBJIH62wYF+9xBC+M8FGeVSz5y4nBxkNkmLAgiCf8VTf/ZD7MUIGbi2sqwP818RsHJBCCwQVCRbtUkH6LRWG8t4iOTBTcq4hGOzyFCf9Kw+uxiG8ct44gWmgqK4aJz+A1/tNP8bc6wDh+LoGcp8Vu9+oxDW/szz3plOaMhYvnYzY5FjOwrYO8hnyVvXl2o0EsFKxUJZPX33VOhhnsB1vs1opfwlwBcpPijyWYbndc1DyfQGjHaoIeQjqna3QxI4LvFpCXhsob+6kKUaA8JEptbb4562IO74Qiju3IqbTsnSfeuaaptso/ ravi.v.vittal@oracle.com"
}

variable "cluster_name" {
  default = "TestCluster"
}
