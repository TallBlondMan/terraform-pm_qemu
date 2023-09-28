variable "pm_api_url" {
  type        = string
  default     = "https://10.6.0.214:8006/api2/json"
  description = "The node to which it should connect"
}

variable "vm_name" {
  type = string
  # Name cannot contain underscore 
  default     = "alma-machine-test"
  description = "Unique name of the machine !! Cannot be with underscore !!"
}

variable "pve_node" {
  type        = string
  default     = "bre-pve-07"
  description = "Target node where the machine should be deployed"
}

variable "vm_id" {
  type        = string
  default     = "0"
  description = "VMID of the machine to be created - 0 for next available"
}
