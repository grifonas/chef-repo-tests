name "nodeapp"
description "A role to configure node app"
run_list(
	"role[base]",
	"recipe[nodejs]"
)
