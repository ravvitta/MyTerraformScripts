variable "tenancy_ocid" {
}

variable "user_ocid" {
}

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

variable "instance_image_ocid" {
}

variable "ssh_public_key" {
}

variable "region" {
  default = "us-ashburn-1"
}

variable "BootStrapFile" {
  default = "./userdata/bootstrap"
}

variable "NumIscsiVolumesPerInstance" {
  default = "1"
}

variable "NumParavirtualizedVolumesPerInstance" {
  default = "1"
}

variable "DBSize" {
  default = "100" // size in GBs
}

variable "volume_attachment_device" {
  default = "/dev/sdc"
}

