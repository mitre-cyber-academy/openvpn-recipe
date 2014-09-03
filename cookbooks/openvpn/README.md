# OpenVPN Setup Recipe

## Initial Setup

You will need to initialize the submodule included in this project in order for it to work correctly! Otherwise your firewall rules will not be configured.

## Commands

This script adds the following commands to your path:

* openvpn-adduser
* openvpn-destroyuser

Both of these need to be run with administrative privileges.

Also you need port 1194 open for TCP traffic on the firewall.

To Do

* Update to use Berkshelf.