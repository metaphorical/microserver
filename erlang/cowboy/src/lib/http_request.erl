-module(http_request).

-export([receive_data/5, get/4]).

receive_data(CallerPid, ConnPid, MRef, StreamRef, Result) ->
    logger:notice("Data receiver open."),
    receive
        {gun_data, ConnPid, StreamRef, nofin, Data} ->
            logger:notice("Received data"),
            receive_data(CallerPid, ConnPid, MRef, StreamRef, <<Result/binary, Data/binary>>);
        {gun_data, ConnPid, StreamRef, fin, Data} ->
            logger:notice("Received data done! Sending to parent process"),
            CallerPid ! {data, <<Result/binary, Data/binary>>};
        {'DOWN', MRef, process, ConnPid, Reason} ->
            error_logger:error_msg("Oops!"),
            exit(Reason)
    after 10000 ->
        error_logger:error_msg("====> TIMED OUT"),
        exit(timeout)
    end.


get(CallerPid, Host, Port, Path) ->
    logger:notice("Making request to" ++ Host ++ ":" ++ integer_to_list(Port) ++ Path),
    {ok, ConnPid} = gun:open(Host, Port),

    MRef = monitor(process, ConnPid),

    StreamRef = gun:get(ConnPid, Path),

    receive_data(self(), ConnPid, MRef, StreamRef, <<"">>),
    receive
        {data, Result} ->
            CallerPid ! {response, Result},
            gun:close(ConnPid)
    end.
