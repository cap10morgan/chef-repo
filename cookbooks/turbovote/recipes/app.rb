home_dir = node['turbovote']['app_root']

# create the user the app will run as
user node['turbovote']['user'] do
  action :create
  home home_dir
  system true
end

# create some directories the app requires
directory "#{node['turbovote']['app_root']}/releases" do
  action :create
  owner node['turbovote']['user']
  group node['turbovote']['user']
  mode 0755
  recursive true
end

directory "#{node['turbovote']['app_root']}/shared/log" do
  action :create
  owner node['turbovote']['user']
  group node['turbovote']['user']
  mode 0755
  recursive true
end

directory "#{node['turbovote']['app_root']}/shared/pids" do
  action :create
  owner node['turbovote']['user']
  group node['turbovote']['user']
  mode 0755
  recursive true
end

# setup the SSH keys so sysadmins can deploy the app
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

# install the app's dependencies
gem_package "bundler" do
  action :install
end

package "libxml2-dev" do
  action :install
end

package "libxslt-dev" do
  action :install
end

# create the apache config
apache_site "default" do
  enable false
end

apache_site "default-ssl" do
  enable false
end

template "/etc/apache2/sites-available/turbovote" do
  source "apache_conf.erb"
  owner "root"
  owner "root"
  mode "0644"
  variables :doc_root => "#{node['turbovote']['app_root']}/current/public"
end

apache_site "turbovote"
