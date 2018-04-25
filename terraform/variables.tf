
variable "vn_cidr" {
  type = "string"
  default = "10.0.17.0/24"
  description = "Virtual Network cidr block"
}

variable "subnet_cidr" {
  type = "string"
  default = "10.0.17.0/28"
  description = "Virtual Network cidr block"
}

variable "location" {
  type = "string"
  default = "westeurope"
}

variable "machine_count" {
  default = 1
  description = "Number of machines behind a load balancer"
}