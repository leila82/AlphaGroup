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

%-define(testing, true).

-define(NoObjects,200).

-define(DD_Repo,"repo_dd"). %% repository for design document

-define(Gothenburg,"gothenburg").
-define(Malmo,"malmo").
-define(Stockholm,"stockholm").

-define(Gothenburgs,"gothenburg_s").
-define(Malmos,"malmo_s").
-define(Stockholms,"stockholm_s").

-define(ViewIdall,"all").

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

-define(ViewIdi,"i").
-define(ViewId1,"1").
-define(ViewId2,"2").
-define(ViewId3,"3").





%% -define(Limit1LS,"undefined").
%% -define(Limit1HS,"undefined").
%% -define(Limit2LS,"undefined").
%% -define(Limit2HS,"undefined").
%% -define(Limit3LS,"undefined").
%% -define(Limit3HS,"undefined").
%% -define(Limit4LS,"undefined").
%% -define(Limit4HS,"undefined").
%% -define(Limit5LS,"undefined").
%% -define(Limit5HS,"undefined").

%% -define(Limit1LR,0).
%% -define(Limit1HR,3000).
%% -define(Limit2LR,3000).
%% -define(Limit2HR,6000).
%% -define(Limit3LR,6000).
%% -define(Limit3HR,12000).
%% -define(Limit4LR,12000).
%%-define(Limit4HR,"undefined"). %% Not being used in the current version
%%-define(Limit5LR,"undefined"). %% Not being used in the current version
%%-define(Limit5HR,"undefined"). %% Not being used in the current version


%%-export([create_database/1,delete_database/1,get_rdata/1,get_sdata/1]).
-compile(export_all).


create_doc(DB_Name,Doc)->
case erlang_couchdb:create_document({"127.0.0.1", 5984}, DB_Name, Doc) of
    ok ->
	ok;
    {json,{struct,[{<<"error">>,<<"not_found">>},{<<"reason">>,<<"no_db_file">>}]}} ->
	throw("Application Error: an AH0bdat002 tag is thrown");
    Rev ->
	%throw("Application Error: an AH0bdat003 tag is thrown")
	Rev
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

%% compaction is triggered, for elements and views
compact_database(DB_Name)->
    Uri = "/"++DB_Name++"/_compact",
    erlang_couchdb:raw_request("POST",?DB_IP,?DB_PN,Uri,[]).

get_alldocs(DB_Name) when is_list(DB_Name)->
    Uri = "/"++DB_Name++"/_all_docs",
    erlang_couchdb:raw_request("GET",?DB_IP,?DB_PN,Uri,[]).

get_designs(DB_Name) when is_list(DB_Name)->
    Uri = "/"++DB_Name++"/_all_docs?startkey=\"_design\/\"&endkey=\"_design0\"",
    erlang_couchdb:raw_request("GET",?DB_IP,?DB_PN,Uri,[]).


%%return an empty list or a list of tuples in order {Adress,Rooms,Area,Rent}
%% @Key -> {City,Rent,NoRooms}
get_rdata({City,Rent,NoRooms})->
  %  {City,Rent,NoRooms} = Key,
    case City of 
	"Goteborg" ->
	    {json,{struct,[{<<"total_rows">>,_},{<<"offset">>,_},{<<"rows">>,List}]}} = get_rdata(?Gothenburg,Rent,NoRooms),
	    process_rlist(List);
	"Malmo" ->
	    {json,{struct,[{<<"total_rows">>,_},{<<"offset">>,_},{<<"rows">>,List}]}} = get_rdata(?Malmo,Rent,NoRooms),
	    process_rlist(List);
	"Stockholm" ->
	    {json,{struct,[{<<"total_rows">>,_},{<<"offset">>,_},{<<"rows">>,List}]}} = get_rdata(?Stockholm,Rent,NoRooms),
	    process_rlist(List);
	"All" ->
	    {json,{struct,[{<<"total_rows">>,_},{<<"offset">>,_},{<<"rows">>,List}]}} = get_rdata(?Gothenburg,Rent,NoRooms),
	    {json,{struct,[{<<"total_rows">>,_},{<<"offset">>,_},{<<"rows">>,Listm}]}} = get_rdata(?Malmo,Rent,NoRooms),
	    process_rlist(lists:append(List,Listm));
	_ ->
	    []
