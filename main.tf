terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      version = "1.34.3"
    }

    vault = {
      source = "hashicorp/vault"
      version = "3.7.0"
    }
  }
}

###

# N.B. Per fare chiedere a Terraform il token di vault ad ogni esecuzione
#      bisogna scommentare
#        variable "vault_token" {}
#      che è qui sotto, inoltre bisogna scommentare
#        token = var.vault_token
#      nella definizione del provider "vault"
#variable "vault_token" {}

#
# N.B. Il token deve avere la seguente capability:
#   path "auth/token/create" {
#     capabilities = [ "update" ]
#   }
#
provider "vault" {
  address = "https://vault.megane.eb:8443"
  #token = var.vault_token
}

###

data "vault_generic_secret" "hetzner_megane" {
  path = "kv/hetzner/megane"
}

provider "hcloud" {
  token = data.vault_generic_secret.hetzner_megane.data [ "radice" ]
}

###

data "vault_generic_secret" "ansible_key_path" {
  path = "kv/ssh-client/ansible@cfg.jigen.megane.eb+ed25519"
}

resource "hcloud_ssh_key" "ansible_key" {
  name = "Ansible, 2018"
  public_key = data.vault_generic_secret.ansible_key_path.data [ "pub" ]
}

data "vault_generic_secret" "enrico_general_key_path" {
  path = "kv/ssh-client/enrico@jigen.megane.eb+ed25519"
}

resource "hcloud_ssh_key" "enrico_general_key" {
  name = "Enrico Baccianini, 2018"
  public_key = data.vault_generic_secret.enrico_general_key_path.data [ "pub" ]
}

data "vault_generic_secret" "enrico_main_key_path" {
  path = "kv/ssh-client/enrico@jigen.megane.eb+ed25519-sk"
}
resource "hcloud_ssh_key" "enrico_main_key" {
  name = "Enrico Baccianini, 2021 - 5060408461426"
  public_key = data.vault_generic_secret.enrico_main_key_path.data [ "pub" ]
}

data "vault_generic_secret" "enrico_backup_key_path" {
  path = "kv/ssh-client/enrico@kosmos.megane.eb+ed25519-sk"
}
resource "hcloud_ssh_key" "enrico_backup_key" {
  name = "Enrico Baccianini, emergenza - 16016883"
  public_key = data.vault_generic_secret.enrico_backup_key_path.data [ "pub" ]
}

###

resource "hcloud_server" "srv11" {
  name = "srv11"
  image = "ubuntu-20.04"
  server_type = "cx31"
  location = "nbg1"
  keep_disk = true
  delete_protection = true
  rebuild_protection = true
  
  ssh_keys = [ 
    hcloud_ssh_key.ansible_key.name,
    hcloud_ssh_key.enrico_general_key.name,
    hcloud_ssh_key.enrico_main_key.name
  ]

  firewall_ids = [ 
    hcloud_firewall.fw4_base.id,
    hcloud_firewall.srv11_fw4_servizi.id,
    hcloud_firewall.fw6_base.id,
    hcloud_firewall.srv11_fw6_servizi.id,
    hcloud_firewall.srv11_fw6_adm.id
  ]

  lifecycle {
    ignore_changes = [
      image,
      ssh_keys
    ]
  }
}

resource "hcloud_server" "srv13" {
  name = "srv13"
  image = "ubuntu-20.04"
  server_type = "cx11"
  location = "hel1"
  keep_disk = true
  delete_protection = true
  rebuild_protection = true
  
  ssh_keys = [ 
    hcloud_ssh_key.ansible_key.name,
    hcloud_ssh_key.enrico_general_key.name,
    hcloud_ssh_key.enrico_main_key.name
  ]

  firewall_ids = [
    hcloud_firewall.fw4_base.id,
    hcloud_firewall.srv13_fw4_servizi.id,
    hcloud_firewall.fw6_base.id,
    hcloud_firewall.srv13_fw6_adm.id
  ]

  lifecycle {
    ignore_changes = [
      ssh_keys
    ]
  }
}

# resource "hcloud_server" "srv14" {
#   name = "srv14"
#   image = "ubuntu-20.04"
#   server_type = "cx11"
#   location = "nbg1"
#   keep_disk = false
#   delete_protection = false
#   rebuild_protection = false

#   ssh_keys = [ 
#     hcloud_ssh_key.ansible_key.name,
#     hcloud_ssh_key.enrico_general_key.name,
#     hcloud_ssh_key.enrico_main_key.name
#   ]

#    # È importante NON mettere alcun firewall perché la VM all'inizio
#    # ha SSH che ascolta su 22/TCP
#   firewall_ids = [
#   ]

