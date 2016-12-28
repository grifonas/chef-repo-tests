#
# Cookbook:: baseline
# Recipe:: iTerm2_Shel_Int
#
# Greg Konradt. Dec 2016

cookbook_file '/tmp/install_shell_integration.sh' do
  source 'install_shell_integration.sh'
  owner 'root'
  group 'root'
  mode '0755'
end


bash 'install_iTerm2_Shel_Integration' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  	./install_shell_integration.sh
  EOH
end