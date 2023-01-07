resource "hcloud_firewall" "srv11_fw4_base" {
  name = "srv11_fw4_base"

  # IN
  rule {
    description = "srv11 systemd-networkd - DHCP"
    direction   = "in"
    protocol    = "udp"
    port        = "67"
    source_ips = [
      local.ipv4_everywhere
    ]
  }
  rule {
    description = "srv11 - SSH"
    direction   = "in"
    protocol    = "tcp"
    port        = local.ssh_port
    source_ips = [
      local.ipv4_everywhere
    ]
  }
  rule {
    description = "tempo.srv11 - NTP"
    direction   = "in"
    protocol    = "udp"
    port        = 123
    source_ips = [
      local.ipv4_everywhere
    ]
  }
  rule {
    description = "srv11 - ICMP"
    direction   = "in"
    protocol    = "icmp"
    source_ips = [
      local.ipv4_everywhere
    ]
  }

  # OUT
  rule {
    description = "srv11 systemd-networkd - DHCP"
    direction   = "out"
    protocol    = "udp"
    port        = "68"
    destination_ips = [
      local.ipv4_everywhere
    ]
  }
  rule {
    description = "srv11"
    direction   = "out"
    protocol    = "tcp"
    port        = local.ssh_port
    destination_ips = [
      local.ipv4_everywhere
    ]
  }
  rule {
    description = "tempo.srv11 - NTP"
    direction   = "out"
    protocol    = "udp"
    port        = 123
    destination_ips = [
      local.ipv4_everywhere
    ]
  }
  rule {
    description = "srv11 - ICMP"
    direction   = "out"
    protocol    = "icmp"
    destination_ips = [
      local.ipv4_everywhere
    ]
  }

  rule {
    description = "dns.srv11 - DNS"
    direction   = "out"
    protocol    = "tcp"
    port        = 53
    destination_ips = [
      local.ipv4_everywhere
    ]
  }

  rule {
    description = "dns.srv11 - DNS"
    direction   = "out"
    protocol    = "udp"
    port        = 53
    destination_ips = [
      local.ipv4_everywhere
    ]
  }

  rule {
    description = "proxy.srv11 - HTTP"
    direction   = "out"
    protocol    = "tcp"
    port        = 80
    destination_ips = [
      local.ipv4_everywhere
    ]
  }
  rule {
    description = "proxy.srv11 - HTTPS"
    direction   = "out"
    protocol    = "tcp"
    port        = 443
    destination_ips = [
      local.ipv4_everywhere
    ]
  }
  rule {
    description = "proxy.srv11 - 8080"
    direction   = "out"
    protocol    = "tcp"
    port        = 8080
    destination_ips = [
      local.ipv4_everywhere
    ]
  }
  rule {
    description = "proxy.srv11 - 8443"
    direction   = "out"
    protocol    = "tcp"
    port        = 8443
    destination_ips = [
      local.ipv4_everywhere
    ]
  }
} # "hcloud_firewall" "srv11_fw4_base"

