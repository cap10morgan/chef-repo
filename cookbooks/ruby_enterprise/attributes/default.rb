#
# Cookbook Name:: ruby_enterprise
# attributes:: ruby_enterprise
#
# Author:: Mike Fiedler (<miketheman@gmail.com>)
# Author:: Joshua Timberman (<joshua@opscode.com>)
# Author:: Sean Cribbs (<seancribbs@gmail.com>)
# Author:: Michael Hale (<mikehale@gmail.com>)
#
# Copyright:: 2011, Mike Fiedler
# Copyright:: 2009-2010, Opscode, Inc.
# Copyright:: 2009, Sean Cribbs
# Copyright:: 2009, Michael Hale
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
#

default[:ruby_enterprise][:install_path] = "/opt/ruby-enterprise"
default[:ruby_enterprise][:ruby_bin]     = "/opt/ruby-enterprise/bin/ruby"
default[:ruby_enterprise][:gems_dir]     = "#{ruby_enterprise[:install_path]}/lib/ruby/gems/1.8"
default[:ruby_enterprise][:version]      = '1.8.7-2011.12'
default[:ruby_enterprise][:url]          = "http://rubyenterpriseedition.googlecode.com/files/ruby-enterprise-#{ruby_enterprise[:version]}"
