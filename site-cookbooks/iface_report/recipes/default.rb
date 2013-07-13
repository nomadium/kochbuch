#
# Cookbook Name:: iface_report
# Recipe:: default
#
# Copyright 2013, Miguel Landaeta
#
# All rights reserved - Do Not Redistribute
#
%w(python python-tweepy iproute).each do |pkg|
  package pkg do
    action :install
  end
end

directory "/etc/network/scripts" do
  action :create
  owner "root"
  group "root"
  mode 0755
end

notification_secrets = Chef::EncryptedDataBagItem.load("iface_report", "notification")

template "/etc/network/scripts/notification" do
  action :create
  owner "root"
  group "root"
  mode 0700
  variables(:consumer_key        => notification_secrets['CONSUMER_KEY'],
            :consumer_secret     => notification_secrets['CONSUMER_SECRET'],
            :access_token        => notification_secrets['ACCESS_TOKEN'],
            :access_token_secret => notification_secrets['ACCESS_TOKEN_SECRET'])
  source "notification.erb"
end

template "/etc/network/if-up.d/iface_report" do
  action :create
  owner "root"
  group "root"
  mode 0755
  source "iface_report.erb"
end
