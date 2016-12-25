#
# Cookbook Name:: consul-nodocker
# Recipe:: default
#
# Greg Konradt. Dec 2016

include_recipe 'consul-nodocker::consul'
include_recipe 'consul-nodocker::artifactory'

