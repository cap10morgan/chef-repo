#
# Cookbook Name:: rvm
# Recipe:: install

ruby_version = [].tap do |v|
  v << node[:rvm][:ruby][:implementation] if node[:rvm][:ruby][:implementation]
  v << node[:rvm][:ruby][:version] if node[:rvm][:ruby][:version]
  v << node[:rvm][:ruby][:patch_level] if node[:rvm][:ruby][:patch_level]
end * '-'

rubies = search(:rvm_rubies, "*:*")
rubies = [{ :id => ruby_version }] unless rubies.count > 0

load_rvm = \
<<EOH
rvm_test=`type rvm | head -n 1`
if [ "$rvm_test" != "rvm is a function" ]; then
  . /usr/local/rvm/scripts/rvm
fi
EOH

include_recipe "rvm"

rubies.each do |ruby|
  ruby_str = ruby['id']
  ruby_array = []
  ruby_array << ruby['implementation'] if ruby.has_key?('implementation')
  ruby_array << ruby['version'] if ruby.has_key?('version')
  ruby_array << ruby['patch_level'] if ruby.has_key?('patch_level')
  ruby_str = ruby_array.join('-') if ruby_array.count > 0

  bash "installing #{ruby_str}" do
    user "root"
    code "#{load_rvm} rvm install #{ruby_str}"
    not_if "rvm list | grep #{ruby_str}"
  end

  bash "make #{ruby_str} the default ruby" do
    user "root"
    code "#{load_rvm} rvm --default #{ruby_str}"
    not_if "rvm list | grep '=> #{ruby_str}'"
    only_if { /^#{Regexp.escape(node[:rvm][:ruby][:default])}/ =~ ruby_version ||
              ruby['default'] }
    # notifies :restart, "service[chef-client]"
  end

  gem_package "chef" do
    gem_binary "#{load_rvm} gem"
    only_if { /^#{Regexp.escape(node[:rvm][:ruby][:default])}/ =~ ruby_version ||
              ruby['default'] }
    # re-install the chef gem into rvm to enable subsequent chef-client run
  end
end
