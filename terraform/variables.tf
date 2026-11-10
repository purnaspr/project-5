variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "availability_zone" {
  type    = string
  default = "us-east-1a"
}

variable "my_ip" {
  type    = string
  default = "0.0.0.0/0"
}

variable "instance" {
  type    = set(string)
  default = ["jenkins", "grafana"]
}

variable "instance_type" {
  type    = string
  default = "t3.small"
}

variable "key_name" {
  type    = string
  default = "project-1"
}

variable "instance_config" {
  type = map(object({
    ports = list(number)
  }))
  default = {
    "jenkins" = {
      ports = [22, 8080]
    }
    "grafana" = {
      ports = [22, 3000, 9000, 9100]
    }
  }
}