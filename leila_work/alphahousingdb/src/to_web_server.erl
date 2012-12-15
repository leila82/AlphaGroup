%% @author Leila Keza <guskezle@student.gu.se>
%% This module is created to reply the client requests.
%% Those fucions are the same for whole renting part
%% In fact, I gave all design documents the name as well as the views 
%% because they are the same since they reply 
%%to the same request: search by rooms and rent.
%%This help to reduce codes copy-paste because the query functions are similar
%% The Only difference is the content of the design documents! 
%% Since the design documents are be saved in different databases, 
%%no problem with the design and views names! However, the views/Designdocuments have
%% to be saved in the correct database because the content is different from each other
%% The only thing that will change is the database names!  

%% This method is used to send information 
%%requested to the client on the database
%% int function start by creating, 
%%filling and updating the rent databases


-module(to_web_server).

-export([init/1,
         finish_request/1,
		%% Export modules that will send the information 
		%%requested to the clients according to 
		%%rent and rooms selected


         to_json_0_3000_rooms_any/1,
		 to_json_0_3000_rooms_1_2/1,
		 to_json_0_3000_rooms_3_4/1,
		 to_json_0_3000_rooms_plus_5/1,		 
		 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		 to_json_3001_6000_rooms_any/1,
		 to_json_3001_6000_rooms_1_2/1,
		 to_json_3001_6000_rooms_3_4/1,
		 to_json_3001_6000_rooms_plus_5/1,
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		 to_json_6001_12000_rooms_any/1,
		 to_json_6001_12000_rooms_1_2/1,
		 to_json_6001_12000_rooms_3_4/1,
		 to_json_6001_12000_rooms_plus_5/1,
		 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		 to_json_plus_12001_rooms_any/1,
		 to_json_plus_12001_rooms_1_2/1,
		 to_json_plus_12001_rooms_3_4/1,
		 to_json_plus_12001_rooms_plus_5/1]).


-record(ctx, {db}).

init([]) ->
spawn(stockholm, getEtl, []),
spawn(alpha_extract_M, download,[]),
spawn(boplats, main,[]),
spawn(ex_bopunkten, start, []),
    {ok, PID} =  alphagroup_sup:start_child(),
    {ok, #ctx{db=PID}}.

%% Client reply From couchdb server
%% Prices between 0-3000, rooms from any to 5+

to_json_0_3000_rooms_any(Ctx) ->
   
           {_, All }= couch_db:rent_0_3000(Ctx#ctx.db),
		   All.
to_json_0_3000_rooms_1_2(Ctx) ->   
            {_, All }= couch_db:rent_0_3000_rm_1_2(Ctx#ctx.db),
			All.
to_json_0_3000_rooms_3_4(Ctx) ->   
            {_, All }= couch_db:rent_0_3000_rm_3_4(Ctx#ctx.db),
			All.
to_json_0_3000_rooms_plus_5(Ctx) ->
   
            {_, All }= couch_db:rent_0_3000_rm_plus_5(Ctx#ctx.db),
			All.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Client reply From couchdb server
%% Prices between 3001_6000, rooms from any to 5+

to_json_3001_6000_rooms_any(Ctx)->
	{_, All }= couch_db:rent_3001_6000(Ctx#ctx.db),
All.

to_json_3001_6000_rooms_1_2(Ctx)->
	{_, All }= couch_db:rent_3001_6000_rm_1_2(Ctx#ctx.db),
	All.

to_json_3001_6000_rooms_3_4(Ctx)->
	{_, All }= couch_db:rent_3001_6000_rm_3_4(Ctx#ctx.db),
	All.
to_json_3001_6000_rooms_plus_5(Ctx)->
	{_, All }= couch_db:rent_3001_6000_rm_plus_5(Ctx#ctx.db),
	All.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Client reply From couchdb server
%% Prices between 6001_12000, rooms from any to 5+

to_json_6001_12000_rooms_any(Ctx)->
	{_, All }= couch_db:rent_6001_12000(Ctx#ctx.db),
	All.
to_json_6001_12000_rooms_1_2(Ctx)->
	{_, All }= couch_db:rent_6001_12000_rm_1_2(Ctx#ctx.db),
	All.
to_json_6001_12000_rooms_3_4(Ctx)->
	{_, All }= couch_db:rent_6001_12000_rm_3_4(Ctx#ctx.db),
	All.
to_json_6001_12000_rooms_plus_5(Ctx)->
	{_, All }= couch_db:rent_6001_12000_rm_plus_5(Ctx#ctx.db),
	All.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Client reply From couchdb server
%% Prices >_12000, rooms from any to 5+

to_json_plus_12001_rooms_any(Ctx)->
	{_, All }= couch_db:rent_plus_12001(Ctx#ctx.db),
All.
to_json_plus_12001_rooms_1_2(Ctx)->
	{_, All }= couch_db:rent_plus_12001_rm_1_2(Ctx#ctx.db),
		All.
to_json_plus_12001_rooms_3_4(Ctx)->
	{_, All }= couch_db:rent_plus_12001_rm_3_4(Ctx#ctx.db),
	All.
	to_json_plus_12001_rooms_plus_5(Ctx)->
	{_, All }= couch_db:rent_plus_12001_rm_plus_5(Ctx#ctx.db),	
	All.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
finish_request(Ctx) ->
    alphagroup_sup:terminate_child(Ctx#ctx.db),
    {true, Ctx}.
            

