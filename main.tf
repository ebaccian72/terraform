terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      version = "1.25.2"
    }

    vault = {
      source = "hashicorp/vault"
      version = "2.19.0"
    }
  }
}

###

variable "vault_token" {}

#
# N.B. Il token deve avere la seguente capability:
#   path "auth/token/create" {
#     capabilities = [ "update" ]
#   }
#
provider "vault" {
  address = "https://vault.megane.eb:8443"
  token = var.vault_token
}

###

data "vault_generic_secret" "hetzner_prova" {
  path = "kv/hetzner/prova"
}

provider "hcloud" {
  token = data.vault_generic_secret.hetzner_prova.data [ "radice" ]
}

###

data "vault_generic_secret" "enrico_at_jigen_megane_eb" {
  path = "kv/ssh-client/enrico@jigen.megane.eb"
}

resource "hcloud_ssh_key" "enrico_2018" {
  name = "Enrico Baccianini, 2018"
  public_key = data.vault_generic_secret.enrico_at_jigen_megane_eb.data [ "pub" ]
}

###

resource "hcloud_server" "srv11" {
  name = "srv11"
  image = "ubuntu-20.04"
  server_type = "cx31"
  location = "nbg1"
  firewall_ids = [ 
    hcloud_firewall.fw4_base.id,
    hcloud_firewall.srv11_fw4_servizi.id,
    hcloud_firewall.fw6_base.id,
    hcloud_firewall.srv11_fw6_servizi.id
  ]
}

resource "hcloud_server" "srv13" {
  name = "srv13"
  image = "ubuntu-20.04"
  server_type = "cx11"
  location = "hel1"
  firewall_ids = [
    hcloud_firewall.fw4_base.id,
    hcloud_firewall.fw6_base.id
  ]
}

###

resource "hcloud_firewall" "fw4_base" {
  name = "fw4_base"

  rule {
    direction = "in"
    protocol = "tcp"
    port = 48840
    source_ips = [
      "0.0.0.0/0"
    ]
  }
  rule {
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
    direction = "in"
    protocol = "tcp"
    port = 48840
    source_ips = [
      "::/0"
    ]
  }
  rule {
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
    direction = "in"
    protocol = "tcp"
    port = 25
    source_ips = [
      "0.0.0.0/0"
    ]
  }
  rule {
    direction = "in"
    protocol = "tcp"
    port = 465
    source_ips = [
      "0.0.0.0/0"
    ]
  }
  rule {
    direction = "in"
    protocol = "tcp"
    port = 587
    source_ips = [
      "0.0.0.0/0"
    ]
  }
  rule {
    direction = "in"
    protocol = "tcp"
    port = 110
    source_ips = [
      "0.0.0.0/0"
    ]
  }
    rule {
    direction = "in"
    protocol = "tcp"
    port = 995
    source_ips = [
      "0.0.0.0/0"
    ]
  }
  rule {
    direction = "in"
    protocol = "tcp"
    port = 53
    source_ips = [
      "0.0.0.0/0"
    ]
  }
    rule {
    direction = "in"
    protocol = "udp"
    port = 53
    source_ips = [
      "0.0.0.0/0"
    ]
  }
  rule {
    direction = "in"
    protocol = "tcp"
    port = 80
    source_ips = [
      "0.0.0.0/0"
    ]
  }
  rule {
    direction = "in"
    protocol = "tcp"
    port = 443
    source_ips = [
      "0.0.0.0/0"
    ]
  }
  rule {
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
    direction = "in"
    protocol = "tcp"
    port = 25
    source_ips = [
      "::0/0"
    ]
  }
  rule {
    direction = "in"
    protocol = "tcp"
    port = 465
    source_ips = [
      "::0/0"
    ]
  }
  rule {
    direction = "in"
    protocol = "tcp"
    port = 587
    source_ips = [
      "::0/0"
    ]
  }
  rule {
    direction = "in"
    protocol = "tcp"
    port = 110
    source_ips = [
      "::0/0"
    ]
  }
    rule {
    direction = "in"
    protocol = "tcp"
    port = 995
    source_ips = [
      "::0/0"
    ]
  }
  rule {
    direction = "in"
    protocol = "tcp"
    port = 53
    source_ips = [
      "::0/0"
    ]
  }
    rule {
    direction = "in"
    protocol = "udp"
    port = 53
    source_ips = [
      "::0/0"
    ]
  }
  rule {
    direction = "in"
    protocol = "tcp"
    port = 80
    source_ips = [
      "::0/0"
    ]
  }
    rule {
    direction = "in"
    protocol = "tcp"
    port = 443
    source_ips = [
      "::0/0"
    ]
  }
  rule {
    direction = "in"
    protocol = "udp"
    port = 123
    source_ips = [
      "::0/0"
    ]
  }
}

###

resource "hcloud_volume" "volume_1" {
  name = "volume_1"
  size = 96
  server_id = hcloud_server.srv11.id
}

resource "hcloud_volume" "volume_2" {
  name = "volume_2"
  size = 96
  server_id = hcloud_server.srv11.id
}

###

resource "hcloud_floating_ip" "ip4_1o" {
  name = "1o_ip4"
  type = "ipv4"
  home_location = "nbg1"
}

resource "hcloud_floating_ip" "net6_1o" {
  name = "1o_net6"
  type = "ipv6"
  home_location = "nbg1"
}

resource "hcloud_floating_ip" "ip4_2o" {
  name = "2o_ip4"
  type = "ipv4"
  home_location = "hel1"
}

resource "hcloud_floating_ip_assignment" "ip4_1o_set" {
  floating_ip_id = hcloud_floating_ip.ip4_1o.id
  server_id = hcloud_server.srv11.id
}

resource "hcloud_floating_ip_assignment" "net6_1o_set" {
  floating_ip_id = hcloud_floating_ip.net6_1o.id
  server_id = hcloud_server.srv11.id
}

resource "hcloud_floating_ip_assignment" "ip4_2o_set" {
  floating_ip_id = hcloud_floating_ip.ip4_2o.id
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
