#
# Cookbook:: dockerhost
# Recipe:: dockerengine
#
# Greg Konradt Dec. 2016

case node['platform_family']

when 'debian'
    bash 'apt_update_and_add_docker_repo' do
      user 'root'  
      not_if 'grep apt.dockerproject.org /etc/apt/sources.list.d/docker.list'
      code <<-EOH
    	apt-key adv \
       --keyserver hkp://ha.pool.sks-keyservers.net:80 \
       --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
  	  echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" | sudo tee /etc/apt/sources.list.d/docker.list
  	  apt-get update  	
      EOH
    end

    package ['apt-transport-https', 'ca-certificates', 'linux-image-extra-$(uname -r)', 'linux-image-extra-virtual', 'docker-engine'] 

when 'rhel'
  bash 'install_docker' do
    user 'root'    
    code <<-EOH
      tee /etc/yum.repos.d/docker.repo <<-'EOF'
		[dockerrepo]
		name=Docker Repository
		baseurl=https://yum.dockerproject.org/repo/main/centos/7/
		enabled=1
		gpgcheck=1
		gpgkey=https://yum.dockerproject.org/gpg	  
    EOH
  end
  
  package 'docker-engine'    

  service 'docker' do
    supports :status => true, :restart => true, :reload => true
    action [:start, :enable]
  end
  
  
end

