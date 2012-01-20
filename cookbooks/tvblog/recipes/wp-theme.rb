include_recipe "turbovote::create_user"

if node.chef_environment == "staging"
  branch_name = "staging"
else
  branch_name = "master"
end

template "#{node[:turbovote][:app_root]}/.ssh/git-ssh-wrapper" do
  source "git-ssh-wrapper.erb"
  owner node[:turbovote][:user]
  group node[:turbovote][:user]
  mode 0700
  variables :private_key_path => "#{node[:turbovote][:app_root]}/.ssh/id_dsa"
  notifies :sync, "git[wp-theme]", :immediately
end

git "wp-theme" do
  repository node[:tvblog][:git_repo]
  destination "#{node[:wordpress][:dir]}/wp-content/themes/turbovote"
  depth 1
  ssh_wrapper "#{node[:turbovote][:app_root]}/.ssh/git-ssh-wrapper"
  revision branch_name
  action :nothing # the git-ssh-wrapper template resource will trigger this
  user "deploy"
end
