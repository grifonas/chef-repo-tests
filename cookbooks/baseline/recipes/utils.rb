#
# Cookbook Name:: baseline
# Recipe:: utils
#
# Greg konradt. Dec. 2016

package ['vim', 'iotop', 'htop', 'iftop', 'traceroute']  do
  action :install
end

bash 'set_default_editor' do
  user 'root'  
  code <<-EOH
  	export EDITOR=vim
  EOH
end