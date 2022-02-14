// Copyright (c) 2020 Oracle and/or its affiliates.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

// readme.md created with https://terraform-docs.io/: terraform-docs markdown --sort=false ./ > ./readme.md

// --- provider settings --- //
terraform {
  required_providers {
    oci = {
      source = "hashicorp/oci"
    }
  }
}
provider "oci" { 
  alias = "init"
}
provider "oci" {
  alias  = "home"
  region = module.configuration.tenancy.region.key
}
// --- provider settings  --- //

// --- DEV configuration --- //
variable "tenancy_ocid" {
    default="ocid_tenancy.xxx"
    description = "A unique identifier for the root tenancy, provided by the cloud controller"
}
// --- DEV configuration --- //

// --- tenancy configuration --- //
module "configuration" {
  source         = "./default/"
  asset = {
    domains      = var.domains
    segments     = var.segments
  }
  input = {
    tenancy      = var.tenancy_ocid
    class        = var.class
    owner        = var.owner
    organization = var.organization
    solution     = var.solution
    repository   = var.repository
    stage        = var.stage
    region       = var.region
  }
}
output "tenancy"  {value = module.configuration.tenancy}
output "resident" {value = module.configuration.resident}
output "network"  {value = module.configuration.network}
