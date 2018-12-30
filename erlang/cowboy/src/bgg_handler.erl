-module(bgg_handler).
-behavior(cowboy_handler).


-export([init/2,
         bgg_request/2
        ]).



init(Req0=#{method := <<"GET">>}, State) ->
    Id = cowboy_req:binding(id, Req0),
    % Getting type from the route config (two routes with different configs are pointing to this handler)
    Type = maps:get(type, State),
    bgg_request(Type, Id),
    receive
        {response, Result} ->
            Req = cowboy_req:reply(200, #{
                <<"content-type">> => <<"application/json">>
            }, Result , Req0),
            {cowboy_rest, Req, State}
    end;
        
init(Req0, State) ->
    Req = cowboy_req:reply(405, #{
        <<"allow">> => <<"GET">>
    }, Req0),
    {cowboy_rest, Req, State}.



bgg_request(hot,_) ->
        http_request:get(self(), "bgg-json.azurewebsites.net", 443, "/hot");
bgg_request(item, Id) ->
        http_request:get(self(), Id).

