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
variable "tenancy_ocid"      {default="ocid_tenancy.xxx"}
variable "region"            {default="us-ashburn-1"}
variable "compartment_ocid"  {default="ocid_compartment.xxx"}
variable "current_user_ocid" {default="ocid_user.xxx"}
// --- DEV configuration --- //

// --- tenancy configuration --- //
locals {
  lifecycle      = jsondecode(file("${path.module}/settings/lifecycle.json"))
  backup         = jsondecode(file("${path.module}/settings/backup.json"))
  classification = jsondecode(file("${path.module}/settings/classification.json"))
}
module "configuration" {
  source         = "./default/"
  providers = {oci = oci.service}
  account = {
    tenancy_id     = var.tenancy_ocid
    class          = local.classification[var.class]
    compartment_id = var.compartment_ocid
    home           = var.region
    user_id        = var.current_user_ocid
  }
  service = {
    adb        = format(
      "%s_%s",
      lower(var.adb_type),
      lower(var.adb_size)
    )
    budget     = var.budget
    encrypt    = var.create_wallet
    label      = format(
      "%s%s%s", 
      lower(substr(var.organization, 0, 3)), 
      lower(substr(var.name, 0, 2)),
      lower(substr(var.stage, 0, 3)),
    )
    name       = format(
      "%s_%s_%s",
      lower(var.organization),
      lower(var.name),
      lower(var.stage)
    )
    region     = var.location
    stage      = local.lifecycle[var.stage]
    osn        = var.osn
    owner      = var.owner
    repository = var.repository
    topologies = flatten(compact([
      var.management == true ? "cloud" : "", 
      var.host       == true ? "host" : "", 
      var.nodes      == true ? "nodes" : "", 
      var.container  == true ? "container" : ""
    ]))
    wallet     = var.wallet
  }
}
// --- tenancy configuration --- //

#output "resident"   {value = module.configuration.resident}
#output "encryption" {value = module.configuration.encryption}
#output "network"    {value = module.configuration.network}
#output "database"   {value = module.configuration.database}
output "storage"    {value = module.configuration.storage}