#
# Cookbook Name:: consul-nodocker
# Recipe:: consul
#
# Greg Konradt. Dec 2016

bash 'set_hostname' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
    echo consul-server > /etc/hostname
    echo "#{node['ipaddress']} consul-server" >> /etc/hosts
    hostname consul-server 
  EOH
end

package 'unzip' do
  action :install
end

directory '/var/lib/consul/data' do
  owner 'root'
  group 'root'
  recursive true
  action :create
end

directory '/var/lib/consul/web-ui' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

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

remote_file '/tmp/consul-web.zip' do
  owner 'root'
  group 'root'
  mode '0644'
  source 'https://releases.hashicorp.com/consul/0.7.1/consul_0.7.1_web_ui.zip'
end

bash 'install_consul_webui' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  	unzip -o /tmp/consul-web.zip -d /var/lib/consul/web-ui
  EOH
end

template '/etc/consul/server.json' do
  source 'server.json.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

template '/etc/systemd/system/consul.service' do
  source 'consul-server-service.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

service 'consul' do
  supports :status => true, :restart => true, :reload => true
  action [:restart, :enable]
end