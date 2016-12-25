#
# Cookbook Name:: nodejs
# Recipe:: consul-agent
#
# Greg Konradt. Dec. 2016

directory '/etc/consul' do
  owner 'root'
  group 'root'  
  action :create
end

directory '/etc/consul.d' do
  owner 'root'
  group 'root'  
  action :create
end

directory '/data' do
  owner 'root'
  group 'root'  
  action :create
end

package 'unzip' do
  action :install
end

remote_file '/tmp/consul.zip' do
  owner 'root'
  group 'root'
  mode '0644'
  source 'https://releases.hashicorp.com/consul/0.7.1/consul_0.7.1_linux_amd64.zip'  
end

bash 'install_consul' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  	unzip /tmp/consul.zip
  	mv consul /usr/local/bin/
  EOH
end

template '/etc/consul/agent.json' do
  source 'agent.json.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

template '/etc/systemd/system/consul.service' do
  source 'consul-agent-service.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

service 'consul' do
  supports :status => true, :restart => true, :reload => true
  action [:restart, :enable]
end
