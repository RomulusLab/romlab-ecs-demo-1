variable "romlab-ecsdemo-vpc_cidr" {
  type    = string
}

variable "romlab-ecsdemo-public_cidrs" {
  type    = list(string)
}

variable "romlab-ecsdemo-priv_cidrs" {
  type    = list(string)
}

variable "romlab-ecsdemo_azs" {
  type    = list(string)
}

variable "romlab-ecsdemo-name_prefix" {
  type    = string
  default = "romlab-ecsdemo"
}

variable "romlab-pub_subnet_ids" {
  type = list(string)
}

variable "romlab-vpc_id" {
  type = string
}