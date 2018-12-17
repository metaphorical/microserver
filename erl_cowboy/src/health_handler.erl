-module(health_handler).
-behavior(cowboy_handler).

-export([init/2]).

% If app is up and you perform get on this you get header X-Health:Awsome
init(Req0=#{method := <<"GET">>}, State) ->
    Req = cowboy_req:reply(200, #{
        <<"X-Health">> => <<"Awsome">>
    }, Req0),
    {cowboy_rest, Req, State};

% Anything not GET or OPTIONS goes here
init(Req0, State) ->
    Req = cowboy_req:reply(405, #{
        <<"allow">> => <<"GET">>
    }, Req0),
    {cowboy_rest, Req, State}.