#     lifecycle {
#     ignore_changes = [
#       ssh_keys
#     ]
#   }
# }

###

resource "hcloud_firewall" "fw4_base" {
  name = "fw4_base"

  rule {
    description = "SSH"
    direction = "in"
    protocol = "tcp"
    port = 48840
    source_ips = [
      "0.0.0.0/0"
    ]
  }
  rule {
    description = "ICMP"
    direction = "in"
    protocol = "icmp"
    source_ips = [
      "0.0.0.0/0"
    ]
  }
}

resource "hcloud_firewall" "fw6_base" {
  name = "fw6_base"

  rule {
    description = "SSH"
    direction = "in"
    protocol = "tcp"
    port = 48840
    source_ips = [
      "::/0"
    ]
  }

  rule {
    description = "ICMP"
    direction = "in"
    protocol = "icmp"
    source_ips = [
      "::/0"
    ]
  }
}

resource "hcloud_firewall" "srv11_fw4_servizi" {
  name = "srv11_fw4_servizi"
  rule {
    description = "SMTP"
    direction = "in"
    protocol = "tcp"
    port = 25
    source_ips = [
      "0.0.0.0/0"
    ]
  }

  rule {
    description = "SMTPS"
    direction = "in"
    protocol = "tcp"
    port = 465
    source_ips = [
      "0.0.0.0/0"
    ]
  }

  rule {
    description = "SMTP MSA"
    direction = "in"
    protocol = "tcp"
    port = 587
    source_ips = [
      "0.0.0.0/0"
    ]
  }

  rule {
    description = "POP3"
    direction = "in"
    protocol = "tcp"
    port = 110
    source_ips = [
      "0.0.0.0/0"
    ]
  }

  rule {
    description = "POP3S"
    direction = "in"
    protocol = "tcp"
    port = 995
    source_ips = [
      "0.0.0.0/0"
    ]
  }

  rule {
    description = "IMAPS"
    direction = "in"
    protocol = "tcp"
    port = 993
    source_ips = [
      "0.0.0.0/0"
    ]
  }

  rule {
    description = "DNS"
    direction = "in"
    protocol = "tcp"
    port = 53
    source_ips = [
      "0.0.0.0/0"
    ]
  }

  rule {
    description = "DNS"
    direction = "in"
    protocol = "udp"
    port = 53
    source_ips = [
      "0.0.0.0/0"
    ]
  }

  rule {
    description = "HTTP"
    direction = "in"
    protocol = "tcp"
    port = 80
    source_ips = [
      "0.0.0.0/0"
    ]
  }

  rule {
    description = "HTTPS"
    direction = "in"
    protocol = "tcp"
    port = 443
    source_ips = [
      "0.0.0.0/0"
    ]
  }

  rule {
    description = "nonnocamX"
    direction = "in"
    protocol = "tcp"
    port = "48088-48554"
    source_ips = [
      "0.0.0.0/0"
    ]
  }
}

resource "hcloud_firewall" "srv11_fw6_servizi" {
  name = "srv11_fw6_servizi"

  rule {
    description = "SMTP"
    direction = "in"
    protocol = "tcp"
    port = 25
    source_ips = [
      "::/0"
    ]
  }

  rule {
    description = "SMTP"
    direction = "in"
    protocol = "tcp"
    port = 465
    source_ips = [
      "::/0"
    ]
  }

  rule {
    description = "SMTP MSA"
    direction = "in"
    protocol = "tcp"
    port = 587
    source_ips = [
      "::/0"
    ]
  }

  rule {
    description = "POP3"
    direction = "in"
    protocol = "tcp"
    port = 110
    source_ips = [
      "::/0"
    ]
  }

  rule {
    description = "POP3S"
    direction = "in"
    protocol = "tcp"
    port = 995
    source_ips = [
      "::/0"
    ]
  }

  rule {
    description = "IMAPS"
    direction = "in"
    protocol = "tcp"
    port = 993
    source_ips = [
      "::/0"
    ]
  }

  rule {
    description = "DNS"
    direction = "in"
    protocol = "tcp"
    port = 53
    source_ips = [
      "::/0"
    ]
  }

  rule {
    description = "DNS"
    direction = "in"
    protocol = "udp"
    port = 53
    source_ips = [
      "::/0"
    ]
  }

  rule {
    description = "HTTP"
    direction = "in"
    protocol = "tcp"
    port = 80
    source_ips = [
      "::/0"
    ]
  }

  rule {
    description = "HTTPS"
    direction = "in"
    protocol = "tcp"
    port = 443
    source_ips = [
      "::/0"
    ]
  }
}

