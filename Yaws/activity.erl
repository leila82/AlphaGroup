-module(activity).
-author("Gokul").
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
    ok.


%%[Done]
%% Got data form boplats and alpha_extract_M
%%[Done]
%%[Now]
%% Get data from booli
%%[Now]
%% invokes all the modules functions which returns a list of records of objects and returns 
%% A list with all the objects

%% Future implementations, should return all the values with no duplicates.
get_data()->
    L1 = alpha_extract_M:download(), %% Expected to return a list of records rental
    L2 = boplats:main(), %% Expected to return a list of records rental    
    AList = lists:append(L1,L2),
%% method() head|get| put | post | trace | options | delete
%    Profile = {profile,},
push_to_db(AList).
%% Doing integration with the help of leila

%%     httpc:request(lists:append(lists:append(?DB_IP,":"),?DB_PN),).



push_to_db([])->
    ok;
push_to_db([H|T]) ->
   Doc = [{<<"Adress">>, list_to_binary(cleanAddress(Address))},
{<<"District">>, list_to_binary(lists:append(District, " / Malmo"))},
{<<"Rent">>, list_to_binary(integer_to_list(cleanRent(Rent)))},
{<<"Rooms">>, list_to_binary(integer_to_list(cleanRooms(Rooms)))},
{<<"Area">>, list_to_binary(integer_to_list(cleanArea(Area)))}], 

push_to_db(T).
