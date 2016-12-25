#
# Cookbook Name:: consul-nodocker
# Recipe:: artifactory
#
# Greg Konradt. Dec 2016

bash 'install_java' do
  user 'root'  
  code <<-EOH
  	add-apt-repository -y ppa:webupd8team/java
  	apt-get update
  	echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
  EOH
end

package 'oracle-java8-set-default' do
  action :install
end

bash 'add_repo' do
  user 'root'  
  code <<-EOH
  	echo "deb https://jfrog.bintray.com/artifactory-debs $( lsb_release -c | awk '{print $2}') main" | tee -a /etc/apt/sources.list
  	curl https://bintray.com/user/downloadSubjectPublicKey?username=jfrog | apt-key add -
  	apt-get update   	
  EOH
  not_if 'grep artifactory-debs /etc/apt/sources.list'
end
package 'jfrog-artifactory-oss' do
  action :install
end

service 'artifactory' do
  supports :status => true, :restart => true, :reload => true
  action [:start, :enable]
end
