# OpenVPN Setup Recipe

This chef recipe creates a server allowing users to VPN into the network it is connected to and waits on the scoreboard to pass it users to add to the box.

## Commands

This script adds the following commands to your path:

* openvpn-adduser
* openvpn-destroyuser

Both of these need to be run with administrative privileges.

Also you need port 1194 open for TCP traffic on the firewall.

## What is all this about watch keys?

This cookbook does more than just setup VPN. It also sets up the directory /opt/openvpn_keys and monitors for whenever a new text file is created in this directory. The reason for this is that [there is a rake task in the scoreboard recipe](https://github.com/mitre-cyber-academy/ctf-scoreboard/blob/e0a5e06329183caf6a008eaa07a489c67a9411d6/lib/tasks/scoreboard.rake#L126) that creates a new text file in a directory and then syncs that directory between the two machines. We use inotifywait and monitor for move requests since inotifywait ends up interpreting the rsync from the scoreboard as such.

## Commands to use this recipe

If you want to run this recipe on your server without using a full chef server install, you can use the following commands.

* `curl -L https://www.chef.io/chef/install.sh | sudo bash` # Install chef
* `cd openvpn-recipe` # Enter directory containing this code
* `sudo chef-client -z -j node.json` # Run the chef client in standalone mode using the node.json provided.

## To Do

This recipe is setup to be very specific to the MITRE CTF at this point. In order to make it easier to move between infrastructures, many of the files need to be turned into templates. Some things that need to be made into attributes include

 * Diffie Hellman key size.
 * Root CA Expiration time.
 * IP address range to push to routes.
 * External IP and port for template-server-config.