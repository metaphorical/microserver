-module(bgg_handler).
-behavior(cowboy_handler).

-export([init/2, handle_request/1]).

receive_data(CallerPid, ConnPid, MRef, StreamRef, Result) ->
    receive
        {gun_data, ConnPid, StreamRef, nofin, Data} ->
            receive_data(CallerPid, ConnPid, MRef, StreamRef, <<Result/binary, Data/binary>>);
        {gun_data, ConnPid, StreamRef, fin, Data} ->
            CallerPid ! {data, <<Result/binary, Data/binary>>};
        {'DOWN', MRef, process, ConnPid, Reason} ->
            error_logger:error_msg("Oops!"),
            exit(Reason)
    after 10000 ->
        exit(timeout)
    end.

handle_request(CallerPid) ->
    {ok, ConnPid} = gun:open("bgg-json.azurewebsites.net", 443),

    MRef = monitor(process, ConnPid),

    StreamRef = gun:get(ConnPid, "/hot"),

    receive_data(self(), ConnPid, MRef, StreamRef, <<"">>),
    receive
        {data, Result} ->
            CallerPid ! {response, Result},
            gun:close(ConnPid)
    end.


init(Req0=#{method := <<"GET">>}, State) ->
    handle_request(self()),
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

