#
# Cookbook Name:: rvm
# Recipe:: jruby

node.default[:rvm][:ruby][:implementation] = 'jruby'
include_recipe "rvm::install"
