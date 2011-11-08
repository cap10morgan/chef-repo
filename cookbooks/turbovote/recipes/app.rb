home_dir = node['turbovote']['app_root']

user node['turbovote']['user'] do
  action :create
  home home_dir
  system true
end

directory node['turbovote']['app_root'] do
  action :create
  owner node['turbovote']['user']
  group node['turbovote']['user']
  mode 0755
  recursive true
end

directory "#{home_dir}/.ssh" do
  action :create
  owner node['turbovote']['user']
  group node['turbovote']['user']
  mode 0700
end

search(:users, 'groups:sysadmin') do |u|
  user_ssh_dir = "/home/#{u['id']}/.ssh"
  execute "copy SSH keys to app user" do
    command "cat #{user_ssh_dir}/authorized_keys >> #{home_dir}/.ssh/authorized_keys"
    not_if "grep -q '#{u['ssh_keys']}' #{home_dir}/.ssh/authorized_keys"
  end
end
