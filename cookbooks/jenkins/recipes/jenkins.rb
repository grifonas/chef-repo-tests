#
# Cookbook Name:: jenkins
# Recipe:: jenkins
#
# Greg Konradt. Dec. 2016
bash 'set_hostname' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
    echo jenkins > /etc/hostname
    echo "#{node['ipaddress']} jenkins" >> /etc/hosts
    hostname jenkins
  EOH
end

bash 'add_repo' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
    wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | apt-key add -
	  echo "deb http://pkg.jenkins.io/debian-stable binary/" > /etc/apt/sources.list.d/jenkins.list
	  apt-get update
  EOH
end

package 'jenkins' do
  action :install
end

cookbook_file '/etc/init.d/jenkins' do
  source 'jenkins-init.sh'
  owner 'root'
  group 'root'
  mode '755'
end
