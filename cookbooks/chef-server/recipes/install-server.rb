#
# Cookbook Name:: chef-server
# Recipe:: install-server
#
# Greg Konradt. Intended for installing Chef server with kitchen or Chef local mode

bash 'set_hostname' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
    echo chef-server > /etc/hostname
    echo "#{node['ipaddress']} chef-server" >> /etc/hosts
    hostname chef-server
  EOH
end
remote_file '/usr/local/src/chef-server.deb' do
  owner 'root'
  group 'root'
  mode '0755'
  source 'https://packages.chef.io/files/stable/chef-server/12.11.1/ubuntu/16.04/chef-server-core_12.11.1-1_amd64.deb'
  checksum 'f9937ae1f43d7b5b12a5f91814c61ce903329197cd342228f2a2640517c185a6'
end

dpkg_package 'chef' do
  source '/usr/local/src/chef-server.deb'
end

bash 'configure_chef_step_1' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  	 chef-server-ctl reconfigure
  EOH
end

bash 'install_chef_manage' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  	chef-server-ctl install chef-manage 
  EOH
end

directory '/secrets' do
  owner 'root'
  group 'root'
  mode '400'
  action :create
end

node["chef-server"]["users"].each do |myUser|
  bash 'create_users' do
    user 'root'
    cwd '/tmp'
    ignore_failure true
    code <<-EOH
      chef-server-ctl user-create #{myUser['name']} #{myUser['fullName']} #{myUser['email']} '#{myUser['pass']}' --filename /secrets/#{myUser['name']}.pem
    EOH
  end  
end

bash 'create_organisation' do
  user 'root'
  cwd '/tmp'
  ignore_failure true
  code <<-EOH
  	chef-server-ctl org-create #{node['chef-server']['orgName']} '#{node['chef-server']['orgFullName']}' --association_user #{node['chef-server']['firstAdmin']} --filename /secrets/#{node['chef-server']['orgName']}-validator.pem
  EOH
end

bash 'install_chef_reporting' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
    chef-server-ctl install opscode-reporting
    chef-server-ctl reconfigure
    opscode-reporting-ctl reconfigure --accept-license
  EOH
end

bash 'configure_chef_step_2' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  	 chef-server-ctl reconfigure
  	 chef-manage-ctl reconfigure --accept-license
  EOH
end
