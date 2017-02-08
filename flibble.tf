provider "digitalocean" {}

variable "mrflibble_letsencrypt_email" {}
variable "mrflibble_domain_name" {}

data "template_file" "flibble_shell_script" {
  template = "${file("${path.module}/flibble.sh")}"
  vars {
    mrflibble_letsencrypt_email = "${var.mrflibble_letsencrypt_email}"
    mrflibble_domain_name = "${var.mrflibble_domain_name}"
  }
}

resource "digitalocean_droplet" "flibble" {
  count = 1
  image = "centos-7-x64"
  name = "flibble"
  region = "sgp1"
  size = "512mb"
  backups = true
  ssh_keys = ["1207665"]
  user_data = "${data.template_file.flibble_shell_script.rendered}"
}