#
# Cookbook Name:: chef
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "chef" do
    action :install
end

group "automation" do
    action :create
    gid 1000
    group_name "automation"
end

user "automation" do
    action :create
    gid "automation"
    home "/srv/automation"
    shell "/bin/bash"
    uid 1000
    username "automation"
end

group "automation" do
    action :modify
    append true
    members "automation"
end

directory "/srv/automation" do
    owner "automation"
    group "automation"
    mode 0700
    action :create
end

template "/etc/sudoers.d/automation" do
    action :create_if_missing
    mode 0440
    owner "root"
    group "root"
    source "automation.erb"
end
