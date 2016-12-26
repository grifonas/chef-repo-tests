#
# Cookbook Name:: nodejs
# Recipe:: node
#
# Greg Konradt. Dec 2016

bash 'set_hostname' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
    echo #{node['nodejs']['hostname']} > /etc/hostname
    echo "#{node['ipaddress']} #{node['nodejs']['hostname']}" >> /etc/hosts
    hostname #{node['nodejs']['hostname']}
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

bash 'get_installed_app_MD5' do
  user 'root'
  cwd '/opt/nodeapp'
  code <<-EOH
    md5sum main.js | awk '{print $1}' > md5_curr.txt
  EOH
end

bash 'get_latest_artefact' do
  user 'root'
  cwd '/opt/nodeapp'
  code <<-EOH
    wget http://artifactory.infra:8081/artifactory/#{node['nodejs']['RepoName']}/main.js -O main.js-new
    md5sum main.js-new | awk '{print $1}' > md5_new.txt
  EOH
end

bash 'restart_updated_app' do
  user 'root'
  cwd '/opt/nodeapp'
  not_if 'diff md5_curr.txt md5_new.txt'
  code <<-EOH    
    pkill -9 nodejs || true 
    mv /opt/nodeapp/main.js /opt/nodeapp/main.js-prev || true 
    mv /opt/nodeapp/main.js-new /opt/nodeapp/main.js 
    nodejs main.js > logs/main.log 2> logs/main.err &
  EOH
end