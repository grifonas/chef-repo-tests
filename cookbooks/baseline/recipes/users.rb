#
# Cookbook Name:: baseline
# Recipe:: users
#
# Greg Konradt. Dec. 2016

node["baseline"]["users"].each do |groupname|  
  case groupname['myAction']
  when 'create'  
    doThis = 'create'
  when 'remove'
    doThis = 'nothing'
  end
  group "#{groupname['name']}" do
    action doThis    
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
    action myUser['myAction']
  end
end

node["baseline"]["users"].each do |myUser|
  case myUser['myAction']
  when 'create'  
    doThis = 'create'
  when 'remove'
    doThis = 'delete'
  end
  
  directory "/home/#{myUser['name']}/.ssh/" do
    recursive true
    action doThis
  end
end

node["baseline"]["users"].each do |myUser|
  case myUser['myAction']
  when 'create'  
    doThis = 'create'
  when 'remove'
    doThis = 'nothing'
  end
  
  file "/home/#{myUser['name']}/.ssh/authorized_keys" do
    mode '600'
    owner myUser['name']
    content myUser['sshPubKey']
    action doThis
  end
end