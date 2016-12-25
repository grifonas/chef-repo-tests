#
# Cookbook Name:: nodejs
# Recipe:: default
#
# Greg Konradt. Dec 2016

include_recipe 'nodejs::node'
include_recipe 'nodejs::consul-agent'
