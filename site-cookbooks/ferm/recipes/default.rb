#
# Cookbook Name:: ferm
# Recipe:: default
#
# Copyright 2013, Miguel Landaeta
#
# All rights reserved - Do Not Redistribute
#
package "ferm" do
  action :install
end

service "ferm" do
  action :nothing
end

# todo: maybe a data bag item is not needed for this, I could use a DNS query
network_settings = Chef::EncryptedDataBagItem.load("network_settings", "addresses")

template "/etc/ferm/ferm.conf" do
  action :create
  owner "root"
  group "adm"
  mode 0644
  variables(:laptop_address => network_settings['lykke'])
  source "ferm.workstation.conf.erb"
  notifies :restart, "service[ferm]"
end
