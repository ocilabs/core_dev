// Copyright (c) 2020 Oracle and/or its affiliates.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

// readme.md created with https://terraform-docs.io/: terraform-docs markdown --sort=false ./ > ./README.md

// --- provider settings --- //
terraform {
  required_providers {
    oci = {
      source = "hashicorp/oci"
    }
  }
}
provider "oci" {
  alias  = "service"
  region = var.region
}
provider "oci" {
  alias  = "home"
  region = module.configuration.tenancy.region.name
}
// --- provider settings  --- //

// --- DEV configuration --- //
variable "tenancy_ocid" {
    default="ocid_tenancy.xxx"
    description = "A unique identifier for the root tenancy, provided by the cloud controller"
}
// --- DEV configuration --- //

// --- tenancy configuration --- //
locals {
  topologies = flatten(compact([var.host == true ? "host" : "", var.nodes == true ? "nodes" : "", var.container == true ? "container" : ""]))
  domains    = jsondecode(file("${path.module}/default/resident/domains.json"))
  wallets    = jsondecode(file("${path.module}/default/encryption/wallets.json"))
  segments   = jsondecode(file("${path.module}/default/network/segments.json"))
  databases  = jsondecode(file("${path.module}/default/database/adb.json"))
}
module "configuration" {
  source         = "./default/"
  providers = {oci = oci.service}
  input = {
    tenancy      = var.tenancy_ocid
    class        = var.class
    owner        = var.owner
    organization = var.organization
    solution     = var.solution
    repository   = var.repository
    stage        = var.stage
    region       = var.region
    osn          = var.osn
  }
  resolve = {
    topologies = local.topologies
    domains    = local.domains
    wallets    = local.wallets
    segments   = local.segments
    databases  = local.databases
  }
}
// --- tenancy configuration --- //

#output "tenancy"    {value = module.configuration.tenancy}
#output "resident"   {value = module.configuration.resident}
#output "encryption" {value = module.configuration.encryption}
#output "network"    {value = module.configuration.network}
output "databases"       {value = module.configuration.databases}