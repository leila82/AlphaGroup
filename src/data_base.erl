%% Authors : Leila, Suzan, Gokul


%% Module developed according to the specific specification for Alpha housing
%% Not a general module

-module(data_base).
%% Assuming database server is running on a local host under ip adress "127.0.0.1"
%% and port number "5984"
-define(DB_IP,"127.0.0.1"). %% Data base IP adress
-define(DB_PN,5984). %% Data base Port Number
%%-compile([create_database/1]).
-compile(export_all).


%% @spec create_database(DBServer::server_address(), Database::string()) ->  ok | {error, Reason::any()}
%%
%% @type server_address() = {Host::string(), ServerPort::integer()}
%%
%% @doc Create a new database.
%% DB_Name = name of the data base you want to create
create_database(DB_Name) when is_list(DB_Name)->
        erlang_couchdb:create_database({?DB_IP, ?DB_PN}, DB_Name).


%% @spec create_database(DBServer::server_address(), Database::string()) ->  ok | {error, Reason::any()}
%%
%% @type server_address() = {Host::string(), ServerPort::integer()}
%%
%% @doc deleting only the docs in data base with out deleting views.
delete_database(DB_Name)->
%% list_ad list of all documents, list_dd list of design documents
    {_,{_,[_,_,{_,List_ad}]}} = get_alldocs(DB_Name),
    {_,{_,[_,_,{_,List_dd}]}} = get_designs(DB_Name),
    %% List_OO lists with Only Objects (with id key value)
    List_OO = lists:subtract(List_ad,List_dd),
    process_n_delete(DB_Name,List_OO).

get_alldocs(DB_Name) when is_list(DB_Name)->
    Uri = "/"++DB_Name++"/_all_docs",
    erlang_couchdb:raw_request("GET",?DB_IP,?DB_PN,Uri,[]).

get_designs(DB_Name) when is_list(DB_Name)->
    Uri = "/"++DB_Name++"/_all_docs?startkey=\"_design\/\"&endkey=\"_design0\"",
    erlang_couchdb:raw_request("GET",?DB_IP,?DB_PN,Uri,[]).

get_gothenburg_rdata()->
    [].

get_gothenburg_sdata()->
    [].


%% @Key -> {City,Rent,Sqmets,NoRooms}
get_data(_Key)->
    ok.

process_n_delete(_,[])->
    ok;

process_n_delete(DB_Name,[{struct,H}|T])->
    [{_,ID},{_,_Key},{_,{struct,[{_,Rev}]}}] = H,
    erlang_couchdb:delete_document({?DB_IP,?DB_PN},DB_Name,ID,Rev),
    process_n_delete(DB_Name,T).
