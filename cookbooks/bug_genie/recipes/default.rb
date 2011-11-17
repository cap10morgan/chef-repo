include_recipe "apache2"
include_recipe "mysql::server"
include_recipe "php"
include_recipe "php::module_mysql"
include_recipe "apache2::mod_php5"

node.set['bug_genie']['db']['password'] = secure_password

remote_file "#{Chef::Config[:file_cache_path]}/thebuggenie_#{node['bug_genie']['version']}.zip" do
  checksum node['bug_genie']['checksum']
  source "http://downloads.sourceforge.net/project/bugs-bug-genie/thebuggenie_#{node['bug_genie']['version']}.zip?use_mirror=iweb"
  mode "0644"
end

directory "#{node['bug_genie']['dir']}" do
  owner "root"
  group "root"
  mode "0755"
  action :create
  recursive true
end

execute "unzip-bug_genie" do
  cwd Chef::Config[:file_cache_path]
  command "unzip thebuggenie_#{node['bug_genie']['version']}.zip"

end
