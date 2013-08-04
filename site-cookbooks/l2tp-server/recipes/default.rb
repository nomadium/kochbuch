#
# Cookbook Name:: l2tp-server
# Recipe:: default
#
# Copyright 2013, Miguel Landaeta
#
# All rights reserved - Do Not Redistribute
#
%w{openswan ppp xl2tpd}.each do |pkg|
  package pkg do
    action :install
  end
end

template "/etc/ipsec.conf" do
  action :create
  source "ipsec.conf.erb"
  mode 0644
  owner "root"
  group "root"
end

template "/etc/ipsec.d/l2tp-psk.conf" do
  action :create
  source "l2tp-psk.conf.erb"
  mode 0644
  owner "root"
  group "root"
end

template "/etc/xl2tpd/xl2tpd.conf" do
  action :create
  source "xl2tpd.conf.erb"
  mode 0644
  owner "root"
  group "root"
end

template "/etc/ppp/options.xl2tpd" do
  action :create
  source "options.xl2tpd.erb"
  mode 0644
  owner "root"
  group "root"
end

template "/etc/ppp/chap-secrets" do
  action :create
  source "chap-secrets.erb"
  mode 0644
  owner "root"
  group "root"
end

template "/etc/ipsec.secrets" do
  action :create
  source "ipsec-secrets.erb"
  mode 0644
  owner "root"
  group "root"
end

%w{pppd-dns xl2tpd ipsec}.each do |svc|
  service svc do
    action :restart
  end
end

execute "enable ip forwarding" do
  action :run
  user "root"
  group "root"
  command "sysctl -w net.ipv4.ip_forward=1"
end

execute "masquerade all traffic coming from clients" do
  action :run
  user "root"
  group "root"
  command "iptables -t nat -A POSTROUTING -s 10.64.128.0/24 -o eth0 -j MASQUERADE"
end

# read:
# https://help.ubuntu.com/community/L2TPServer
# http://pleasefeedthegeek.wordpress.com/2012/04/21/l2tp-ubuntu-server-setup-for-ios-clients/
# http://vitobotta.com/l2tp-ipsec-vpn-server/