resource "hcloud_firewall" "srv11_fw6_base" {
  name = "srv11_fw6_base"

  # IN
  rule {
    description = "srv11 systemd-networkd - SSH"
    direction   = "in"
    protocol    = "tcp"
    port        = local.ssh_port
    source_ips = [
      local.ipv6_everywhere
    ]
  }
  rule {
    description = "srv11 - ICMP"
    direction   = "in"
    protocol    = "icmp"
    source_ips = [
      local.ipv6_everywhere
    ]
  }

  # OUT
  rule {
    description = "srv11 - SSH"
    direction   = "out"
    protocol    = "tcp"
    port        = local.ssh_port
    destination_ips = [
      local.ipv6_everywhere
    ]
  }

  rule {
    description = "srv11 - ICMP"
    direction   = "out"
    protocol    = "icmp"
    destination_ips = [
      local.ipv6_everywhere
    ]
  }

  rule {
    description = "dns.srv11 - DNS"
    direction   = "out"
    protocol    = "tcp"
    port        = 53
    destination_ips = [
      local.ipv6_everywhere
    ]
  }

  rule {
    description = "dns.srv11 - DNS"
    direction   = "out"
    protocol    = "udp"
    port        = 53
    destination_ips = [
      local.ipv6_everywhere
    ]
  }

  rule {
    description = "proxy.srv11 - HTTP"
    direction   = "out"
    protocol    = "tcp"
    port        = 80
    destination_ips = [
      local.ipv6_everywhere
    ]
  }
  rule {
    description = "proxy.srv11 - HTTPS"
    direction   = "out"
    protocol    = "tcp"
    port        = 443
    destination_ips = [
      local.ipv6_everywhere
    ]
  }
  rule {
    description = "proxy.srv11 - 8080"
    direction   = "out"
    protocol    = "tcp"
    port        = 8080
    destination_ips = [
      local.ipv6_everywhere
    ]
  }
  rule {
    description = "proxy.srv11 - 8443"
    direction   = "out"
    protocol    = "tcp"
    port        = 8443
    destination_ips = [
      local.ipv6_everywhere
    ]
  }
} # "hcloud_firewall" "srv11_fw6_base"

resource "hcloud_firewall" "srv11_fw4_servizi" {
  name = "srv11_fw4_servizi"

  # IN
  rule {
    description = "mx.srv11 - SMTP"
    direction   = "in"
    protocol    = "tcp"
    port        = 25
    source_ips = [
      local.ipv4_everywhere
    ]
  }
  rule {
    description = "mx.srv11 - SMTPS"
    direction   = "in"
    protocol    = "tcp"
    port        = 465
    source_ips = [
      local.ipv4_everywhere
    ]
  }

  rule {
    description = "msa.srv11 - SMTP MSA"
    direction   = "in"
    protocol    = "tcp"
    port        = 587
    source_ips = [
      local.ipv4_everywhere
    ]
  }

  rule {
    description = "mda.srv11 - POP3"
    direction   = "in"
    protocol    = "tcp"
    port        = 110
    source_ips = [
      local.ipv4_everywhere
    ]
  }
  rule {
    description = "mda.srv11 - POP3S"
    direction   = "in"
    protocol    = "tcp"
    port        = 995
    source_ips = [
      local.ipv4_everywhere
    ]
  }

  rule {
    description = "dns-ext.srv11 - DNS"
    direction   = "in"
    protocol    = "tcp"
    port        = 53
    source_ips = [
      local.ipv4_everywhere
    ]
  }
  rule {
    description = "dns-ext.srv11 - DNS"
    direction   = "in"
    protocol    = "udp"
    port        = 53
    source_ips = [
      local.ipv4_everywhere
    ]
  }

  rule {
    description = "www.srv11 - HTTP"
    direction   = "in"
    protocol    = "tcp"
    port        = 80
    source_ips = [
      local.ipv4_everywhere
    ]
  }
  rule {
    description = "wwww.srv11 - HTTPS"
    direction   = "in"
    protocol    = "tcp"
    port        = 443
    source_ips = [
      local.ipv4_everywhere
    ]
  }

  # OUT
  rule {
    description = "mta.srv11 - SMTP"
    direction   = "out"
    protocol    = "tcp"
    port        = 25
    destination_ips = [
      local.ipv4_everywhere
    ]
  }
  rule {
    description = "mta.srv11 - SMTPS"
    direction   = "out"
    protocol    = "tcp"
    port        = 465
    destination_ips = [
      local.ipv4_everywhere
    ]
  }

  rule {
    description = "no-spam.srv11 - Razor"
    direction   = "out"
    protocol    = "tcp"
    port        = 2703
    destination_ips = [
      local.ipv4_everywhere
    ]
  }
  rule {
    description = "no-spam.srv11 - Pyzor"
    direction   = "out"
    protocol    = "tcp"
    port        = 24441
    destination_ips = [
      local.ipv4_everywhere
    ]
  }
  rule {
    description = "no-spam.srv11 - Pyzor"
    direction   = "out"
    protocol    = "udp"
    port        = 24441
    destination_ips = [
      local.ipv4_everywhere
    ]
  }
} # "hcloud_firewall" "srv11_fw4_servizi"

