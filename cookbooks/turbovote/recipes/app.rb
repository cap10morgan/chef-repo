include_recipe "turbovote::create_user"

# create some directories the app requires
%w[ releases shared shared/log shared/pids shared/system ].each do |dir|
  directory "#{node[:turbovote][:app_root]}/#{dir}" do
    action :create
    owner node['turbovote']['user']
    group node['turbovote']['user']
    mode 0755
  end
end

# install the app's dependencies
gem_package "bundler" do
  action :install
end

package "libxml2-dev" do
  action :install
end

package "libxslt1-dev" do
  action :install
end

# create the apache config
apache_site "default" do
  enable false
end

apache_site "default-ssl" do
  enable false
end

template "/etc/apache2/sites-available/turbovote.conf" do
  source "apache_conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  variables :doc_root => "#{node['turbovote']['app_root']}/current/public", :server_aliases => node['turbovote']['server_aliases']
end

apache_module "ssl"

apache_site "turbovote.conf"