%%	    {error,"feature not available yet"}
%%	    "Ooo Krishna we didn't implement it yet"
    end.

%% Discription: To stripdown JSON document notation
%% @private
process_rlist([])->
    [];
process_rlist(List) ->
    process_rlist(List,[]).

process_rlist([],AccList)->
    AccList;
process_rlist([H|T],AccList) ->
    {_,[_,_,{_,{_,List}}]} = H,
    process_rlist(T,[{binary:bin_to_list(proplists:get_value(<<"Adress">>,List,<<"undefined">>)),
    proplists:get_value(<<"Rooms">>,List,"undefined"),
    binary:bin_to_list(proplists:get_value(<<"District">>,List,<<"undefined">>)),
    proplists:get_value(<<"Rent">>,List,"undefined")}|AccList]).


%% @Key -> {City,Rent,NoRooms}
get_sdata({City,Rent,Price,NoRooms})->
  %  {City,Rent,NoRooms} = Key,
    case City of 
	"Göteborg" ->
	    get_sdata(?Gothenburg,Rent,Price,NoRooms);
	"Malmö" ->
	    get_sdata(?Malmo,Rent,Price,NoRooms);
	"Stockholm" ->
	     get_sdata(?Stockholm,Rent,Price,NoRooms);
	_ ->
	    {error,"feature not available yet"}
%%	    "Ooo Krishna we didn't implement it yet"
    end.

%% UI update, Sell rent should be mentioned to only with max rent

get_sdata(City,MaxRent,Price,NoRooms)->
    %% invoke booli api here 
    case catch json_handler:decode_string(booli:make_request(City,?NoObjects,MaxRent,Price,NoRooms)) of
	{'EXIT',function_clause}->
	   [];
	{'EXIT',"invalid data input of JSON string in decode_string"} ->
	    [];
	[H|T] ->
	    [H|T];
	_ ->
	    []
    end.


get_rdata(City,"0","0") ->
    erlang_couchdb:invoke_view({?DB_IP,?DB_PN},City,?ViewClass,?ViewIdall,[]);

get_rdata(City,Rent,NoRooms) when Rent>0,Rent<3001,NoRooms>3->
    erlang_couchdb:invoke_view({?DB_IP,?DB_PN},City,?ViewClass,?ViewId03i,[]);
get_rdata(City,Rent,NoRooms) when Rent>0,Rent<3001,NoRooms==1->
    erlang_couchdb:invoke_view({?DB_IP,?DB_PN},City,?ViewClass,?ViewId031,[]);
get_rdata(City,Rent,NoRooms) when Rent>0,Rent<3001,NoRooms==2->
    erlang_couchdb:invoke_view({?DB_IP,?DB_PN},City,?ViewClass,?ViewId032,[]);
get_rdata(City,Rent,NoRooms) when Rent>0,Rent<3001,NoRooms==3->
    erlang_couchdb:invoke_view({?DB_IP,?DB_PN},City,?ViewClass,?ViewId033,[]);
get_rdata(City,Rent,_NoRooms) when Rent>0,Rent<3001->
    erlang_couchdb:invoke_view({?DB_IP,?DB_PN},City,?ViewClass,?ViewId03,[]);

get_rdata(City,Rent,NoRooms) when Rent>3000,Rent<6001,NoRooms>3->
    erlang_couchdb:invoke_view({?DB_IP,?DB_PN},City,?ViewClass,?ViewId36i,[]);
get_rdata(City,Rent,NoRooms) when Rent>3000,Rent<6001,NoRooms==1->
    erlang_couchdb:invoke_view({?DB_IP,?DB_PN},City,?ViewClass,?ViewId361,[]);
