variable "instance_image_ocid" {
}

variable "tenancy_ocid" {}

variable "user_ocid" {}

variable "fingerprint" {
}

variable "private_key_path" {
}

variable "compartment_ocid" {
}

variable "NumInstances" {
}

variable "instance_shape" {
}

variable "ssh_public_key" {
}

variable "region"{}

variable "BootStrapFile" {
  default = "./userdata/bootstrap"
}

