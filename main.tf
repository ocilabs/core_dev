# Copyright (c) 2020 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.
# readme.md created with https://terraform-docs.io/ : terraform-docs markdown --sort=false ./ > ./readme.md

// --- Terraform provider --- //
terraform {
    required_providers {
        oci = {
            source = "hashicorp/oci"
        }
    }
}

# OCI service provider
provider "oci" { 
    alias = "init"
}
provider "oci" {
    alias  = "home"
    region = module.configuration.tenancy.region.key
}
// --- Terraform provider --- //
variable "tenancy_ocid" {
    default="ocid_tenancy.xxx"
    description = "A unique identifier for the root tenancy, provided by the cloud controller"
}
module "configuration" {
    source         = "./configuration/"
    input = {
        tenancy      = var.tenancy_ocid
        class        = var.class
        owner        = var.owner
        organization = var.organization
        solution     = var.solution
        repository   = var.repository
        stage        = var.stage
        region       = var.region
        domains      = var.domains
        segments     = var.segments
    }
}

/*
output "tenancy"   {
    value = module.configuration.tenancy
    description = "Static parameters for the tenancy configuration"
}
output "service"  {
    value = module.configuration.service
    description = "Static parameters for the service configuration"
}
output "network"  {
    value = module.configuration.network
    description = "Configuration parameters that define a network topology"
}
*/
output "resident" {
    value = module.configuration.resident
    description = "Configuration parameters that define a service compartment"
}