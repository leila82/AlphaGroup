%%%-------------------------------------------------------------------
%%% @author lengor <admin@dhcp-232-174.nomad.chalmers.se>
%%% @copyright (C) 2012, lengor
%%% @doc
%%% The Module provides basic function to search a webwebsite(http://www.booli.se) for Available appartments, in specific areas in Sweden.
%%% @end
%%% Created : 10 Oct 2012 by lengor <admin@dhcp-232-174.nomad.chalmers.se>
%%%-------------------------------------------------------------------
-module(http_req).

-include_lib("proper/include/proper.hrl").
%-include_lib("eqc/include/eqc.hrl").

-define(CallerID,alpha).
-define(PrivateKey,tjmzCFRyi8gGsjqEqiICoo02qUmhR6Z2HGrNHNcF).
%-define(ANList,["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","1","2","3","4","5","6","7","8","9","0"]).
%-define(ANList,[a,b,c]).
-define(ANList,[48,49,50,51,52,53,54,55,56,57,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122]).

-compile(export_all).


%% Tweeks needed, Documentation will be availabe soon.
start(_Place,_NoObjects)->
%    inets:start(),
    Unique = get_Unique(),
    Time = get_time(),
    Hash = io_lib:format("~p~p~p~s",[?CallerID,Time,?PrivateKey,Unique]),
    Req = io_lib:format("http://api.booli.se/listings?q=GÖTEBORG&limit=10&offset=0&callerId=~p&time=~p&unique=~s&Hash=~s",[?CallerID,Time,Unique,binary_to_list(get_hash(Hash))]),
%    Req = Req_a,
    httpc:request(Req).
%    io:format("~s~n",[Req]).

%% Returns a 20 bit hash, for the data feeded through 'Data'.
%% get_hash(list::integers()) ---> digest::binary() | error
get_hash(Data)->
    crypto:sha(Data).

%%  Returns the UTC time, Currently depends on Underlying Operating System
%%% Developer Notes : 
%%  1 MegaSec = 1 000 000 Seconds, 1 000 000 MilliSec = 1 Sec
%%  need to re implement with Day Light saving, UTC corrected, following day light specification.
get_time()->
    {MegS,S,MiS} = now(),
    MegS*1000000 + S + MiS div 1000000.

%% Returns a 'unique'[1] 16 bit length string.
get_Unique()->
   random_string(16).

%%%%%%%%%%%%% Internal Functions

%% Ignore, will be used in next versions of the system development

insert_esc_char([])->
    [];
insert_esc_char([H|T]) ->
    insert_esc_char([H|T],[]).

insert_esc_char([],List)->
    lists:reverse(List);
insert_esc_char([34|T],List) ->
    TList = [92|List],
    insert_esc_char(T,[34|TList]);
insert_esc_char([H|T],List) ->
    insert_esc_char(T,[H|List]).


%% Function generates a unique bit of length 'Length'. Uses ?ANList defined macro
%% Developer Notes: Not clear weather it should be only alphanumeric or can include all ASCII values
random_string(0) ->
    [];

random_string(Length) -> 
	    [random_char() | random_string(Length-1)].

random_char() -> 
    lists:nth(random:uniform(62),?ANList) .
%% Test fun line
%    lists:nth(random:uniform(3),?ANList) .   
%%%%%%%%%%%%%% Test Functions

prop_test_get_hash() ->
   ?FORALL(Data,list(byte()),get_hash(Data)==crypto:sha(Data)).

prop_test_length_get_unique() ->
    ?FORALL(Random,get_Unique(),length(Random)<17).

%% Not working, ask thomas or hans
%prop_test_random_string()->
%    ?FORALL(Random,random_string(integer(1,50)),is_list(Random)==true).
%    ?FORALL(Random,random_string(int()),is_list(Random)).

