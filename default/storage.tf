// Copyright (c) 2020 Oracle and/or its affiliates.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "storage" {
  value = {
    buckets = {for bucket in local.buckets: "${lower(bucket.objects)}_${lower(bucket.tier)}" => {
      access_type  = bucket.exposure
      secret       = bucket.key
      metadata     = bucket.description
      name         = "${local.service_name}_${lower(bucket.objects)}_${lower(bucket.tier)}"
      stage        = bucket.stage
      storage_tier = bucket.tier
    }}
  }
}