resource "hcloud_firewall" "srv11_fw6_servizi" {
  name = "srv11_fw6_servizi"

  # IN
  rule {
    description = "mx.srv11 - SMTP"
    direction   = "in"
    protocol    = "tcp"
    port        = 25
    source_ips = [
      local.ipv6_everywhere
    ]
  }
  rule {
    description = "mx.srv11 - SMTP"
    direction   = "in"
    protocol    = "tcp"
    port        = 465
    source_ips = [
      local.ipv6_everywhere
    ]
  }

  rule {
    description = "msa.srv11 - SMTP MSA"
    direction   = "in"
    protocol    = "tcp"
    port        = 587
    source_ips = [
      local.ipv6_everywhere
    ]
  }

  rule {
    description = "mda.srv11 - POP3"
    direction   = "in"
    protocol    = "tcp"
    port        = 110
    source_ips = [
      local.ipv6_everywhere
    ]
  }
  rule {
    description = "mda.srv11 - POP3S"
    direction   = "in"
    protocol    = "tcp"
    port        = 995
    source_ips = [
      local.ipv6_everywhere
    ]
  }

  rule {
    description = "dns-ext.srv11 - DNS"
    direction   = "in"
    protocol    = "tcp"
    port        = 53
    source_ips = [
      local.ipv6_everywhere
    ]
  }
  rule {
    description = "dns-ext.srv11 - DNS"
    direction   = "in"
    protocol    = "udp"
    port        = 53
    source_ips = [
      local.ipv6_everywhere
    ]
  }

  rule {
    description = "www.srv11 - HTTP"
    direction   = "in"
    protocol    = "tcp"
    port        = 80
    source_ips = [
      local.ipv6_everywhere
    ]
  }
  rule {
    description = "www.srv11 - HTTPS"
    direction   = "in"
    protocol    = "tcp"
    port        = 443
    source_ips = [
      local.ipv6_everywhere
    ]
  }

  # OUT
  rule {
    description = "mta.srv11 - SMTP"
    direction   = "out"
    protocol    = "tcp"
    port        = 25
    destination_ips = [
      local.ipv6_everywhere
    ]
  }
  rule {
    description = "mta.srv11 - SMTP"
    direction   = "out"
    protocol    = "tcp"
    port        = 465
    destination_ips = [
      local.ipv6_everywhere
    ]
  }
} # "hcloud_firewall" "srv11_fw6_servizi"

resource "hcloud_firewall" "srv11_fw6_adm" {
  name = "srv11_fw6_adm"

  # IN
  rule {
    description = "db.srv11 - PostgreSQL"
    direction   = "in"
    protocol    = "tcp"
    port        = 5432
    source_ips = [
      local.ipv6_everywhere
    ]
  }

  rule {
    description = "tempo.srv11 - NTP"
    direction   = "in"
    protocol    = "udp"
    port        = 123
    source_ips = [
      local.ipv6_everywhere
    ]
  }

  rule {
    description = "gw2.rei - gw2.srv11"
    direction   = "in"
    protocol    = "gre"
    source_ips = [
      local.gw2_rei_ip6
    ]
  }

  # OUT
  rule {
    description = "tempo.srv11 - NTP"
    direction   = "out"
    protocol    = "udp"
    port        = 123
    destination_ips = [
      local.ipv6_everywhere
    ]
  }
  rule {
    description = "srv11 - StorageBox"
    direction   = "out"
    protocol    = "tcp"
    port        = 23
    destination_ips = [
      local.ipv6_everywhere
    ]
  }
  rule {
    description = "gw2.srv11 - gw2.rei"
    direction   = "out"
    protocol    = "gre"
    destination_ips = [
      local.gw2_rei_ip6
    ]
  }
} # "hcloud_firewall" "srv11_fw6_adm"
