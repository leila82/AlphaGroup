-module(activity).
-author("Gokul").
-include("../include/alpha_records.hrl").
%-import(alpha_extract_M.erl,[download/0]).
%-import("../src/boplats.erl",[main/0]).
-define(DB_IP,"127.0.0.1"). %% Data base IP adress
-define(DB_PN,"5984"). %% Data base Port Number
-compile(export_all).

%% This module is for yaws.conf file to include in runmod.
%% When an yaws server is been started -
%% -(assuming yaws.conf file has a key 'runmod' set to value 'activity')


start()->
    %% TODO - Check couchdb status on local server(is it running?)
    %%     - if started proceed with 2
    %%     2- Get all the data from sources (for all five cities)
    %%     - check the rent/sell status
    %%     - sort everything according to rent/sell status
    %%     - create data accoring to json object notation and update it[2A]
    %%     - [2A] data in format key:Objects Value:a tuple of objects [{Address1,Rent1,Price1,etcetc},{Address2,Rent2,...},...]
    %% Currently donsnt have idea about ho to chec the availability of data bse server 
    %% So implementing from stage 2
    
    %% Get data from all the sources
    io:format("started"),
    receive 
    after 86400000 ->
	    get_data()
    end.


%%[Done]
%% Got data form boplats and alpha_extract_M
%%[Done]
%%[Done]
%% Get data from booli
%%[Now]
%% invokes all the modules functions which returns a list of records of objects and returns 
%% A list with all the objects

%% Future implementations, should return all the values with no duplicates.
get_data()->
   %% L1 = alpha_extract_M:download(), %% Expected to return a list of records rental [Malmo]
   %% L2 = boplats:main(), %% Expected to return a list of records rental [Gothenburg] 
     http_req:make_request("Göteborg",100).
   % BList = lists:append(L1,L2),
   %% AList = lists:append(L3,BList),
   %% push_to_db(AList).
   %% push_to_db(L2).
%%    d_push(L2,[]).
d_push([],List)->
    List;

d_push([H|_T],_List) ->
    
    Rent = H#rental.rent,
    Rooms = H#rental.rooms,
    Area = H#rental.area,
    Adress = H#rental.address,
    District = H#rental.district,
    _Doc = [{<<"Adress">>, Adress},
	   {<<"District">>, District},
	   {<<"Rent">>, Rent},
	   {<<"Rooms">>, Rooms},
	    {<<"Area">>, Area}],
unicode:characters_to_binary(District,latin1,utf8).
%    unicode:bom_to_encoding(list_to_binary(District)).
%    District.

%erlang_couchdb:create_document({"127.0.0.1", 5984}, "proto_v1", Doc).
%        d_push(T,[Doc|List]).
   

push_to_db([])->
    ok;
push_to_db([H|T]) ->
    Rent = H#rental.rent,
    Rooms = H#rental.rooms,
    Area = H#rental.area,
    Adress = H#rental.address,
    District = H#rental.district,
    Doc = [{<<"Adress">>,  unicode:characters_to_binary(Adress,latin1,utf8)},
	   {<<"District">>, unicode:characters_to_binary(District,latin1,utf8)},
	   {<<"Rent">>, Rent},
	   {<<"Rooms">>, Rooms},
	   {<<"Area">>, Area}],

    erlang_couchdb:create_document({"127.0.0.1", 5984}, "proto_v2", Doc),
    push_to_db(T).


%%     Rent = list_to_binary(integer_to_list(H#rental.rent)),
%%     Rooms =list_to_binary(integer_to_list( H#rental.rooms)),
%%     Area = list_to_binary(integer_to_list(H#rental.area)),

%%     Rent = H#rental.rent,
%%     Rooms = H#rental.rooms,
%%     Area = H#rental.area,


%%     Doc = [{<<"Adress">>, list_to_binary(H#rental.address)},
%% 	   {<<"District">>, list_to_binary(H#rental.district)},
%% 	   {<<"Rent">>, Rent},
%% 	   {<<"Rooms">>, Rooms},
%% 	   {<<"Area">>, Area}],    


%%
update_database()->
    get_data().
