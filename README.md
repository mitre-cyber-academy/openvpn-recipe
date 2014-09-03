# OpenVPN Setup Recipe

This chef recipe creates a server allowing users to VPN into the network it is connected to and waits on the scoreboard to pass it users to add to the box.

## Commands

This script adds the following commands to your path:

* openvpn-adduser
* openvpn-destroyuser

Both of these need to be run with administrative privileges.

Also you need port 1194 open for TCP traffic on the firewall.

To Do

* Update to use Berkshelf.
