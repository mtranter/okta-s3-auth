variable "site_domain" {
  type = string
}

variable "app_label" {
  type = string
}

variable "callback_path" {
  type = string
}

variable "cnames" {
  type = list(string)
  default = []
}

variable "app_logo" {
  default = null
}