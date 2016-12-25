#
# Cookbook Name:: jenkins
# Recipe:: default
#
# Greg Konradt Dec 2016

include_recipe 'jenkins::jenkins'
include_recipe 'jenkins::consul-agent'


