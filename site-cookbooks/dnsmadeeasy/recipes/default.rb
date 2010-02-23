#
# Cookbook Name:: dnsmadeeasy
# Recipe:: default
#
# Copyright 2010, Third Sector Design
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

http_request "set DNSMadeEasy IP" do
  action :get
  url "http://www.dnsmadeeasy.com/servlet/updateip"
  # we'll assume ec2, cuz we can
  ip = node[:ec2][:local_ipv4]
  dnsme = JSON::parse(open(node[:dnsmadeeasy][:cred_url]).read)[:dnsmadeeasy]
  ddns_id = JSON::parse(open(node[:ec2][:userdata]))[:dnsmadeeasy][:ddnsid]
  message :username => dnsme[:username], :password => dnsme[:password], :id => ddns_id, :ip => ip
end