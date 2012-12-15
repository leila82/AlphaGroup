%% Hej

-define(Host, "localhost").
-define(Port, 5984).
-define(Prefix, "").
-define(Options, []).
-define(S, couchbeam:server_connection(?Host, ?Port, ?Prefix, ?Options)).

