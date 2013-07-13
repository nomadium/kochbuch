passwords = Chef::EncryptedDataBagItem.load("passwords", "machines")

template "/etc/grub.d/40_custom" do
  action :create
  owner "root"
  group "root"
  mode 0755
  source "40_custom.erb"
  variables(:boot_password => passwords['alice_grub_bootpasswd'])
  notifies :run, "execute[update-grub]"
end

execute "update-grub" do
  action :nothing
  user "root"
  group "root"
  command "update-grub"
end