get_rdata(City,Rent,NoRooms) when Rent>3000,Rent<6001,NoRooms==2->
    erlang_couchdb:invoke_view({?DB_IP,?DB_PN},City,?ViewClass,?ViewId362,[]);
get_rdata(City,Rent,NoRooms) when Rent>3000,Rent<6001,NoRooms==3->
    erlang_couchdb:invoke_view({?DB_IP,?DB_PN},City,?ViewClass,?ViewId363,[]);
get_rdata(City,Rent,_NoRooms) when Rent>3000,Rent<6001->
    erlang_couchdb:invoke_view({?DB_IP,?DB_PN},City,?ViewClass,?ViewId36,[]);

get_rdata(City,Rent,NoRooms) when Rent>6000,Rent<12001,NoRooms>3->
    erlang_couchdb:invoke_view({?DB_IP,?DB_PN},City,?ViewClass,?ViewId612i,[]);
get_rdata(City,Rent,NoRooms) when Rent>6000,Rent<12001,NoRooms==1->
    erlang_couchdb:invoke_view({?DB_IP,?DB_PN},City,?ViewClass,?ViewId6121,[]);
get_rdata(City,Rent,NoRooms) when Rent>6000,Rent<12001,NoRooms==2->
    erlang_couchdb:invoke_view({?DB_IP,?DB_PN},City,?ViewClass,?ViewId6122,[]);
get_rdata(City,Rent,NoRooms) when Rent>6000,Rent<12001,NoRooms==3->
    erlang_couchdb:invoke_view({?DB_IP,?DB_PN},City,?ViewClass,?ViewId6123,[]);
get_rdata(City,Rent,_NoRooms) when Rent>6000,Rent<12001->
    erlang_couchdb:invoke_view({?DB_IP,?DB_PN},City,?ViewClass,?ViewId612,[]);

get_rdata(City,Rent,NoRooms) when Rent>12000,NoRooms>3->
    erlang_couchdb:invoke_view({?DB_IP,?DB_PN},City,?ViewClass,?ViewId12i,[]);
get_rdata(City,Rent,NoRooms) when Rent>12000,NoRooms==1->
    erlang_couchdb:invoke_view({?DB_IP,?DB_PN},City,?ViewClass,?ViewId121,[]);
get_rdata(City,Rent,NoRooms) when Rent>12000,NoRooms==2->
    erlang_couchdb:invoke_view({?DB_IP,?DB_PN},City,?ViewClass,?ViewId122,[]);
get_rdata(City,Rent,NoRooms) when Rent>12000,NoRooms==3->
    erlang_couchdb:invoke_view({?DB_IP,?DB_PN},City,?ViewClass,?ViewId123,[]);
get_rdata(City,Rent,_NoRooms) when Rent>12000->
    erlang_couchdb:invoke_view({?DB_IP,?DB_PN},City,?ViewClass,?ViewId12,[]);

get_rdata(City,_Rent,NoRooms) when NoRooms>3->
    erlang_couchdb:invoke_view({?DB_IP,?DB_PN},City,?ViewClass,?ViewIdi,[]);
get_rdata(City,_Rent,NoRooms) when NoRooms==1->
    erlang_couchdb:invoke_view({?DB_IP,?DB_PN},City,?ViewClass,?ViewId1,[]);
get_rdata(City,_Rent,NoRooms) when NoRooms==2->
    erlang_couchdb:invoke_view({?DB_IP,?DB_PN},City,?ViewClass,?ViewId2,[]);
get_rdata(City,_Rent,NoRooms) when NoRooms==3->
    erlang_couchdb:invoke_view({?DB_IP,?DB_PN},City,?ViewClass,?ViewId3,[]).



%%@private
process_n_delete(_,[])->
    ok;

process_n_delete(DB_Name,[{struct,H}|T])->
    [{_,ID},{_,_Key},{_,{struct,[{_,Rev}]}}] = H,
    erlang_couchdb:delete_document({?DB_IP,?DB_PN},DB_Name,ID,Rev),
    process_n_delete(DB_Name,T).


update_code()->
    ok.
