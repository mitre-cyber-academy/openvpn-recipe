# OpenVPN Setup Recipe

This chef recipe creates a server allowing users to VPN into the network it is connected to and waits on the scoreboard to pass it users to add to the box.

## Commands

This script adds the following commands to your path:

* openvpn-adduser
* openvpn-destroyuser

Both of these need to be run with administrative privileges.

Also you need port 1194 open for TCP traffic on the firewall.

## Using this Recipe

The easiest way to use this recipe is by cloning this repository to the machine on which you wish to install openvpn on and then running `sudo chef-client -z -j node.json`.
