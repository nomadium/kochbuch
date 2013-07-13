#
# Cookbook Name:: nullidentd
# Recipe:: default
#
# Copyright 2013, Miguel Landaeta
#
# All rights reserved - Do Not Redistribute
#
%w(nullidentd openbsd-inetd).each do |pkg|
  package pkg do
    action :install
  end
end

service "openbsd-inetd" do
  action :start
end

template "/etc/inetd.conf" do
  action :create
  owner "root"
  group "root"
  mode 0644
  source "inetd.nullidentd.conf.erb"
  notifies :restart, "service[openbsd-inetd]"
end

