variable "k8s_cluster" {
  type = map(object({
    cpu        = number
    ram        = number
    hdd        = number
    image_path = string
  }))
}
