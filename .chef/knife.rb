# See https://docs.getchef.com/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "gkonradt"
client_key               "#{current_dir}/gkonradt.pem"
chef_server_url          "https://chef-server/organizations/taptica"
cookbook_path            ["#{current_dir}/../cookbooks"]

knife[:ssh_user] = "ubuntu"
knife[:identity_file] = "~/keys/AWS-Default.pem"
knife[:use_sudo] = true
