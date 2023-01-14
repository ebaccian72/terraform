# resource "hcloud_server" "srv14" {
#   name = "srv14"
#   image = "ubuntu-22.04"
#   server_type = "cx11"
#   location = "hel1"
#   keep_disk = true
#   delete_protection = false
#   rebuild_protection = false
#   allow_deprecated_images = false

#   ssh_keys = [
#     hcloud_ssh_key.ansible_key.name,
#     hcloud_ssh_key.enrico_general_key.name,
#     hcloud_ssh_key.enrico_main_key.name,
#     hcloud_ssh_key.enrico_backup_key.name
#   ]
# }
