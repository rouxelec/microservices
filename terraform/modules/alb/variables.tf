variable "vpc_id" {
    type=string
}

variable "public_subnet_cidr_blocks" {
    type=list
}

variable project_name {
    type = string
}

variable namespace {
    type = string
}
variable committer {
    type = string
}