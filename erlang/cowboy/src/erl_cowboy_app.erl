-module(erl_cowboy_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
    application:ensure_all_started(gun),
    Dispatch = cowboy_router:compile([
        %% {HostMatch, list({PathMatch, Handler, InitialState})}
        {'_', [
                {"/bgg/:id", bgg_handler, []},
                {"/healthy", health_handler, []},
                {"/:id", id_handler, []},
                {"/", root_handler, []}
              ]
        }
    ]),
    {ok, _} = cowboy:start_clear(my_http_listener,
        [{port, 8080}],
        #{env => #{dispatch => Dispatch}}
    ),
    erl_cowboy_sup:start_link().

stop(_State) ->
    application:stop(gun),
	ok.
