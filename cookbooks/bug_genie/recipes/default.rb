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

package "unzip"
package "rsync"
execute "unzip-bug_genie" do
  cwd Chef::Config[:file_cache_path]
  command "unzip thebuggenie_#{node['bug_genie']['version']}.zip"
  command "rsync -av thebuggenie-#{node['bug_genie']['version']}/ #{node['bug_genie']['dir']}/"
  command "rm -rf thebuggenie-#{node['bug_genie']['version']}"
  creates "#{node['bug_genie']['dir']}/tbg_cli"
end

execute "mysql-install-bg-privileges" do
  command "/usr/bin/mysql -u root -p#{node['mysql']['server_root_password']} < #{node['mysql']['conf_dir']}/bg-grants.sql"
  action :nothing
end

template "#{node['mysql']['conf_dir']}/bg-grants.sql" do
  source "grants.sql.erb"
  owner "root"
  group "root"
  mode "0600"
  variables(
    :user       => node['bug_genie']['db']['user'],
    :password   => node['bug_genie']['db']['password'],
    :database   => node['bug_genie']['db']['database']
  )
  notifies :run, "execute[mysql-install-bg-privileges]", :immediately
end

template "#{node['bug_genie']['dir']}/core/b2db_bootstrap.inc.php" do
  source "b2db_bootstrap.inc.php.erb"
  owner "root"
  owner "root"
  mode "0644"
  variables(
    :user       => node['bug_genie']['db']['user'],
    :password   => node['bug_genie']['db']['password'],
    :database   => node['bug_genie']['db']['database'],
    :tbl_prefix => node['bug_genie']['db']['table_prefix']
  )
end

execute "install-bug-genie" do
  cwd "#{node['bug_genie']['dir']}"
  options = "--accept_license=yes --use_existing_db_info=yes \
    --enable_all_modules=yes --setup_htaccess=yes"
  command "echo -e \"\n\n\" | ./tbg_cli install #{options}"
  creates "#{node['bug_genie']['dir']}/installed"
  action :nothing
end
