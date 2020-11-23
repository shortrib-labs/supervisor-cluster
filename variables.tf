variable "environment" {
    type = string
    default = ""
}

variable "domain" {
    type = string
    default = ""
}

variable "email" {
    type = string
}

variable "vcenter_password" {
    type = string
}

variable "project_root" {
    type = string
}

locals {
    environment = var.environment 
    dashed_environment = replace(local.environment, ".", "-")

    subdomain = "${local.environment}.${var.domain}"
    dashed_subdomain = replace(local.subdomain, ".", "-")

    supervisor_host = "supervisor.${local.subdomain}"

    directories = {
        secrets = "${var.project_root}/secrets"
    }

}
