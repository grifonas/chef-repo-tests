#
# Cookbook:: baseline
# Recipe:: upgrade
#
# Greg Konradt. Dec 2016
case node['platform_family']

when 'debian'	
  bash 'upgrade_system' do
    user 'root'
    not_if 'ls /usr/local/initial_upgrade.date'
    cwd '/tmp'
    code <<-EOH
  	  apt-get update
  	  date > /usr/local/initial_upgrade.date
  	  apt-get upgrade -y >> /usr/local/initial_upgrade.date  	  
    EOH
  end

when 'rhel'
	bash 'upgrade_system' do
	  user 'root'
	  not_if 'ls /usr/local/initial_upgrade.date'
	  cwd '/tmp'
	  code <<-EOH
	  	date > /usr/local/initial_upgrade.date
	  	yum update -y >> /usr/local/initial_upgrade.date
	  EOH
	end
end