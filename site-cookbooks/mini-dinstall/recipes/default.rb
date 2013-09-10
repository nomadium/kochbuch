#
# Cookbook Name:: mini-dinstall
# Recipe:: default
#
# Copyright 2013, Miguel Landaeta
#
# All rights reserved - Do Not Redistribute
#

# mini-dinstall is the software used to implement the apt repository
# nginx is installed to served those files through HTTP
# rng-tools is just used to provide faster pseudo number generation,
# otherwise gnupg is unable to generate pgp keys.

# some interesting links about APT repositories:
# https://www.google.com.ar/search?q=apt+repository
# http://wiki.debian.org/HowToSetupADebianRepository
# http://upsilon.cc/~zack/blog/posts/2009/04/howto:_uploading_to_people.d.o_using_dput/
# http://apt.last.fm/
require 'open3'

%w(mini-dinstall nginx rng-tools).each do |pkg|
  package pkg do
    action :install
  end
end

group node['mini-dinstall']['group'] do
  action :create
end

user node['mini-dinstall']['user'] do
  action :create
  supports :manage_home => true
  comment node['mini-dinstall']['comment']
  home node['mini-dinstall']['homedir']
  shell "/bin/false"
  gid node['mini-dinstall']['group']
end

group node['mini-dinstall']['group'] do
  action :modify
  members node['mini-dinstall']['user']
  append true
end

template "#{node['mini-dinstall']['homedir']}/.mini-dinstall.conf" do
  action :create
  owner node['mini-dinstall']['user']
  group node['mini-dinstall']['group']
  mode 0640
  source "mini-dinstall.conf.erb"
end

parent_archivedir = File.expand_path("..", node['mini-dinstall']['archivedir'])

[parent_archivedir, node['mini-dinstall']['archivedir']].each do |dir|
  directory dir do
    action :create
    owner node['mini-dinstall']['user']
    group node['mini-dinstall']['group']
    mode 0755
  end
end

parent_incoming_dir = File.expand_path("..", "#{node['mini-dinstall']['archivedir']}/mini-dinstall/incoming")

[parent_incoming_dir, "#{node['mini-dinstall']['archivedir']}/mini-dinstall/incoming"].each do |dir|
  directory dir do
    action :create
    owner node['mini-dinstall']['user']
    group node['mini-dinstall']['group']
    mode 0750
  end
end

template node['mini-dinstall']['apt_vhost'] do
  action :create
  owner "root"
  group "root"
  mode 0644
  source "nginx_vhost_apt.erb"
end

link node['mini-dinstall']['apt_enabled_vhost'] do
  to node['mini-dinstall']['apt_vhost']
end

template "/etc/default/rng-tools" do
  action :create
  owner "root"
  group "root"
  mode 0644
  source "rng-tools.erb"
end

service "rng-tools" do
  action :restart
end

batch_key_conf_file = "#{node['mini-dinstall']['homedir']}/gnupg_batch_creation_key.conf"
apt_secrets = Chef::EncryptedDataBagItem.load("mini-dinstall", "apt_secrets")
gnupg_passphrase = apt_secrets['gnupg_passphrase']

template batch_key_conf_file do
  action :create
  owner node['mini-dinstall']['user']
  group node['mini-dinstall']['group']
  mode 0600
  variables(:gnupg_passphrase => gnupg_passphrase)
  source "gnupg_batch_creation_key.conf.erb"
end

execute "generate pgp key for apt repository" do
  action :run
  creates "#{node['mini-dinstall']['homedir']}/pgp_key_is_generated"
  cwd node['mini-dinstall']['homedir']
  user node['mini-dinstall']['user']
  group node['mini-dinstall']['group']
  environment ({'HOME' => node['mini-dinstall']['homedir'], 'USER' => node['mini-dinstall']['user']})
  command "gpg --batch --gen-key #{batch_key_conf_file} && touch pgp_key_is_generated"
  notifies :create, "ruby_block[fetch-pgp-key-id]", :immediately
end

file batch_key_conf_file do
  action :delete
end

file "#{node['mini-dinstall']['homedir']}/.gnupg/passphrase" do
  action :create_if_missing
  owner node['mini-dinstall']['user']
  group node['mini-dinstall']['group']
  mode 0600
  content "#{gnupg_passphrase}"
end

ruby_block "fetch-pgp-key-id" do
  block do
    list_cmd = "sudo su -s /bin/bash -c 'gpg --list-secret-keys --with-colons | grep ^sec::' - #{node['mini-dinstall']['user']}"
    stdin, stdout, stderr = Open3.popen3(list_cmd)
    gnupg_keyid = stdout.gets(nil).split(':')[4]
    gnupg_pubkey = "#{node['mini-dinstall']['archivedir']}/#{gnupg_keyid}.pub"
    `sudo su -s /bin/bash -c 'gpg --armor --export #{gnupg_keyid}' - #{node['mini-dinstall']['user']} > #{gnupg_pubkey}`
  end
  action :nothing
end

directory "#{node['mini-dinstall']['homedir']}/bin" do
  action :create
  owner node['mini-dinstall']['user']
  group node['mini-dinstall']['group']
  mode 0700
end

template "#{node['mini-dinstall']['homedir']}/bin/sign-release.sh" do
  action :create
  owner node['mini-dinstall']['user']
  group node['mini-dinstall']['group']
  mode 0700
  variables(:gnupg_keyid => node[:gnupg_keyid])
  source "sign-release.sh.erb"
end

service "nginx" do
  action [ :enable, :start ]
end
