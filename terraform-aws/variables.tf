variable environment {
  type    = "string"
  default = "dev"
}

variable name {
  type    = "string"
  default = "flre"
}

variable application {
  type    = "string"
  default = "app"
}

variable instance_count {
  type    = "string"
  default = "1"
}

variable ami_id {
  type    = "string"
  default = "ami-ed82e39e"
}

variable instance_type {
  type    = "string"
  default = "t2.nano"
}

variable public_key {
  type    = "string"
  default = "public_key"
}
