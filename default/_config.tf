// Copyright (c) 2020 Oracle and/or its affiliates.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.
# readme.md created with https://terraform-docs.io/: terraform-docs markdown --sort=false ./ > ./readme.md

// --- Terraform Provider --- //
terraform {
    required_providers {
        oci = {
            source = "oracle/oci"
        }
    }
}
// --- Terraform Provider --- //

// --- DEV Tenancy Configuration ---//
locals {
    region_key        = "key_tbd"
    region_name       = "name_tbd"
    home_region_key   = "home_key_tbd"
    home_region_name  = "home_name_tbd"
    osn_ids = {
        "all"     = "ocid_all_tbd"
        "storage" = "ocid_storage_tbd"
    }
    osn_cidrs = {
        "all"     = "all-iad-services-in-oracle-services-network"
        "storage" = "oci-iad-objectstorage"
    }
}
// --- DEV Tenancy Configuration ---//

/*/ --- Tenancy Configuration ---//
data "oci_identity_tenancy" "tenant" {tenancy_id = var.tenancy_ocid}
data "oci_identity_compartments" "tenant" {compartment_id = var.tenancy_ocid} 
data "oci_identity_regions" "tenant" { }
data "oci_identity_availability_domains" "tenant" {compartment_id = var.tenancy_ocid} 
# list data center (availability domain) names in home region 
data "template_file" "ad_names" { 
    count    = length(data.oci_identity_availability_domains.tenant.availability_domains)
    template = lookup(data.oci_identity_availability_domains.tenant.availability_domains[count.index], "name")
}
# retrieve object storage namespace
data "oci_objectstorage_namespace" "tenant" {compartment_id = var.tenancy_ocid}
# retrieve parameter of Oracle Service Network (osn) services
data "oci_core_services" "all" {
    filter {
        name   = "name"
        values = ["All .* Services In Oracle Services Network"]
        regex  = true
    }
}

data "oci_core_services" "storage" {
    filter {
        name   = "name"
        values = ["OCI .* Object Storage"]
        regex  = true
    }
}

# region parameter
locals {
    # Discovering the home region name and region key.
    regions_map         = {for region in data.oci_identity_regions.tenant.regions : region.key => region.name}
    regions_map_reverse = {for region in data.oci_identity_regions.tenant.regions : region.name => region.key}
    # Deployment region
    region_key          = local.regions_map_reverse[var.service.region]
    region_name         = var.service.region
    # Home region key obtained from the tenancy data source
    home_region_key     = data.oci_identity_tenancy.tenant.home_region_key
    # Region key obtained from the region name
    home_region_name    = local.regions_map[local.home_region_key]
    home_region_ads     = sort(data.template_file.ad_names.*.rendered)
    # Object Storage Namespace for the tenancy
    storage_namespace = data.oci_objectstorage_namespace.tenant
    osn_ids = {
        "all"     = lookup(data.oci_core_services.all.services[0], "id")
        "storage" = lookup(data.oci_core_services.storage.services[0], "id")
    }
    osn_cidrs = {
        "all"     = lookup(data.oci_core_services.all.services[0], "cidr_block")
        "storage" = lookup(data.oci_core_services.storage.services[0], "cidr_block")
    }
}
// --- Tenancy Configuration ---/*/
