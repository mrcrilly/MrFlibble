provider "digitalocean" {}
resource "digitalocean_droplet" "flibble" {
  count = 1
  image = "centos-7-x64"
  name = "flibble"
  region = "sgp1"
  size = "512mb"
  backups = true
  ssh_keys = ["1207665"]
  user_data = "${file("${path.module}/flibble.sh")}"
}