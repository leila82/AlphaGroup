%% Authors : Leila, Suzan, Gokul


%% Module developed according to the specific specification for Alpha housing
%% Not a general module
-module(data_base).
%% Assuming database server is running on a local host under ip adress "127.0.0.1"
%% and port number "5984"

-define(DB_IP,"127.0.0.1"). %% Data base IP adress
-define(DB_PN,5984). %% Data base Port Number
-define(ViewClass,"class").
%% View id need to be defined according to the quiry made so all the maps needed to be listed here.
%% Test
-define(ViewId612,"612").
-define(ViewId612i,"612i").
-define(ViewId6121,"6121").
-define(ViewId6122,"6122").
-define(ViewId6123,"6123").

-define(ViewId03,"03").
-define(ViewId03i,"03i").
-define(ViewId031,"031").
-define(ViewId032,"032").
-define(ViewId033,"033").

-define(ViewId12,"12").
-define(ViewId12i,"12i").
-define(ViewId121,"121").
-define(ViewId122,"122").
-define(ViewId123,"123").

-define(ViewId36,"36").
-define(ViewId36i,"36i").
-define(ViewId361,"361").
-define(ViewId362,"362").
-define(ViewId363,"363").

%%-compile([create_database/1]).
-compile(export_all).


%% @Key -> {City,Rent,NoRooms}
get_data({City,Rent,NoRooms})->
  %  {City,Rent,NoRooms} = Key,
    case City of 
	"Göteborg" ->
	    get_gothenburg_rdata(Rent,NoRooms);
	_ ->
		"Ooo Krishna we didn't implement it yet"
    end.

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



get_gothenburg_rdata(Rent,NoRooms) when Rent>6000,Rent<12000,NoRooms>3->
    erlang_couchdb:invoke_view({?DB_IP,?DB_PN},"gothenburg",?ViewClass,?ViewId612i,[]);
get_gothenburg_rdata(Rent,NoRooms) when Rent>6000,Rent<12000,NoRooms==1->
    erlang_couchdb:invoke_view({?DB_IP,?DB_PN},"gothenburg",?ViewClass,?ViewId6121,[]);
get_gothenburg_rdata(Rent,NoRooms) when Rent>6000,Rent<12000,NoRooms==2->
    erlang_couchdb:invoke_view({?DB_IP,?DB_PN},"gothenburg",?ViewClass,?ViewId6122,[]);
get_gothenburg_rdata(Rent,NoRooms) when Rent>6000,Rent<12000,NoRooms==3->
    erlang_couchdb:invoke_view({?DB_IP,?DB_PN},"gothenburg",?ViewClass,?ViewId6123,[]);
get_gothenburg_rdata(Rent,_NoRooms) when Rent>6000,Rent<12000->
    erlang_couchdb:invoke_view({?DB_IP,?DB_PN},"gothenburg",?ViewClass,?ViewId612,[]);


get_gothenburg_rdata(Rent,NoRooms) when Rent>0,Rent<3000,NoRooms>3->
    erlang_couchdb:invoke_view({?DB_IP,?DB_PN},"gothenburg",?ViewClass,?ViewId03i,[]);
get_gothenburg_rdata(Rent,NoRooms) when Rent>0,Rent<3000,NoRooms==1->
    erlang_couchdb:invoke_view({?DB_IP,?DB_PN},"gothenburg",?ViewClass,?ViewId031,[]);
get_gothenburg_rdata(Rent,NoRooms) when Rent>0,Rent<3000,NoRooms==2->
    erlang_couchdb:invoke_view({?DB_IP,?DB_PN},"gothenburg",?ViewClass,?ViewId032,[]);
get_gothenburg_rdata(Rent,NoRooms) when Rent>0,Rent<3000,NoRooms==3->
    erlang_couchdb:invoke_view({?DB_IP,?DB_PN},"gothenburg",?ViewClass,?ViewId033,[]);
get_gothenburg_rdata(Rent,_NoRooms) when Rent>0,Rent<3000->
    erlang_couchdb:invoke_view({?DB_IP,?DB_PN},"gothenburg",?ViewClass,?ViewId03,[]);


get_gothenburg_rdata(Rent,NoRooms) when Rent>12000,NoRooms>3->
    erlang_couchdb:invoke_view({?DB_IP,?DB_PN},"gothenburg",?ViewClass,?ViewId12i,[]);
get_gothenburg_rdata(Rent,NoRooms) when Rent>12000,NoRooms==1->
    erlang_couchdb:invoke_view({?DB_IP,?DB_PN},"gothenburg",?ViewClass,?ViewId121,[]);
get_gothenburg_rdata(Rent,NoRooms) when Rent>12000,NoRooms==2->
    erlang_couchdb:invoke_view({?DB_IP,?DB_PN},"gothenburg",?ViewClass,?ViewId122,[]);
get_gothenburg_rdata(Rent,NoRooms) when Rent>12000,NoRooms==3->
    erlang_couchdb:invoke_view({?DB_IP,?DB_PN},"gothenburg",?ViewClass,?ViewId123,[]);
get_gothenburg_rdata(Rent,_NoRooms) when Rent>12000->
    erlang_couchdb:invoke_view({?DB_IP,?DB_PN},"gothenburg",?ViewClass,?ViewId12,[]);


get_gothenburg_rdata(Rent,NoRooms) when Rent>3000,Rent<6000,NoRooms>3->
    erlang_couchdb:invoke_view({?DB_IP,?DB_PN},"gothenburg",?ViewClass,?ViewId36i,[]);
get_gothenburg_rdata(Rent,NoRooms) when Rent>3000,Rent<6000,NoRooms==1->
    erlang_couchdb:invoke_view({?DB_IP,?DB_PN},"gothenburg",?ViewClass,?ViewId361,[]);
get_gothenburg_rdata(Rent,NoRooms) when Rent>3000,Rent<6000,NoRooms==2->
    erlang_couchdb:invoke_view({?DB_IP,?DB_PN},"gothenburg",?ViewClass,?ViewId362,[]);
get_gothenburg_rdata(Rent,NoRooms) when Rent>3000,Rent<6000,NoRooms==3->
    erlang_couchdb:invoke_view({?DB_IP,?DB_PN},"gothenburg",?ViewClass,?ViewId363,[]);
get_gothenburg_rdata(Rent,_NoRooms) when Rent>3000,Rent<6000->
    erlang_couchdb:invoke_view({?DB_IP,?DB_PN},"gothenburg",?ViewClass,?ViewId36,[]).


get_gothenburg_sdata()->
    ok.



%%@private
process_n_delete(_,[])->
    ok;

process_n_delete(DB_Name,[{struct,H}|T])->
    [{_,ID},{_,_Key},{_,{struct,[{_,Rev}]}}] = H,
    erlang_couchdb:delete_document({?DB_IP,?DB_PN},DB_Name,ID,Rev),
    process_n_delete(DB_Name,T).
