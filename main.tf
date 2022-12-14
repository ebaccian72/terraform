terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      version = "1.36.1"
    }

    vault = {
      source = "hashicorp/vault"
      version = "3.11.0"
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

locals {
  ipv4_everywhere = "0.0.0.0/0"
  ipv6_everywhere = "::/0"
  #
  ch_ag_netprefix6 = "2a02:aa13:a100:1b00"
  ch_ag_net6 = join ( "",[local.ch_ag_netprefix6,"::","/64"] )
  #
  it_pd_netprefix6 = "2001:b07:6478:c6f6"
  it_pd_net6 = join ( "",[local.it_pd_netprefix6,"::","/64"] )
  #
  gw2_rei_ip6 = join ( "",[local.it_pd_netprefix6,":","216:3eff:feeb:1c5","/128"] )
  gw3_shu_ip6 = join ( "",[local.ch_ag_netprefix6,":","216:3eff:feeb:3c7","/128"] )
  #
  ssh_port = 48840
}

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
  path = "kv/ssh-client/enrico@toki.megane.eb+ed25519"
}

resource "hcloud_ssh_key" "enrico_general_key" {
  name = "Enrico Baccianini, 2018"
  public_key = data.vault_generic_secret.enrico_general_key_path.data [ "pub" ]
}

data "vault_generic_secret" "enrico_main_key_path" {
  path = "kv/ssh-client/enrico@toki.megane.eb+ed25519-sk"
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
