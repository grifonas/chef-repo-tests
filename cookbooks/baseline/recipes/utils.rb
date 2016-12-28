#
# Cookbook Name:: baseline
# Recipe:: utils
#
# Greg konradt. Dec. 2016
case node['platform_family']
when 'debian'
    package ['vim', 'iotop', 'htop', 'iftop', 'traceroute']   

when 'rhel'
	package 'epel-release'
	package ['sysstat', 'iotop', 'atop', 'htop', 'dstat', 'strace', 'perf']
	package ['vim', 'git', 'screen', 'telnet', 'curl', 'wget', 'bind-utils', 'net-tools', 'lsof', 'mc', 'lvm2', 'zip', 'unzip', 'tcpdump', 'dos2unix', 'mlocate', 'gcc']
end

bash 'set_default_editor' do
    user 'root'  
    code <<-EOH
  	  export EDITOR=vim
    EOH
end

