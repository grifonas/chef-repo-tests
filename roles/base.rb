name "base"
description "A role to configure all servers"
override_attributes(
  "chef_client" => {
	"server_url" => "https://chef-server/organizations/taptica",
    	"validation_client_name" => "taptica-validator",
	"interval" => "300",
	"splay" => 60
  }
)
run_list(
	"recipe[chef-client::default]",
	"recipe[chef-client::delete_validation]",
	"recipe[chef-client::config]",
	"recipe[chef-client::service]",
	"recipe[baseline]"
)
