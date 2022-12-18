resource "hcloud_server" "srv11" {
  name = "srv11"
  image = "ubuntu-22.04"
  server_type = "cx31"
  location = "nbg1"
  keep_disk = true
  delete_protection = true
  rebuild_protection = true
  allow_deprecated_images = false

  ssh_keys = [
    hcloud_ssh_key.ansible_key.name,
    hcloud_ssh_key.enrico_general_key.name,
    hcloud_ssh_key.enrico_main_key.name,
    hcloud_ssh_key.enrico_backup_key.name
  ]

  firewall_ids = [
    hcloud_firewall.srv11_fw4_base.id,
    hcloud_firewall.srv11_fw4_servizi.id,
    hcloud_firewall.srv11_fw6_base.id,
    hcloud_firewall.srv11_fw6_adm.id,
    hcloud_firewall.srv11_fw6_servizi.id
  ]

  lifecycle {
    ignore_changes = [
      image,
      ssh_keys
    ]
  }
}

###

resource "hcloud_volume" "volume_1" {
  name = "volume_1"
  size = 96
  server_id = hcloud_server.srv11.id
  delete_protection = true
  labels = {
    "zpool" = "vasca"
  }
}

resource "hcloud_volume" "volume_2" {
  name = "volume_2"
  size = 96
  server_id = hcloud_server.srv11.id
  delete_protection = true
  labels = {
    "zpool" = "vasca"
  }
}

resource "hcloud_volume" "volume_3" {
  name = "volume_3"
  size = 96
  server_id = hcloud_server.srv11.id
  delete_protection = true
  labels = {
    "zpool" = "vasca"
  }
}

###

resource "hcloud_floating_ip" "ip4_1o" {
  description   = "primario IPv4"
  name = "ip4_1o"
  type = "ipv4"
  home_location = "nbg1"
  delete_protection = true
  server_id = hcloud_server.srv11.id
}

resource "hcloud_floating_ip" "net6_1o" {
  description   = "primario NET6"
  name = "net6_1o"
  type = "ipv6"
  home_location = "nbg1"
  delete_protection = true
  server_id = hcloud_server.srv11.id
}
