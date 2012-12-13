-module(activity).
-author("Gokul").
-include("../include/alpha_records.hrl").
%-import(alpha_extract_M.erl,[download/0]).
%-import("../src/boplats.erl",[main/0]).
-define(DB_IP,"127.0.0.1"). %% Data base IP adress
-define(DB_PN,"5984"). %% Data base Port Number

-define(Gothenburg,"gothenburg").
-define(Malmo,"malmo").
-define(Stockholm,"stockholm").

-compile(export_all).

%% This module is for yaws.conf file to include in runmod.
%% When an yaws server is been started -
%% -(assuming yaws.conf file has a key 'runmod' set to value 'activity')

%% TODO - Check couchdb status on local server(is it running?)
    %%     - if started proceed with 2
    %%     2- Get all the data from sources (for all five cities)
    %%     - check the rent/sell status
    %%     - sort everything according to rent/sell status
    %%     - create data accoring to json object notation and update it[2A]
    %%     - [2A] data in format key:Objects Value:a tuple of objects [{Address1,Rent1,Price1,etcetc},{Address2,Rent2,...},...]
    %% Currently donsnt have idea about ho to chec the availability of data bse server 
    %% So implementing from stage 2



%%Update TODO
%%-- get data from four extract modules from 4 cities, store them accordingly

%% @Spec start()->

%%Spawn register needed to be done to use receive thingy
start()->
    update_database(),
    start(0).

start(Num) when Num <2 ->
    case lists:member(alpha_activity,registered()) of
	true ->
	 catch  alpha_activity ! {stop,user},
	    start(Num+1);
	false ->
	    register(alpha_activity,spawn(?MODULE,loop,[]))
    end;
start(_) ->
    throw("Application Error: an AH0bact001 tag is thrown").

stop()->
    catch  alpha_activity ! {stop,user},
    io:format("hello").

loop()->
    receive 
	{update,user}->
	    get_and_put_data(),
	    loop();
	{stop,user}->
	    ok
%%       after 60000 ->  %%test
    after 86400000 -> 
	    get_and_put_data(),
	    loop()
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
get_and_put_data()->
    data_base:delete_database(?Malmo),
    spawn(data_base,compact_database,[?Malmo]),
    data_base:delete_database(?Gothenburg),
    spawn(data_base,compact_database,[?Gothenburg]),
  %% Expected to return a list of records rental [Malmo]
  %% Expected to return a list of records rental [Gothenburg]
    spawn(?MODULE,push_to_db,[?Malmo,alpha_extract_M:download()]),
    spawn(?MODULE,push_to_db,[?Gothenburg,boplats:main()]).

push_to_db(_DB_Name,[])->
    ok;
push_to_db(DB_Name,[H|T]) ->
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
    data_base:create_doc(DB_Name,Doc),
    push_to_db(DB_Name,T).


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
    get_and_put_data().

update_code()->
    ok.
