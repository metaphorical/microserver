-module(bgg_handler).
-behavior(cowboy_handler).

-export([init/2]).


init(Req0=#{method := <<"GET">>}, State) ->
    Id = cowboy_req:binding(id, Req0),
    bgg_request(Id),
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



bgg_request(<<"hot">>) ->
        http_request:get(self(), "bgg-json.azurewebsites.net", 443, "/hot");
bgg_request(_) ->
        http_request:get(self(), "dummy").
