-module(bgg_handler).
-behavior(cowboy_handler).

-export([init/2]).


init(Req0=#{method := <<"GET">>}, State) ->
    http_request:get(self(), "bgg-json.azurewebsites.net", 443, "/hot"),
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

