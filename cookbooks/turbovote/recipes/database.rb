mysql_creds = Chef::EncryptedDataBagItem.load("passwords", "mysql")

password_option = "#{node['mysql']['server_root_password'].empty? ? '' : '-p' }#{node['mysql']['server_root_password']}"

execute "create-database" do
  command "/usr/bin/mysqladmin -u root #{password_option} create #{node['turbovote']['database_name']}"
  not_if "/usr/bin/mysql -u root #{password_option} -e 'show databases;' | grep -q '^#{node['turbovote']['database_name']}$'"
end

directory "/var/cache/local/mysql" do
  owner "root"
  group "root"
  mode "0700"
  recursive true
end

template "/var/cache/local/mysql/grant-query.sql" do
  source "create_mysql_user.erb"
  owner "root"
  group "root"
  mode "0600"
  variables :user => mysql_creds['user'], :password => mysql_creds['password']
  notifies :run, "execute[mysql-set-privileges]", :immediately
end

execute "mysql-set-privileges" do
  query_file = "/var/cache/local/mysql/grant-query.sql"
  command "/usr/bin/mysql -u root #{password_option} < #{query_file} && rm #{query_file}"
  action :nothing
  notifies :run, "execute[mysql-flush-privileges]", :immediately
end

execute "mysql-flush-privileges" do
  command "/usr/bin/mysqladmin -u root #{password_option} flush-privileges"
  action :nothing
end

link "/tmp/mysql.sock" do
  to "/var/run/mysqld/mysqld.sock"
end
