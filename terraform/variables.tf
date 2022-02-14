variable "project" {
  default = "red-reference-341109"
}

variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-a"
}

variable "application" {
  type = map(any)
  default = {
    "image"               = ""
    "postgresql_port"     = ""
    "postgresql_user"     = ""
    "postgresql_password" = ""
    "postgresql_dbname"   = ""
  }
}

variable "ssh_keys" {
  type = list(object({
    publickey = string
    user      = string
  }))
  description = "list of public ssh keys that have access to the VM"
  default = [
    # {
    #   user      = "your name"
    #   publickey = "your key"
    # },
    {
      user      = "nstrogii"
      publickey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINY/6dteeryL4LWGtPtguE5a0dqCi3t9Od3LfxUpprhH nazar.strogii"
    }
  ]
}
