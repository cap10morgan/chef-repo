#
# Cookbook Name:: passenger_enterprise
# Based on passenger_apache2, adapted for nginx too.
# Recipe:: default
#
# Author:: Joshua Timberman (<joshua@opscode.com>)
# Author:: Joshua Sierles (<joshua@37signals.com>)
# Author:: Michael Hale (<mikehale@gmail.com>)
#
# Copyright:: 2009, Opscode, Inc
# Copyright:: 2009, 37signals
# Coprighty:: 2009, Michael Hale
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

def find_rvm_ree
  rubies = node[:rvm][:rubies].dup
  rubies << node[:rvm][:default_ruby]
  rubies.uniq!
  rubies.each do |rubie|
    if /^ree-/i =~ rubie
      return rubie
    end
  end
  false
end

def has_rvm_ree?
  node.has_key?(:rvm) && find_rvm_ree
end

def rvm_ree_install_path
  current_ruby = `rvm current`.chomp
  cmd = ""
  cmd += "rvm use ree && " unless /^ree-/ =~ current_ruby
  cmd += "echo $MY_RUBY_HOME"
  `#{cmd}`.chomp
end

if has_rvm_ree?
  # this will cause the ruby_enterprise recipe to not re-install REE
  node[:ruby_enterprise][:install_path] = rvm_ree_install_path
end

include_recipe "ruby_enterprise"

ree_gem "passenger" do
  version node[:passenger_enterprise][:version]
end
