#
# Cookbook Name:: nodejs
# Recipe:: users
#
# Greg Konradt. Dec. 2016

## WORK IN PROGRESS
group 'jenkins' do
  action :create  
end

user "Jenkins Release User" do
  username 'jenkins'    
  gid 'jenkins'
  password node['nodejs']['jenkinsPassHash']
  shell '/bin/bash'   
  home "/home/jenkins"
  manage_home true
end


directory "/home/jenkins/.ssh" do
	recursive true
  action :create
end


file "/home/jenkins/.ssh/authorized_keys" do
  mode '600'
  owner 'jenkins'
  content node['nodejs']['sshPubKey']
end

bash 'jenkins-chef-client_sudo' do
  user 'root'
  not_if 'grep jenkins /etc/sudoers'
  code <<-EOH
    echo "jenkins ALL=(ALL) NOPASSWD: /usr/bin/chef-client" >> /etc/sudoers    
  EOH
end

