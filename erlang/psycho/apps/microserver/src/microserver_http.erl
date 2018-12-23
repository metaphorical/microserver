-module(microserver_http).
-export([start_link/0, app/1]).

-define(port, 8003).

start_link() ->
    psycho_server:start(?port, ?MODULE, []).

app(Env) ->
    Body = io_lib:format("~p", [Env]),
    ok(Body).

ok(Body) ->
        {{200, "OK"}, [{"Content-Type", "text/plain"}], Body}.
