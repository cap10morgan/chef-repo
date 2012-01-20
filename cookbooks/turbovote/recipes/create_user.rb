# create the home dir / app root dir
directory "#{node[:turbovote][:app_root]}" do
  action :create
  owner node['turbovote']['user']
  group node['turbovote']['user']
  mode 0755
  recursive true
end

# create the user the app will run as
user node['turbovote']['user'] do
  action :create
  home node[:turbovote][:app_root]
  system true
end

# setup the SSH keys so sysadmins can deploy the app
directory "#{node[:turbovote][:app_root]}/.ssh" do
  action :create
  owner node['turbovote']['user']
  group node['turbovote']['user']
  mode 0700
end

search(:users, 'groups:sysadmin') do |u|
  user_ssh_dir = "/home/#{u['id']}/.ssh"
  Chef::Log.info "Adding #{u[:id]} to deploy SSH users"
  execute "copy SSH keys to app user" do
    command "cat #{user_ssh_dir}/authorized_keys >> #{node[:turbovote][:app_root]}/.ssh/authorized_keys"
    not_if "grep -q '#{u['ssh_keys']}' #{node[:turbovote][:app_root]}/.ssh/authorized_keys"
  end
end

# add user's own SSH keys
ssh_keys = Chef::EncryptedDataBagItem.load("ssh_keys", node[:turbovote][:user])
file "#{node[:turbovote][:app_root]}/.ssh/id_dsa" do
  owner node[:turbovote][:user]
  group node[:turbovote][:user]
  mode "0600"
  content ssh_keys['private'] + "\n"
  action :create
end
file "#{node[:turbovote][:app_root]}/.ssh/id_dsa.pub" do
  owner node[:turbovote][:user]
  group node[:turbovote][:user]
  mode "0600"
  content ssh_keys['public'] + "\n"
  action :create
end

execute "set owner on authorized_keys" do
  command "chown #{node[:turbovote][:user]}:#{node[:turbovote][:user]} #{node[:turbovote][:app_root]}/.ssh/authorized_keys"
end

execute "set perms on authorized_keys" do
  command "chmod 600 #{node[:turbovote][:app_root]}/.ssh/authorized_keys"
end

