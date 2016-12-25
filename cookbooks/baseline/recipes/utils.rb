#
# Cookbook Name:: baseline
# Recipe:: utils
#
# Greg konradt. Dec. 2016

package ['iotop', 'htop', 'iftop', 'traceroute']  do
  action :install
end
