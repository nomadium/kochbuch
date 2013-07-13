#
# Cookbook Name:: tunnel
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
user "tunnel" do
  action :create
  shell "/bin/false"
end

directory "/home/tunnel" do
  action :create
  mode 0700
  owner "tunnel"
end

directory "/home/tunnel/.ssh" do
  action :create
  mode 0700
  owner "tunnel"
end

file "/home/tunnel/.ssh/authorized_keys" do
  action :create_if_missing
  mode 0600
  owner "tunnel"
end
