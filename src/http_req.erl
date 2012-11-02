%%%-------------------------------------------------------------------
%%% @author lengor <admin@dhcp-232-174.nomad.chalmers.se>
%%% @copyright (C) 2012, lengor
%%% @doc
%%%
%%% @end
%%% Created : 10 Oct 2012 by lengor <admin@dhcp-232-174.nomad.chalmers.se>
%%%-------------------------------------------------------------------

-module(http_req).

-include_lib("proper/include/proper.hrl").
%-include_lib("eqc/include/eqc.hrl").

-define(CallerID,"alpha").
-define(PrivateKey,"tjmzCFRyi8gGsjqEqiICoo02qUmhR6Z2HGrNHNcF").
-define(ANList,[48,49,50,51,52,53,54,55,56,57,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122]).
-compile(export_all).

start(_Place,_NoObjects)-> %% Test
%make_request(Place,NoObjects)->
    ensure_inets(),
    Unique = get_Unique(),
    Time = get_time(),
    Hash_Str = lists:append(?CallerID, lists:append(integer_to_list(Time),lists:append(?PrivateKey,Unique))),
    <<Hash:160/integer>> = get_hash(Hash_Str),
 %   {ok,{_Hmm,_Hmmm,Data}} = req("http://api.booli.se/listings",[{"q",Place},{"limit",NoObjects},{"offset","0"},{"callerId",?CallerID},{"unique",Unique},{"time",integer_to_list(Time)},{"hash",bin_hex(Hash)}]),
     {ok,{_Hmm,_Hmmm,Data}} = req("http://api.booli.se/listings",[{"q","nacka"},{"limit","3"},{"offset","0"},{"callerId",?CallerID},{"unique",Unique},{"time",integer_to_list(Time)},{"hash",bin_hex(Hash)}]), %% Test
   Data.

req(URL,L)->
    case L of 
	[] ->
	    httpc:request(URL);
	_ -> 
	    P = URL++"?",
	    reqL(L,P)
    end.

reqL([{P,V}|[]],R)->
    L = R++P++"="++V,
    httpc:request(L);

reqL([{P,V}|T],R)->
    L = R++P++"="++V++"&",
    reqL(T,L).

%% get_hash(list::integers()) ---> digest::binary() | error
get_hash(Data)->
    crypto:sha(Data).

%% 1 MegaSec = 1 000 000 Seconds, 1 000 000 MilliSec = 1 Sec
%% need to re implement with Day Light saving, UTC corrected, following day light specification.
get_time()->
    {MegS,S,MiS} = now(),
    (MegS*1000000 + S + MiS div 1000000). %% including -25 seconds to eliminate added leap seconds

get_Unique()->
    random_string(16).

%%%%%%%%%%%%% Internal Functions

bin_hex(Bin)->
    lists:flatten(io_lib:format("~40.16.0b", [Bin])).


%% Not clear weather it should be only alphanumeric or can include all ASCII values
random_string(0) ->
    [];

random_string(Length) -> 
	    [random_char() | random_string(Length-1)].

random_char() -> 
    lists:nth(random:uniform(62),?ANList) .

ensure_inets()->
    case inets:start() of 
	{error,{already_started,inets}} ->
	    ok;
	ok ->
	    ok
    end.

process_integer(Integer)->
    process_integer(Integer,[]).

process_integer(Integer,List) when Integer >=10 ->
    process_integer(Integer div 10,[Integer rem 10]++List);
process_integer(Integer,List) ->
    [Integer]++List.

%%%%%%%%%%%%%% Test Functions

prop_test_get_hash() ->
   ?FORALL(Data,list(byte()),get_hash(Data)==crypto:sha(Data)).

prop_test_length_get_unique() ->
    ?FORALL(Random,get_Unique(),length(Random)<17).

%% Not working, ask thomas or hans
%%prop_test_random_string()->
%%    ?FORALL(Random,random_string(integer(1,50)),is_list(Random)==true).
%%    ?FORALL(Random,random_string(int()),is_list(Random)).

%%Temp funs for testing

print_list([])->
    ok;
print_list([H|T])->
    io:format("~s",[[H]]),print_list(T).

print_bin(Bin)->
    io:format("~w~n",[Bin]).

%% Unused code 
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

%% Convert to hex
bin_to_hex(Bin)->
    Hex=list_to_hex(binary:bin_to_list(Bin)),
    add_perc_sign(Hex).

list_to_hex(L) ->
    lists:map(fun(X) ->  int_to_hex(X) end, L).

int_to_hex(N) when N < 256 ->
    
    [hex(N div 16), hex(N rem 16)].

hex(N) when N < 10 ->
    $0+N;

hex(N) when N >= 10, N < 16 ->
    $A + (N-10).

add_perc_sign([])->
    [];
add_perc_sign([H|T])->
    "%"++H++add_perc_sign(T).
