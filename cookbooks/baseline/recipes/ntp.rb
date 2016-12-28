#
# Cookbook Name:: baseline
# Recipe:: users
#
# Greg Konradt. Dec. 2016

package value_for_platform_family(
  'debian'  => 'ntp',
  'rhel' => 'ntp'
)

template "/etc/ntp.conf" do
  source 'ntp.erb'
  owner 'root'
  group 'root'
  mode 0644
  case node[:platform]
    when 'ubuntu', 'debian'
      notifies :restart, 'service[ntp]', :immediately
    when 'centos', 'redhat'
      notifies :restart, 'service[ntpd]', :immediately
  end
end


case node.platform_family 
when 'debian'
  service 'ntp' do
    supports :status => true, :restart => true
    action [ :enable, :start ]
  end

else 
  service 'ntpd' do
    supports :status => true, :restart => true
    action [ :enable, :start ]
  end

end
