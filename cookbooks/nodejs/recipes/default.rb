#
# Cookbook Name:: nodejs
# Recipe:: default
#
# Greg Konradt. Dec 2016

include_recipe 'nodejs::node'
include_recipe 'nodejs::consul-agent'
include_recipe 'nodejs::jenkins_user'

#bash 'test_chef_client_run' do
#  user 'root'
#  cwd '/tmp'
#  code <<-EOH
#    echo "$(date) Chef Client" >> /var/log/chef-client-test.log
#  EOH
#end