resource "hcloud_firewall" "srv11_fw6_adm" {
  name = "srv11_fw6_adm"
  rule {
    description = "PostgreSQL"
    direction = "in"
    protocol = "tcp"
    port = 5432
    source_ips = [
      "::/0"
    ]
  }

  rule {
    description = "NTP"
    direction = "in"
    protocol = "udp"
    port = 123
    source_ips = [
      "::/0"
    ]
  }

  rule {
    description = "gw2.srv11 - gw2.rei"
    direction = "in"
    protocol = "gre"
    source_ips = [
      "2001:b07:6478:c6f6:216:3eff:feeb:1c5/128"
    ]
  }
}

resource "hcloud_firewall" "srv13_fw4_servizi" {
  name = "srv13_fw4_servizi"
  rule {
    description = "DNS"
    direction = "in"
    protocol = "tcp"
    port = 25
    source_ips = [
      "0.0.0.0/0"
    ]
  }

  rule {
    description = "SMTP"
    direction = "in"
    protocol = "tcp"
    port = 465
    source_ips = [
      "0.0.0.0/0"
    ]
  }

  rule {
    description = "DNS"
    direction = "in"
    protocol = "tcp"
    port = 53
    source_ips = [
      "0.0.0.0/0"
    ]
  }

  rule {
    description = "DNS"
    direction = "in"
    protocol = "udp"
    port = 53
    source_ips = [
      "0.0.0.0/0"
    ]
  }
}

resource "hcloud_firewall" "srv13_fw6_adm" {
  name = "srv13_fw6_adm"
  
  rule {
    description = "srv13 - gw3.shu"
    direction = "in"
    protocol = "gre"
    source_ips = [
      "2a02:aa13:a100:1b00:216:3eff:feeb:3c7/128"
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

resource "hcloud_floating_ip" "ip4_2o" {
  description   = "secondario IPv4"
  name = "ip4_2o"
  type = "ipv4"
  home_location = "nbg1"  
  delete_protection = true
  server_id = hcloud_server.srv13.id
}

###

resource "hcloud_rdns" "ip4_mail_megane_it" {
  floating_ip_id = hcloud_floating_ip.ip4_1o.id
  ip_address = hcloud_floating_ip.ip4_1o.ip_address
  dns_ptr = "mail.megane.it"
}

resource "hcloud_rdns" "ip6_srv11_megane_it" {
  floating_ip_id = hcloud_floating_ip.net6_1o.id
  ip_address = join ( "",[ hcloud_floating_ip.net6_1o.ip_address,"2" ] )
  dns_ptr = "srv11.megane.it"
}

resource "hcloud_rdns" "ip6_mail_megane_it" {
  floating_ip_id = hcloud_floating_ip.net6_1o.id
  ip_address = join ( "",[ hcloud_floating_ip.net6_1o.ip_address,"19" ] )
  dns_ptr = "mail.megane.it"
}

resource "hcloud_rdns" "ip6_dns_megane_it" {
  floating_ip_id = hcloud_floating_ip.net6_1o.id
  ip_address = join ( "",[ hcloud_floating_ip.net6_1o.ip_address,"35" ] )
  dns_ptr = "dns.megane.it"
}

resource "hcloud_rdns" "ip6_http_www_megane_it" {
  floating_ip_id = hcloud_floating_ip.net6_1o.id
  ip_address = join ( "",[ hcloud_floating_ip.net6_1o.ip_address,"50" ] )
  dns_ptr = "www.megane.it"
}

resource "hcloud_rdns" "ip6_https_www_megane_it" {
  floating_ip_id = hcloud_floating_ip.net6_1o.id
  ip_address = join ( "",[ hcloud_floating_ip.net6_1o.ip_address,"1bb" ] )
  dns_ptr = "www.megane.it"
}

resource "hcloud_rdns" "ip6_deadbeef_megane_it" {
  floating_ip_id = hcloud_floating_ip.net6_1o.id
  ip_address = join ( "",[ hcloud_floating_ip.net6_1o.ip_address,"dead:beef" ] )
  dns_ptr = "deadbeef.megane.it"
}

resource "hcloud_rdns" "ip6_mta_srv11_megane_it" {
  floating_ip_id = hcloud_floating_ip.net6_1o.id
  ip_address = join ( "",[ replace ( hcloud_floating_ip.net6_1o.ip_address,"::",":" ),"216:3eff:feeb:65a" ] )
  dns_ptr = "mta.srv11.megane.it"
}

resource "hcloud_rdns" "ip4_mail2_megane_it" {
  floating_ip_id = hcloud_floating_ip.ip4_2o.id
  ip_address = hcloud_floating_ip.ip4_2o.ip_address
  dns_ptr = "mail2.megane.it"
}
