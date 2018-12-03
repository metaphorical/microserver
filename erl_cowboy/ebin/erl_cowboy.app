{application, 'erl_cowboy', [
	{description, ""},
	{vsn, "rolling"},
	{modules, ['erl_cowboy_app','erl_cowboy_sup','id_handler','root_handler']},
	{registered, [erl_cowboy_sup]},
	{applications, [kernel,stdlib,cowboy]},
	{mod, {erl_cowboy_app, []}},
	{env, []}
]}.