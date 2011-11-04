user node['turbovote']['user'] do
  action :create
  home node['turbovote']['app_root']
  system true
end

directory node['turbovote']['app_root'] do
  action :create
  owner node['turbovote']['user']
  group node['turbovote']['user']
  mode 0755
  recursive true
end
