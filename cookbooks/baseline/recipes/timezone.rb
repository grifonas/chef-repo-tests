case node['platform_family']
when 'debian'
  package 'tzdata' do
    action :upgrade
  end

  file "/etc/timezone" do
    content 'Etc/GMT'
    owner 'root'
    group 'root'
    mode 0644
    notifies :run, 'bash[dpkg-reconfigure tzdata]'
  end

  bash 'dpkg-reconfigure tzdata' do
    user 'root'
    code "/usr/sbin/dpkg-reconfigure -f noninteractive tzdata"
    action :nothing
  end

when 'centos', 'fedora', 'redhat'

    package 'tzdata' do
      action :upgrade
    end

    bash 'timedatectl set-timezone' do
      user 'root'
      code "/usr/bin/timedatectl --no-ask-password set-timezone Etc/GMT"
    end
end
