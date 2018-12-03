-module(id_handler).
-behavior(cowboy_handler).

-export([init/2]).

% First match confirms that method is, in deed get, because this is GET only route
init(Req0=#{method := <<"GET">>}, State) ->
    Id = cowboy_req:binding(id, Req0),
    Req = cowboy_req:reply(200, #{
        <<"content-type">> => <<"application/json">>
    }, <<"{\"id\": \"", Id/binary, "\"}">> , Req0),
    {ok, Req, State};


% Anything not GET goes here
init(Req0, State) ->
    Req = cowboy_req:reply(405, #{
        <<"allow">> => <<"GET">>
    }, Req0),
    {ok, Req, State}.
