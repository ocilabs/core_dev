// Copyright (c) 2020 Oracle and/or its affiliates.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

variable "adb_size" {
  type = string
  description = "Configures the size of database"
  default     = "SMALL"
}

variable "adb_type" {
  type = string
  description = "Configures the type of database"
  default     = "TRANSACTION_PROCESSING"
}

variable "budget" {
  type = number
  description = "Sets a monthly budget for the service"
  default     = 500
}

variable "class" {
  type        = string
  description = "The tenancy classification sets boundaries for resource deployments"
  default     = "PAYG"
}

variable "container" {
  type        = bool
  description = "Provisioning a container topology prepares a service resident to deploy cloud native services on Oracle's Kubernetes Engine (OKE)."
  default     = true
}

variable "create_adb" {
  type        = bool
  description = "Define whether a database is created or not"
  default     = false
}

variable "create_wallet" {
  type        = bool
  description = "Creates a wallet to store secrets"
  default     = true
}

variable "host" {
  type        = bool
  description = "Provisioning a host topology prepares a service resident to deploy a traditional enterprise application with presentation, application and database tier."
  default     = true
}

variable "internet" {
  type        = string
  description = "Allows or disallows to provision resources with public IP addresses."
  default     = "ENABLE"
}

variable "ipv6" {
  type = bool
  description = "Triggers the release of IPv6 addresses inside the VCN."
  default     = false
}

variable "location" {
  type        = string
  description = "The region defines the target region for service deployments"
  default     = "us-ashburn-1"
}

variable "management" {
  type        = bool
  description = "Provisioning a network topology allows to access Oracle's public cloud services via a private transfer domain."
  default     = true
}

variable "nat" {
  type = string
  description = "Enables or disables routes through a NAT Gateway."
  default     = "ENABLE"
}

variable "nodes" {
  type        = bool
  description = "Provisioning a nodes topology prepares a service resident to deploy automatically scaling services separated front- and backend tier for services like like big data or mobile backend."
  default     = true
}

variable "organization"            { 
  type        = string
  description =  "The organization represents an unique identifier for a service owner and triggers the definition of groups on root compartment level"
  default     = "Organization"
  validation {
    condition     = length(regexall("^[A-Za-z][A-Za-z]{1,26}$", var.organization)) > 0
    error_message = "The service_name variable is required and must contain upto 15 alphanumeric characters only and start with a letter."
  }
}

variable "osn" {
  type = string
  description = "Configures the scope for the service gateway"
  default     = "ALL"
}

variable "owner" {
  type        = string
  description = "The service owner is identified by his or her eMail address"
  default     = "RobotNotExist@oracle.com"
}

variable "parent" {
  type = string
  description = "The Oracle Cloud Identifier (OCID) for a parent compartment, an encapsulating child compartment will be created to define the service resident. Usually this is the root compartment, hence the tenancy OCID."
  default="ocid_tenancy.xxx"
}

variable "repository" {
  type        = string
  description = "The service configuration is stored using infrastructure code in a repository"
  default     = "https://github.com/torstenboettjer/ocloud-default-configuration"
}

variable "name"            { 
  type        = string
  description =  "The service represents an unique identifier for a service defined on root compartment level"
  default     = "Service"   # Define a name that identifies the service
  validation {
    condition     = length(regexall("^[A-Za-z][A-Za-z]{1,26}$", var.name)) > 0
    error_message = "The service_name variable is required and must contain alphanumeric characters only, start with a letter and 15 character max."
  }
}

variable "stage"           { 
  type = string
  description = "The stage variable triggers lifecycle related resources to be provisioned"
  default = "PRODUCTION"           # Lifecycle stage for the code base
  validation {
    condition     = length(regexall("^[A-Za-z][A-Za-z0-9]{1,12}$", var.stage)) > 0
    error_message = "A service_name variable is required and must contain alphanumeric characters only, start with a letter and 4 character max."
  }
}

variable "wallet" {
  type = string
  description = "Defines the vault type."
  default     = "SOFTWARE"
}
