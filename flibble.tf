provider "digitalocean" {}

variable "mrflibble_ssh_keys" {
  default = ["1207665"] # Obviously provide your own keys ;)
}
variable "mrflibble_letsencrypt_email" {}
variable "mrflibble_domain_name" {}
variable "mrflibble_subdomain_name" {
  default = "mrflibble"
}
variable "mrflibble_git_repository" {}

data "template_file" "mrflibble_shell_script" {
  template = "${file("${path.module}/flibble.sh")}"
  vars {
    mrflibble_letsencrypt_email = "${var.mrflibble_letsencrypt_email}"
    mrflibble_domain_name = "${var.mrflibble_domain_name}"
    mrflibble_subdomain_name = "${var.mrflibble_subdomain_name}"
    mrflibble_git_repository = "${var.mrflibble_git_repository}"
  }
}

resource "digitalocean_droplet" "mrflibble" {
  count = 1
  image = "centos-7-x64"
  name = "${var.mrflibble_subdomain_name}"
  region = "sgp1"
  size = "2gb"
  backups = true
  ssh_keys = "${var.mrflibble_ssh_keys}"
  user_data = "${data.template_file.mrflibble_shell_script.rendered}"
}

resource "digitalocean_floating_ip" "mrflibble_fip" {
  droplet_id = "${digitalocean_droplet.mrflibble.id}"
  region = "${digitalocean_droplet.mrflibble.region}"
}

# I use this has the primary FIP I put at the root of my domain;
# This means it never changes unless this FIP is lost
resource "digitalocean_floating_ip" "primary_fip" {
  region = "${digitalocean_droplet.mrflibble.region}"
}

resource "digitalocean_domain" "mrflibble_domain" {
  name = "${var.mrflibble_domain_name}"
  ip_address = "${digitalocean_floating_ip.primary_fip.ip_address}"
}

resource "digitalocean_record" "mrflibble_a_record" {
  domain = "${digitalocean_domain.mrflibble_domain.id}"
  type = "A"
  name = "${var.mrflibble_subdomain_name}.${var.mrflibble_domain_name}"
  value = "${digitalocean_floating_ip.mrflibble_fip.ip_address}"
}
