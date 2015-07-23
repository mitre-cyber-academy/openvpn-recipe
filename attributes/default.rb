default['openvpn']['private_subnet'] = "10.0.1.0" # /24 internal CIDR block which users are allowed to route to.
default['openvpn']['public_ip_or_host'] = "vpn.mitrestemctf.org" # Hostname or IP which clients will access through.
default['openvpn']['public_port'] = "1194" # Ports which clients will access through.