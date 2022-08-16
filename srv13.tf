resource "hcloud_server" "srv13" {
  name = "srv13"
  image = "ubuntu-22.04"
  server_type = "cx11"
  location = "hel1"
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
    hcloud_firewall.srv13_fw4_base.id,
    hcloud_firewall.srv13_fw4_servizi.id,
    hcloud_firewall.srv13_fw6_base.id,
    hcloud_firewall.srv13_fw6_adm.id,
    hcloud_firewall.srv13_fw6_servizi.id
  ]

  lifecycle {
    ignore_changes = [
      ssh_keys
    ]
  }
}

###

resource "hcloud_floating_ip" "ip4_2o" {
  description   = "secondario IPv4"
  name = "ip4_2o"
  type = "ipv4"
  home_location = "nbg1"  
  delete_protection = true
  server_id = hcloud_server.srv13.id
}
