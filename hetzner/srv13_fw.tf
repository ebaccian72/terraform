resource "hcloud_firewall" "srv13_fw4_base" {
  name = "srv13_fw4_base"

  # IN
  rule {
    description = "DHCP"
    direction   = "in"
    protocol    = "udp"
    port        = "67"
    source_ips = [
      local.ipv4_everywhere
    ]
  }

  rule {
    description = "SSH"
    direction   = "in"
    protocol    = "tcp"
    port        = local.ssh_port
    source_ips = [
      local.ipv4_everywhere
    ]
  }

  rule {
    description = "ICMP"
    direction   = "in"
    protocol    = "icmp"
    source_ips = [
      local.ipv4_everywhere
    ]
  }

  # OUT
  rule {
    description = "DHCP"
    direction   = "out"
    protocol    = "udp"
    port        = "68"
    destination_ips = [
      local.ipv4_everywhere
    ]
  }

  rule {
    description = "ICMP"
    direction   = "out"
    protocol    = "icmp"
    destination_ips = [
      local.ipv4_everywhere
    ]
  }

  rule {
    description = "SSH"
    direction   = "out"
    protocol    = "tcp"
    port        = local.ssh_port
    destination_ips = [
      local.ipv4_everywhere
    ]
  }

  rule {
    description = "NTP"
    direction   = "out"
    protocol    = "udp"
    port        = 123
    destination_ips = [
      local.ipv4_everywhere
    ]
  }

  rule {
    description = "DNS"
    direction   = "out"
    protocol    = "tcp"
    port        = 53
    destination_ips = [
      local.ipv4_everywhere
    ]
  }
  rule {
    description = "DNS"
    direction   = "out"
    protocol    = "udp"
    port        = 53
    destination_ips = [
      local.ipv4_everywhere
    ]
  }

  rule {
    description = "HTTP"
    direction   = "out"
    protocol    = "tcp"
    port        = 80
    destination_ips = [
      local.ipv4_everywhere
    ]
  }
  rule {
    description = "HTTPS"
    direction   = "out"
    protocol    = "tcp"
    port        = 443
    destination_ips = [
      local.ipv4_everywhere
    ]
  }
} # "hcloud_firewall" "srv13_fw4_base"

resource "hcloud_firewall" "srv13_fw6_base" {
  name = "srv13_fw6_base"

  # IN
  rule {
    description = "SSH"
    direction   = "in"
    protocol    = "tcp"
    port        = local.ssh_port
    source_ips = [
      local.ipv6_everywhere
    ]
  }
  rule {
    description = "ICMP"
    direction   = "in"
    protocol    = "icmp"
    source_ips = [
      local.ipv6_everywhere
    ]
  }

  # OUT
  rule {
    description = "ICMP"
    direction   = "out"
    protocol    = "icmp"
    destination_ips = [
      local.ipv6_everywhere
    ]
  }

  rule {
    description = "SSH"
    direction   = "out"
    protocol    = "tcp"
    port        = local.ssh_port
    destination_ips = [
      local.ipv6_everywhere
    ]
  }

  rule {
    description = "NTP"
    direction   = "out"
    protocol    = "udp"
    port        = 123
    destination_ips = [
      local.ipv6_everywhere
    ]
  }

  rule {
    description = "DNS"
    direction   = "out"
    protocol    = "tcp"
    port        = 53
    destination_ips = [
      local.ipv6_everywhere
    ]
  }
  rule {
    description = "DNS"
    direction   = "out"
    protocol    = "udp"
    port        = 53
    destination_ips = [
      local.ipv6_everywhere
    ]
  }

  rule {
    description = "HTTP"
    direction   = "out"
    protocol    = "tcp"
    port        = 80
    destination_ips = [
      local.ipv6_everywhere
    ]
  }
  rule {
    description = "HTTPS"
    direction   = "out"
    protocol    = "tcp"
    port        = 443
    destination_ips = [
      local.ipv6_everywhere
    ]
  }
} # "hcloud_firewall" "srv13_fw6_base"

resource "hcloud_firewall" "srv13_fw4_servizi" {
  name = "srv13_fw4_servizi"

  # IN
  rule {
    description = "SMTP"
    direction   = "in"
    protocol    = "tcp"
    port        = 25
    source_ips = [
      local.ipv4_everywhere
    ]
  }

  rule {
    description = "SMTP"
    direction   = "in"
    protocol    = "tcp"
    port        = 465
    source_ips = [
      local.ipv4_everywhere
    ]
  }

  rule {
    description = "DNS"
    direction   = "in"
    protocol    = "tcp"
    port        = 53
    source_ips = [
      local.ipv4_everywhere
    ]
  }
  rule {
    description = "DNS"
    direction   = "in"
    protocol    = "udp"
    port        = 53
    source_ips = [
      local.ipv4_everywhere
    ]
  }

  rule {
    description = "WireGuard"
    direction   = "in"
    protocol    = "udp"
    port        = 51820
    source_ips = [
      local.ipv4_everywhere
    ]
  }

  # OUT
  rule {
    description = "SMTP"
    direction   = "out"
    protocol    = "tcp"
    port        = 25
    destination_ips = [
      local.ipv4_everywhere
    ]
  }

  rule {
    description = "SMTP"
    direction   = "out"
    protocol    = "tcp"
    port        = 465
    destination_ips = [
      local.ipv4_everywhere
    ]
  }

  rule {
    description = "DNS"
    direction   = "out"
    protocol    = "tcp"
    port        = 53
    destination_ips = [
      local.ipv4_everywhere
    ]
  }
  rule {
    description = "DNS"
    direction   = "out"
    protocol    = "udp"
    port        = 53
    destination_ips = [
      local.ipv4_everywhere
    ]
  }
} # "hcloud_firewall" "srv13_fw4_servizi"

resource "hcloud_firewall" "srv13_fw6_adm" {
  name = "srv13_fw6_adm"

  # IN
  rule {
    description = "gw3.shu - srv13"
    direction   = "in"
    protocol    = "gre"
    source_ips = [
      local.gw3_shu_ip6
    ]
  }

  # OUT
  rule {
    description = "StorageBox"
    direction   = "out"
    protocol    = "tcp"
    port        = 23
    destination_ips = [
      local.ipv6_everywhere
    ]
  }

  rule {
    description = "srv13 - gw3.shu"
    direction   = "out"
    protocol    = "gre"
    destination_ips = [
      local.gw3_shu_ip6
    ]
  }
} # "hcloud_firewall" "srv13_fw6_adm"
