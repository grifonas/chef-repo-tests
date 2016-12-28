#
# Cookbook Name:: baseline
# Recipe:: default
#
# Greg Konradt. Dec 2016

include_recipe 'baseline::utils'
include_recipe 'baseline::users'
include_recipe 'baseline::ntp'
include_recipe 'baseline::timezone'
include_recipe 'baseline::sshd_config'