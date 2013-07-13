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

template "/etc/ferm/ferm.conf" do
  action :create
  owner "root"
  group "adm"
  mode 0644
  source "ferm.regine.conf.erb"
  notifies :restart, "service[ferm]"
end
