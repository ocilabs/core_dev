// Copyright (c) 2020 Oracle and/or its affiliates.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "database" {
  value = flatten(distinct([for adb in local.adb_types: [for size in local.adb_sizes : {
      compartment  = contains(flatten(var.resident.domains[*].name), "database") ? "${local.service_name}_database_compartment" : local.service_name
      cores        = size.cores
      display_name = "${local.service_name}_database"
      license      = adb.license
      name         = "${lower(adb.name)}_${size.name}"
      password     = "${adb.password}_password"
      stage        = adb.stage
      storage      = size.storage
      type         = adb.type
      version      = adb.version
  }if var.service.adb == "${adb.name}_${size.name}"]]))[0]
}