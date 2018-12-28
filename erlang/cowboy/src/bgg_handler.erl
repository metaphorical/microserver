-module(bgg_handler).
-behavior(cowboy_handler).

-export([init/2, handle_request/2]).

receive_data(ConnPid, MRef, StreamRef, Result, CallerPid) ->
    receive
        {gun_data, ConnPid, StreamRef, nofin, Data} ->
            receive_data(ConnPid, MRef, StreamRef, <<Result/binary, Data/binary>>, CallerPid);
        {gun_data, ConnPid, StreamRef, fin, Data} ->
            CallerPid ! {data, <<Result/binary, Data/binary>>};
        {'DOWN', MRef, process, ConnPid, Reason} ->
            error_logger:error_msg("Oops!"),
            exit(Reason)
    after 1000 ->
        exit(timeout)
    end,
    Result.

handle_request(<<"bgg">>, _) ->
    <<"{\"message\": \"Welcome to bgg controller\"}">>;

handle_request(_, CallerPid) ->
    {ok, ConnPid} = gun:open("bgg-json.azurewebsites.net", 443),

    MRef = monitor(process, ConnPid),

    StreamRef = gun:get(ConnPid, "/hot"),

    receive_data(ConnPid, MRef, StreamRef, <<"">>, self()),
    receive
        {data, Result} ->
            CallerPid ! {response, Result},
            gun:close(ConnPid)
    end.


init(Req0=#{method := <<"GET">>}, State) ->
    Id = cowboy_req:binding(id, Req0),
    handle_request(Id, self()),
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

