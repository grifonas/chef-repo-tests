#
# Cookbook Name:: baseline
# Recipe:: users
#
# Greg Konradt. Dec. 2016
node["baseline"]["users"].each do |groupname|
  group "#{groupname['name']}" do
  	action :create    
  end  
end


node["baseline"]["users"].each do |myUser|  
  user "#{myUser['fullName']}" do
    username myUser['name']    
    gid myUser['name']
  	password myUser['passHash']
  	shell '/bin/bash'  	
  	home "/home/#{myUser['name']}"
  	manage_home true
  end
end


node["baseline"]["users"].each do |myUser|
  directory "/home/#{myUser['name']}/.ssh/" do
  	action :create
  end
end

node["baseline"]["users"].each do |myUser|
  file "/home/#{myUser['name']}/.ssh/authorized_keys" do
    mode '600'
    owner myUser['name']
    content myUser['sshPubKey']
  end
end
