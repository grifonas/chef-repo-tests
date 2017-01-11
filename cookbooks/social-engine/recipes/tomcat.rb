#
# Cookbook:: social-engine
# Recipe:: tomcat
#
# Greg Konradt. Jan. 2017


# ----------------Istall Java-------------------
apt_repository 'oracle-java' do
  uri 'ppa:webupd8team/java'
end

bash 'java-licence-agree' do
  code <<-EOH
    echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
    echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections
  EOH
end

package 'oracle-java8-installer' do
  action :install
end
#-----------------------------------------------

group 'sclicks' do
  action :create
end

user 'sc_stat' do
  action :create
  comment 'Social Engine User'    
  gid 'sclicks'  
  home '/opt/sc_engine'
  manage_home true
end

remote_file '/opt/sc_engine/apache-tomcat-7.0.73.tar.gz' do
  owner 'sc_stat'
  group 'sclicks'
  mode '0644'
  source 'http://apache.mivzakim.net/tomcat/tomcat-7/v7.0.73/bin/apache-tomcat-7.0.73.tar.gz'
end

bash 'unpack_tomcat' do
  user 'sc_stat'
  cwd '/opt/sc_engine'
  code <<-EOH
  	tar xzf apache-tomcat-7.0.73.tar.gz
  EOH
end