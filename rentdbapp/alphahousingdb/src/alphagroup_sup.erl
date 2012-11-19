
-module(alphagroup_sup).

-behaviour(supervisor).
%% API
-export([start_link/0,
         start_child/0,
         terminate_child/1]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(SERVER, ?MODULE).
%%-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================
-spec start_link() -> {ok, pid()} | any().

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

start_child() ->
    supervisor:start_child(?SERVER, []).

terminate_child(PID) ->
    couch_db:terminate(PID).


%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

-spec init(list()) -> {ok, {SupFlags::any(), [ChildSpec::any()]}} |
                       ignore | {error, Reason::any()}.
init([]) ->
    RestartStrategy = simple_one_for_one,
    MaxRestarts = 0,
    MaxSecondsBetweenRestarts = 1,

    SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},

    Restart = temporary,
    Shutdown = 2000,
    Type = worker,

    {ok, Server} = application:get_env(server),
    {ok, Port} = application:get_env(port),
    {ok, DB} = application:get_env(database),

    AChild = {couch_db, {couch_db, start_link, [Server, Port, DB]},
              Restart, Shutdown, Type, [couch_db]},

    {ok, {SupFlags, [AChild]}}.
