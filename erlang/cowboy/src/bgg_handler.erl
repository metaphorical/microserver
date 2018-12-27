-module(bgg_handler).
-behavior(cowboy_handler).

-export([init/2, handle_request/1]).

receive_data(ConnPid, MRef, StreamRef) ->
    Result = "",
    receive
        {gun_data, ConnPid, StreamRef, nofin, Data} ->
            Result = Result ++ Data,
            receive_data(ConnPid, MRef, StreamRef);
        {gun_data, ConnPid, StreamRef, fin, Data} ->
            Result = Result ++ Data;
        {'DOWN', MRef, process, ConnPid, Reason} ->
            error_logger:error_msg("Oops!"),
            exit(Reason)
    after 1000 ->
        exit(timeout)
    end,
    Result.

handle_request(<<"bgg">>) ->
    <<"{\"message\": \"Welcome to bgg controller\"}">>;

handle_request(_) ->
    {ok, ConnPid} = gun:open("bgg-json.azurewebsites.net", 443),

    MRef = monitor(process, ConnPid),

    StreamRef = gun:get(ConnPid, "/hot"),

    Result = receive_data(ConnPid, MRef, StreamRef),

    gun:close(ConnPid),

    Result.

init(Req0=#{method := <<"GET">>}, State) ->
    Id = cowboy_req:binding(id, Req0),
    Req = cowboy_req:reply(200, #{
        <<"content-type">> => <<"application/json">>
    }, handle_request(Id) , Req0),
    {cowboy_rest, Req, State};


init(Req0, State) ->
    Req = cowboy_req:reply(405, #{
        <<"allow">> => <<"GET">>
    }, Req0),
    {cowboy_rest, Req, State}.

