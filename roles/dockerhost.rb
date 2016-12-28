name "dockerhost"
description "A role to configure docker host machines"
run_list(
	"role[base]",
	"recipe[dockerhost]"
)
