package "openvpn" do
  action :install
end
package "easy-rsa" do
  action :install
end
package "zip" do
  action :install
end
package "inotify-tools" do
  action :install
end
package "unison" do
  action :install
end
template "/etc/openvpn/openvpn.conf" do
  source "template-server-config.erb"
  mode 0644
  variables(
    private_subnet: node['openvpn']['private_subnet']
  )
end
bash "setup_openvpn" do
	user "root"
	cwd "/etc/openvpn"
	code <<-EOH
		make-cadir easy-rsa
	EOH
end
# The next 2 lines should be removable at a later date as it fixes a bug in whichopensslcnf
cookbook_file "/etc/openvpn/easy-rsa/whichopensslcnf" do
  source "whichopensslcnf"
  mode 0755
end
cookbook_file "/etc/openvpn/easy-rsa/vars" do
  source "vars"
  mode 0644
end
bash "easy-rsa-setup" do
	user "root"
	cwd "/etc/openvpn/easy-rsa"
	code <<-EOH
		. ./vars
		./clean-all
		./build-dh
		./pkitool --initca
		./pkitool --server vpnserver
	EOH
end
bash "uncomment_ip_forwarding" do
  user "root"
  cwd "/etc"
  code <<-EOH
    sysctl -w net.ipv4.ip_forward=1 # Enables IPV4 forwarding without requiring reboot
  	sed -i 's,#\\(net.ipv4.ip_forward=1\\),\\1,g' /etc/sysctl.conf
  EOH
end
service "openvpn" do
  supports :start => true, :stop => true, :restart => true
  action :start
end
directory "/opt/openvpn_keys" do
  owner "ubuntu"
  group "ubuntu"
  mode 00755
  action :create
end
directory "/opt/openvpn_templates" do
  owner "root"
  group "root"
  mode 00755
  action :create
end
template "/opt/openvpn_templates/template-client-config" do
  source "template-client-config.erb"
  mode 0644
  variables(
    public_ip_or_host: node['openvpn']['public_ip_or_host'],
    public_port: node['openvpn']['public_port'] 
  )
end
cookbook_file "/usr/bin/openvpn-adduser" do
  source "openvpn-adduser"
  mode 0755
end
cookbook_file "/usr/bin/openvpn-destroyuser" do
  source "openvpn-destroyuser"
  mode 0755
end
cookbook_file "/usr/bin/openvpn-watchkeys" do
  source "openvpn-watchkeys"
  mode 0755
end
cookbook_file "/etc/init.d/openvpn-watchkeys" do
  source "watchkeys_init_d"
  mode 0755
end
service "openvpn-watchkeys" do
  supports :start => true, :stop => true, :restart => true
  action [:start, :enable]
end
simple_iptables_rule "system" do
  direction "FORWARD"
  rule [ 
         "-i tun0 -o eth0 -s 172.20.0.0/16 -d 
         #{node['openvpn']['private_subnet']}/#{node['openvpn']['private_subnet_cidr']} 
         -m conntrack --ctstate NEW" 
       ]
  jump "ACCEPT"
end
simple_iptables_rule "system" do
  table "nat"
  direction "POSTROUTING"
  rule [ "-s 172.20.0.0/16 -d #{node['openvpn']['private_subnet']}/#{node['openvpn']['private_subnet_cidr']} -o eth0" ]
  jump "MASQUERADE"
end
