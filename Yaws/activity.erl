-module(activity).
-author("Gokul").
-define(DB_IP,"127.0.0.1"). %% Data base IP adress
-define(DB_PN,"5984"). %% Data base Port Number
-compile(export_all).

%% This module is for yaws.conf file to include in runmod.
%% When an yaws server is been started -
%% -(assuming yaws.conf file has a key 'runmod' set to value 'activity')


start()->
%%TODO - Check couchdb status on local server(is it running?)
    %% - if started proceed with 2
    %%2- Get all the data from sources (for all five cities)
    %% - check the rent/sell status
    %% - sort everything according to rent/sell status
    %% - create data accoring to json object notation and update it[2A]
    %% - [2A] data in format key:Objects Value:a tuple of objects [{Address1,Rent1,Price1,etcetc},{Address2,Rent2,...},...]
%% Currently donsnt have idea about ho to chec the availability of data bse server 
%% So implementing from stage 2

%% Get data from all the sources


    ok.


%% invokes all the modules functions which returns a list of records of objects and returns 
%% A list with all the objects

%% Future implementations, should return all the values with no duplicates.
get_data()->
    ok.

%% what?
