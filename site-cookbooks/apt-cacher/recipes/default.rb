#
# Cookbook Name:: apt-cacher
# Recipe:: default
#
# Copyright 2013, Miguel Landaeta
#
# All rights reserved - Do Not Redistribute
#
package "apt-cacher" do
  action :install
end

service "apt-cacher" do
  action :nothing
  supports :status => true, :start => true, :stop => true, :restart => true
end

template "/etc/apt-cacher/conf.d/distinct_namespaces" do
  action :create_if_missing
  source "distinct_namespaces.erb"
  mode 0644
  owner "root"
  group "root"
  notifies :restart, "service[apt-cacher]", :immediately
end
