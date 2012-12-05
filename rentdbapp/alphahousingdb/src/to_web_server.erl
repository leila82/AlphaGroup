%% @author Leila Keza <guskezle@student.gu.se>

%% This module is create to reply the client requests.
% It calls the couc

-module(to_web_server).

-export([init/1,
         finish_request/1,
         to_json_0_3000/1,
		 to_json_3001_6000/1,
		 to_json_6001_12000/1,
		 to_json_plus_12001/1]).



-record(ctx, {db}).

init([]) ->
    {ok, PID} =  alphagroup_sup:start_child(),
    {ok, #ctx{db=PID}}.

to_json_0_3000(Ctx) ->
   
            {_, All }= couch_db:rent_0_3000(Ctx#ctx.db),
									  
All.
to_json_3001_6000(Ctx)->
	{_, All }= couch_db:rent_3001_6000(Ctx#ctx.db),
									 
 All.
to_json_6001_12000(Ctx)->
	{_, All }= couch_db:rent_6001_12000(Ctx#ctx.db),
									  

All.
to_json_plus_12001(Ctx)->
	{_, All }= couch_db:rent_6001_12000(Ctx#ctx.db),
									 
 All.
finish_request(Ctx) ->
    alphagroup_sup:terminate_child(Ctx#ctx.db),
    {true, Ctx}.
            

