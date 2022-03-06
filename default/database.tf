// Copyright (c) 2020 Oracle and/or its affiliates.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "database" {
  value = {
    oltp   = {
      name = "tbd",
      stage = 0
      cores = 1,
      storage = 256
    }
    dw   = {
      name = "tbd",
      stage = 0
    }
    json   = {
      name = "tbd",
      stage = 0
    }
    apex   = {
      name = "tbd",
      stage = 0
    }
  }
}