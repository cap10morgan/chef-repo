include_recipe "turbovote::create_user"

if node.chef_environment == "staging"
  branch_name = "staging"
else
  branch_name = "master"
end

tvblog_dir = "#{node[:turbovote][:app_root]}/tvblog"

directory "#{node[:wordpress][:dir]}/wp-content/themes/turbovote" do
  owner "www-data"
  group "www-data"
  mode 0755
end

template "#{node[:turbovote][:app_root]}/.ssh/git-ssh-wrapper" do
  source "git-ssh-wrapper.erb"
  owner node[:turbovote][:user]
  group node[:turbovote][:user]
  mode 0700
  variables :private_key_path => "#{node[:turbovote][:app_root]}/.ssh/id_dsa"
end

git "wp-theme" do
  repository node[:tvblog][:git_repo]
  destination tvblog_dir
  depth 1
  ssh_wrapper "#{node[:turbovote][:app_root]}/.ssh/git-ssh-wrapper"
  revision branch_name
end

execute "copy-wp-theme" do
  not_if "diff -qr #{tvblog_dir}/themes/turbovote #{node[:wordpress][:dir]}/wp-content/themes/turbovote"
  commands = [
    "cp -a #{tvblog_dir}/themes/turbovote #{tvblog_dir}/turbovote-wp-theme.copy",
    "rm -rf /tmp/turbovote-wp-theme.old",
    "mv #{node[:wordpress][:dir]}/wp-content/themes/turbovote /tmp/turbovote-wp-theme.old",
    "mv #{tvblog_dir}/turbovote-wp-theme.copy #{node[:wordpress][:dir]}/wp-content/themes/turbovote",
  ]
  command commands.join(' && ')
end
