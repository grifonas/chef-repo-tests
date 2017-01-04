#
# Cookbook Name:: nodejs
# Recipe:: node
#
# Greg Konradt. Dec 2016

bash 'set_hostname' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
    echo #{node['nodejs']['hostname']}-$(curl http://169.254.169.254/latest/meta-data/instance-id) > /etc/hostname
    echo "#{node['ipaddress']} #{node['nodejs']['hostname']}-$(curl http://169.254.169.254/latest/meta-data/instance-id)" >> /etc/hosts
    hostname #{node['nodejs']['hostname']}-$(curl http://169.254.169.254/latest/meta-data/instance-id)
  EOH
end

execute 'apt-get-update' do
  command 'apt-get update'    
end

package 'nodejs' do
  action :install
end

bash 'add_alias' do
  user 'root'  
  code <<-EOH
  	echo "alias node='nodejs' > ~/.bash_aliases"
  	bash
  EOH
end

directory '/root/.ssh' do
  owner 'root'
  group 'root'  
  action :create
end

cookbook_file '/root/.ssh/id_rsa' do
  source 'git_key'
  owner 'root'
  group 'root'
  mode '400'
end

directory '/opt/nodeapp/logs' do  
  recursive true
  action :create
end

bash 'add_git_ssh_identity' do
  user 'root'
  code <<-EOH
    rm /root/.ssh/known_hosts
    ssh-keyscan bitbucket.org > /root/.ssh/known_hosts
  EOH
end
## The commented out section below can be used to get the code from the repo instead of Artifactory
#git '/opt/nodeapp' do
#  repository 'ssh://git@bitbucket.org/grifonas/devops-test.git'
#  reference 'master'  
#  action :sync
#  notifies :run, 'bash[run_nodejs_app]'
#end

#bash 'run_nodejs_app' do
#  user 'root'
#  cwd '/opt/nodeapp'
#  action :nothing
#  not_if 'ls /opt/nodeapp/main.js'
#  code <<-EOH
#    pkill -9 nodejs
#    nodejs main.js > logs/main.log 2> logs/main.err &
#  EOH
#end
## End of section

case node.chef_environment  
when 'testing'
  consul_key_name = 'qa-version'
when 'prod'
  consul_key_name = 'stable-version'
end

bash 'get_installed_app_MD5' do
  user 'root'
  cwd '/opt/nodeapp'
  code <<-EOH    
    md5sum $(ps aux | grep node | head -1 | awk '{print $NF}') | awk '{print $1}' > md5_curr.txt
  EOH
end

bash 'get_latest_artefact' do
  user 'root'
  cwd '/opt/nodeapp'  
    code <<-EOH
      CURR_VERSION=$(consul kv get #{consul_key_name})
      wget http://artifactory.infra:8081/artifactory/#{node['nodejs']['RepoName']}/$CURR_VERSION -O new-main.js
      md5sum new-main.js | awk '{print $1}' > md5_new.txt
    EOH
end

bash 'restart_updated_app' do
  user 'root'
  cwd '/opt/nodeapp'
  not_if "diff /opt/nodeapp/md5_curr.txt /opt/nodeapp/md5_new.txt"
  code <<-EOH    
    CURR_VERSION=$(consul kv get #{consul_key_name})
    pkill -9 nodejs || true     
    mv /opt/nodeapp/new-main.js /opt/nodeapp/$CURR_VERSION
    nodejs $CURR_VERSION > logs/main.log 2> logs/main.err &
  EOH
end