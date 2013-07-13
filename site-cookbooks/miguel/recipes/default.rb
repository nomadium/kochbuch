#
# Cookbook Name:: miguel
# Recipe:: default
#
# Copyright 2013, Miguel Landaeta
#
# All rights reserved - Do Not Redistribute
#
group "miguel" do
  action :create
  gid 6666
  group_name "miguel"
end

passwords = Chef::EncryptedDataBagItem.load("passwords", "os_users")

user "miguel" do
  action :create
  gid "miguel"
  home "/home/miguel"
  shell "/bin/bash"
  uid 6666
  username "miguel"
#  disabled because Debian squeeze doesn't include ruby-shadow package
#  needed to use this feature
#  password passwords['miguel@regine']
end

group "miguel" do
  action :modify
  append true
  members "miguel"
end

directory "/home/miguel" do
  owner "miguel"
  group "miguel"
  mode 0701
  action :create
end

template "/etc/sudoers.d/miguel" do
  action :create
  mode 0440
  owner "root"
  group "root"
  source "sudoers.d.miguel.erb"
end

directory "/home/miguel/.ssh" do
  owner "miguel"
  group "miguel"
  mode 0700
  action :create
end

#todo: install this from data bags
template "/home/miguel/.ssh/authorized_keys" do
  action :create
  mode 0600
  owner "miguel"
  group "miguel"
  source "authorized_keys.erb"
end
