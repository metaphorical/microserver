-module(http_request).

-export([receive_data/5, get/4, get/2]).

% ----------------------------------------------------------------
% Receiver that handles data that is coming in form http request
% ----------------------------------------------------------------
% @param CallerPid  - PID of a parent process (in this case http request that started receiver). When receiving is done result issent to process with this pid.
% @param ConnPid - PID of a connection
% @param MRef - monitoring reference of connection process
% @param StreamRef - response request reference
% @param Result - aggregator for response data - it is tail recursion call
% ----------------------------------------------------------------
receive_data(CallerPid, ConnPid, MRef, StreamRef, Result) ->
    logger:notice("Data receiver open."),
    receive
        {gun_data, ConnPid, StreamRef, nofin, Data} ->
            % While receiving Gun will send 'nofin' atom to this process to let this process know it is not done
            % so method is called again
            logger:notice("Received data"),
            receive_data(CallerPid, ConnPid, MRef, StreamRef, <<Result/binary, Data/binary>>);
        {gun_data, ConnPid, StreamRef, fin, Data} ->
            % when whole response is received Gunn will send 'fin' atom
            % so this process can take aggregated response and send it to caller process
            logger:notice("Received data done! Sending to parent process"),
            CallerPid ! {data, <<Result/binary, Data/binary>>};
        {'DOWN', MRef, process, ConnPid, Reason} ->
            error_logger:error_msg("Oops!"),
            exit(Reason)
    after 10000 ->
        error_logger:error_msg("====> TIMED OUT"),
        exit(timeout)
    end.

% ----------------------------------------------------------------
% HTTP get request
% ----------------------------------------------------------------
% @param CallerPid  - PID of a parent process - method that is making HTTP call
% @param Host - HTTP host
% @param Port - HTTP port
% @param Path - path on host (for example "/hot")
% ----------------------------------------------------------------
get(CallerPid, Host, Port, Path) ->
    logger:notice("Making request to" ++ Host ++ ":" ++ integer_to_list(Port) ++ Path),
    {ok, ConnPid} = gun:open(Host, Port),

    MRef = monitor(process, ConnPid),

    StreamRef = gun:get(ConnPid, Path),

    % when call is initiated start data receiver to wait for response events
    receive_data(self(), ConnPid, MRef, StreamRef, <<"">>),
    receive
        % When receiver is done it will send whole response back to this handler so it can just pass it to parent process and close
        {data, Result} ->
            CallerPid ! {response, Result},
            gun:close(ConnPid)
    end.
% ----------------------------------------------------------------
% HTTP get request with dummy response
% ----------------------------------------------------------------
% @param CallerPid  - PID of a parent process - method that is making HTTP call
%
% ----------------------------------------------------------------
get(CallerPid, _) ->
        CallerPid ! {response, <<"\"message\": \"Dummy Call\"">>}.
