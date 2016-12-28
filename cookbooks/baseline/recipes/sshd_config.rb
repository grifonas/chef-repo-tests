#
# Cookbook Name:: common_setup
# Recipe:: sshd_config
#
# Greg Konradt. Dec 2016

case node[:platform]
when 'ubuntu', 'debian'  
  cookbook_file '/etc/ssh/sshd_config' do
    source 'sshd_config_debian'
    owner 'root'
    group 'root'
    mode '0644'
  end
  

  service 'ssh' do
    supports :status => true, :restart => true, :start => true
    action [ :enable, :reload ]
    #action :enable
  end

when 'centos', 'redhat'
  cookbook_file '/etc/ssh/sshd_config' do
    source 'sshd_config_centos'
    owner 'root'
    group 'root'
    mode '0644'
  end

  service 'sshd' do
    supports :status => true, :restart => true
    action [ :enable, :reload ]
  end

end

