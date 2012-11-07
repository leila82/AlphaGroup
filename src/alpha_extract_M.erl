%%%-------------------------------------------------------------------
%%% @author  Ivanka Ivanova
%%% @copyright (C) 2012, 
%%% @doc
%%% 
%%% Module extracting information about rental apartments
%%% in Malmö 
%%%
%%% @end
%%% Created :  2 Nov 2012 by Ivanka Ivanova
%%%-------------------------------------------------------------------
-module(alpha_extract_M).
-export([download/0]).

%% -record(rental, {rooms,area,rent,address,district}).
-include("alpha_records.hrl").


download() ->
    inets:start(),
    ssl:start(),
    {ok, {{_,200,_}, _, Body}} = 
	httpc:request("http://www.boplatssyd.se/lagenheter"),
    extract(Body).

%% The start and the end tag of a row in the table
%% with the contents that we are interested in.
start_tr_tag() -> {"<tr class=\"odd\">", "<tr class=\"even\">"}.
end_tr_tag() -> "</tr>".

%% The start and the end tag of each cell in the row
%% with the contents that we are interested in.
start_td_tag() -> "<td".
end_td_tag() -> "</td>".

extract(Body) ->
    cleanup(records(Body)).

%% This is a helper function that checks whether
%% the first element is prefix of the second one and 
%% returns ok and what is left after the prefix.
prefix([], XS) ->
    {ok,XS};
prefix([X|XS1],[X|XS2]) ->
    prefix(XS1,XS2);
prefix(_,_) ->
    error.


%% The function returns as a final result
%% the string before and the string after the tag.
break(Tag,[]) ->
    {[],[]};
break(Tag,XS) ->
    case prefix(Tag,XS) of
        {ok, XS1} -> {[],XS1};
	error     -> [X|XS1] = XS,
		     {TS,XS2} = break(Tag,XS1),
		     {[X|TS],XS2}
    end.    

%% The function after receiving the start and end tag
%% of a row in the table, 
%% with the contents that we are interested in,
%% breaks the source code into rows and creates
%% a list of lists, where the elements of the lists
%% are strings, containing the information we need.
records([]) ->
    [];
records(Body) ->
    {Tag1,Tag2} = start_tr_tag(),
    case prefix(Tag1, Body) of
	{ok, Body1} ->
	    {TS,Body2} = break(end_tr_tag(),Body1),
            [fields(TS) | records(Body2)];
        error -> case prefix(Tag2, Body) of
	           {ok, Body1} ->
	               {TS,Body2} = break(end_tr_tag(),Body1),
                       [fields(TS) | records(Body2)];
	           error ->
	               [_ | Body1] = Body,
	               records(Body1)
                 end
    end.

%% The function after receiving the start and end tag
%% of a cell in a table row, 
%% with the contents that we are interested in,
%% breaks the source code into list of strings
%% (one string for each cell). 
fields([]) ->
    [];
fields(Body) ->
    case prefix(start_td_tag(), Body) of
	{ok, Body1} ->
            {_ ,Body2} = break(">",Body1),
	    {TS,Body3} = break(end_td_tag(),Body2),
            [TS | fields(Body3)];
        error ->
	    [_ | Body1] = Body,
	    fields(Body1)
    end.

cleanup([])->
    [];
cleanup([R|RS])->
    [Rooms,Area,Rent,Address,_,_,_,District,_,_,_,_] = R,
    RR = #rental{rooms=cleanRooms(Rooms),
                 area=cleanArea(Area),
                 rent=cleanRent(Rent),
                 address=cleanAddress(Address),
                 district=District},
    [RR | cleanup(RS)].

cleanRooms(S)->
    {X,_} = break(":a",S),
    {Y,_} = string:to_integer(X),
    Y.

cleanArea(S)->
    {X,_} = break(" m&sup2;",S),
    {Y,_} = string:to_integer(X),
    Y.

cleanRent(S)->
    {X,_} = break(" kr",S),
    {Y,_} = string:to_integer(unwords(X)),
    Y.

cleanAddress(S)->
    {_,X} = break(">",S),
    {Y,_} = break("<",X),
    Y.

unwords([]) ->
    [];
unwords([32|CS]) ->
    unwords(CS);
unwords([C|CS]) ->
    [C|unwords(CS)].
