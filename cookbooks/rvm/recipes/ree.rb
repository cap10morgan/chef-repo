#
# Cookbook Name:: rvm
# Recipe:: ree

node.default[:rvm][:ruby][:implementation] = 'ree'
node.default[:rvm][:ruby][:version] = '1.8.7'
include_recipe "rvm::install"
