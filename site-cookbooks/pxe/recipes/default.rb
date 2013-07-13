#
# Cookbook Name:: pxe
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "tftpd-hpa" do
    action :install
end

service "tftpd-hpa" do
    action [ :stop, :disable ]
end

#service "isc-dhcp-server" do
#    action :install
#end
#
#service "isc-dhcp-server" do
#    action [ :stop, :disable ]
#end

package "dnsmasq" do
    action :install
end

service "dnsmasq" do
    action [ :stop, :disable ]
end

template "/etc/dnsmasq.conf" do
    source "dnsmasq.conf.erb"
    mode 0644
    owner "root"
    group "root"
end

#template "/srv/tftp/pxelinux.cfg/default" do
#    source "default.erb"
#    mode 0644
#    owner root
#    group root
#end
#
#template "/srv/tftp/boot.txt" do
#    source "boot.txt.erb"
#    mode 0644
#    owner root
#    group root
#end

remote_file "/srv/tftp/netboot.tar.gz" do
    source "http://http.us.debian.org/debian/dists/wheezy/main/installer-amd64/current/images/netboot/netboot.tar.gz"
    mode 0644
    owner "root"
    group "root"
    not_if do
      File.exists?("/srv/tftp/netboot.tar.gz")
    end
end

bash 'extract_module' do
    user "root"
    cwd "srv/tftp"
    code <<-EOH
      tar xzf /srv/tftp/netboot.tar.gz
      EOH
    not_if do
      Dir.exists?("/srv/tftp/pxelinux.cfg")
    end
end
