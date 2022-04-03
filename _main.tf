// Copyright (c) 2020 Oracle and/or its affiliates.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

// readme.md created with https://terraform-docs.io/: terraform-docs markdown --sort=false ./ > ./README.md

// --- provider settings --- //
terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
    }
  }
}
provider "oci" {
  alias  = "service"
  region = var.location
}
provider "oci" {
  alias  = "home"
  region = module.configuration.tenancy.region.name
}
// --- provider settings  --- //

// --- DEV configuration --- //
variable "tenancy_ocid" {default="ocid_tenancy.xxx"}
variable "region" {default="us-ashburn-1"}
variable "compartment_ocid" {default="ocid_compartment.xxx"}
variable "current_user_ocid" {default="ocid_user.xxx"}
// --- DEV configuration --- //

// --- tenancy configuration --- //
locals {
  topologies = flatten(compact([var.cloud == true ? "cloud" : "", var.host == true ? "host" : "", var.nodes == true ? "nodes" : "", var.container == true ? "container" : ""]))
  domains    = jsondecode(file("${path.module}/default/resident/domains.json"))
  segments   = jsondecode(file("${path.module}/default/network/segments.json"))
}
module "configuration" {
  source         = "./default/"
  providers = {oci = oci.service}
  input = {
    adb          = var.adb_type
    class        = var.class
    region       = var.location
    organization = var.organization
    osn          = var.osn
    owner        = var.owner
    repository   = var.repository
    stage        = var.stage
    solution     = var.solution
    tenancy      = var.tenancy_ocid
    wallet       = var.wallet_type
  }
  resident = {
    topologies = local.topologies
    domains    = local.domains
    segments   = local.segments
  }
}

// --- tenancy configuration --- //

#output "tenancy"    {value = module.configuration.tenancy}
#output "resident"   {value = module.configuration.resident}
#output "encryption" {value = module.configuration.encryption}
#output "network"    {value = module.configuration.network}
output "databases"  {value = module.configuration.databases}