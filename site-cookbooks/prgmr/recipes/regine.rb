#
# Cookbook Name:: prgmr
# Recipe:: default
#
# Copyright 2013, Miguel Landaeta
#
# All rights reserved - Do Not Redistribute
#
passwords = Chef::EncryptedDataBagItem.load("passwords", "os_users")
ssh_keys = Chef::EncryptedDataBagItem.load("ssh_keys", "hosts")
network_settings = Chef::EncryptedDataBagItem.load("network_settings", "prgmr")

user "root" do
  action :modify
#  disabled because Debian squeeze doesn't include ruby-shadow package
#  needed to use this feature
#  password passwords['root@regine']
end

template "/etc/network/interfaces" do
  action :create
  owner "root"
  group "root"
  mode 0644
  variables(:interface  => network_settings['regine_iface'],
            :method     => network_settings['regine_method'],
            :address    => network_settings['regine_address'],
            :netmask    => network_settings['netmask'],
            :gateway    => network_settings['gateway'])
  source "interfaces.erb"
end

file "/etc/hostname" do
  action :create
  owner "root"
  group "root"
  mode 0644
  content "regine.miguel.cc\n"
end

file "/etc/ssh/ssh_host_dsa_key" do
  action :create
  owner "root"
  group "root"
  mode 0600
  content ssh_keys['dsa_regine']
end

file "/etc/ssh/ssh_host_dsa_key.pub" do
  action :create
  owner "root"
  group "root"
  mode 0644
  content ssh_keys['dsa_regine_pub']
end

file "/etc/ssh/ssh_host_rsa_key" do
  action :create
  owner "root"
  group "root"
  mode 0600
  content ssh_keys['rsa_regine']
end

file "/etc/ssh/ssh_host_rsa_key.pub" do
  action :create
  owner "root"
  group "root"
  mode 0644
  content ssh_keys['rsa_regine_pub']
end

service "ssh" do
  action :restart
end
