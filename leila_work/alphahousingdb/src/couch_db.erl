%%% -------------------------------------------------------------------
%%% %% @Author Leila Keza(<guskezle@student.gu.se>).
%%% Description :
%%%

-module(couch_db).
-include("alpha_records.hrl").
-behaviour(gen_server).

%% API
-export([start_link/3,
		
%% Export functions for the rent between 0-3000 
%%from room option:any to 5+

         rent_0_3000/1,
		 rent_0_3000_rm_1_2/1,
		 rent_0_3000_rm_3_4/1,
		 rent_0_3000_rm_plus_5/1,
		
%%Export functions for the rent between 3001_6000 
%%from room option:any to 5+

         rent_3001_6000/1,
		 rent_3001_6000_rm_1_2/1,
		 rent_3001_6000_rm_3_4/1,
		 rent_3001_6000_rm_plus_5/1,
		 
%%Export functions for the rent between 6001_12000
%%from room option:any to 5+

         rent_6001_12000/1,
		 rent_6001_12000_rm_1_2/1,
		 rent_6001_12000_rm_3_4/1,
		 rent_6001_12000_rm_plus_5/1,
		 
%%Export functions for the rent >= 12001
%%from room option:any to 5+

         rent_plus_12001/1,
		 rent_plus_12001_rm_1_2/1,
		 rent_plus_12001_rm_3_4/1,
		 rent_plus_12001_rm_plus_5/1,		        
         %%create/2, 

%% Export function that will terminate the server    
  
         terminate/1]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).
-export_type([]).

-define(SERVER, ?MODULE).

-record(rent_db, {db}).

%%%===================================================================
%%% Public Types
%%%===================================================================

%%%===================================================================
%%% API
%%%===================================================================

start_link(Server, Port, DB) ->
    gen_server:start_link(?MODULE, [Server, Port, DB], []).

%% Calls for the rent between 0-3000 from any to 5+ rooms
rent_0_3000(PID) ->
    gen_server:call(PID, rent_0_3000).
rent_0_3000_rm_1_2(PID) ->
    gen_server:call(PID, rent_0_3000_rm_1_2).
rent_0_3000_rm_3_4(PID) ->
    gen_server:call(PID, rent_0_3000_rm_3_4).
rent_0_3000_rm_plus_5(PID) ->
    gen_server:call(PID, rent_0_3000_rm_plus_5).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  %% Calls for the rent between 3001_6000 from any to 5+ rooms  

rent_3001_6000(PID) ->
    gen_server:call(PID, rent_3001_6000).
rent_3001_6000_rm_1_2(PID) ->
    gen_server:call(PID, rent_3001_6000_rm_1_2).
rent_3001_6000_rm_3_4(PID) ->
    gen_server:call(PID, rent_3001_6000_rm_3_4).
rent_3001_6000_rm_plus_5(PID) ->
    gen_server:call(PID, rent_3001_6000_rm_plus_5).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

     %% Calls for the rent between 6001_12000 from any to 5+ rooms  

rent_6001_12000(PID) ->
    gen_server:call(PID, rent_6001_12000).
rent_6001_12000_rm_1_2(PID) ->
    gen_server:call(PID, rent_6001_12000_rm_1_2).
rent_6001_12000_rm_3_4(PID) ->
    gen_server:call(PID, rent_6001_12000_rm_3_4).
rent_6001_12000_rm_plus_5(PID) ->
    gen_server:call(PID, rent_6001_12000_rm_plus_5).

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
 %% Calls for the rent > 12001 from any to 5+ rooms 
rent_plus_12001(PID) ->
    gen_server:call(PID, rent_plus_12001).
rent_plus_12001_rm_1_2(PID) ->
    gen_server:call(PID, rent_plus_12001_rm_1_2).
rent_plus_12001_rm_3_4(PID) ->
    gen_server:call(PID, rent_plus_12001_rm_3_4).
rent_plus_12001_rm_plus_5(PID) ->
    gen_server:call(PID, rent_plus_12001_rm_plus_5).


%%create(PID, Doc) ->
   %% gen_server:call(PID, {create, Doc}).
terminate(PID) ->
    gen_server:call(PID, terminate).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================


init([Server, Port, DB]) ->
    CouchServer = couchbeam:server_connection(Server, Port, "", []),
    {ok, CouchDB} = couchbeam:open_db(CouchServer, DB),
    {ok, #rent_db{db=CouchDB}}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
handle_call(rent_0_3000, _From, #rent_db{db=DB}=State) ->
    Docs = queries(DB, {"by_price_rooms", "rent_0-3000_rooms_any"},[]),
    {reply, mochijson2:encode(Docs), State};
handle_call(rent_0_3000_rm_1_2, _From, #rent_db{db=DB}=State) ->
  Docs = queries(DB, {"by_price_rooms", "rent_0-3000_rooms_1-2"},[]),
    {reply, mochijson2:encode(Docs), State};
handle_call(rent_0_3000_rm_3_4, _From, #rent_db{db=DB}=State) ->
Docs = queries(DB, {"by_price_rooms", "rent_0-3000_rooms_3-4"},[]),
    {reply, mochijson2:encode(Docs), State};
handle_call(rent_0_3000_rm_plus_5, _From, #rent_db{db=DB}=State) ->
  Docs = queries(DB, {"by_price_rooms", "rent_0-3000_rooms_plus_5"},[]),
    {reply, mochijson2:encode(Docs), State};
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

handle_call(rent_3001_6000, _From, #rent_db{db=DB}=State) ->
  Docs = queries(DB, {"by_price_rooms", "rent_3001-6000_rooms_any"},[]),
    {reply, mochijson2:encode(Docs), State};		
handle_call(rent_3001_6000_rm_1_2, _From, #rent_db{db=DB}=State) ->
 Docs = queries(DB, {"by_price_rooms", "rent_3001-6000_rooms_1-2"},[]),
    {reply, mochijson2:encode(Docs), State};
handle_call(rent_3001_6000_rm_3_4, _From, #rent_db{db=DB}=State) ->
   Docs = queries(DB, {"by_price_rooms", "rent_3001-6000_rooms_3-4"},[]),
    {reply, mochijson2:encode(Docs), State};
handle_call(rent_3001_6000_rm_plus_5, _From, #rent_db{db=DB}=State) ->
   Docs = queries(DB, {"by_price_rooms", "rent_3001-6000_rooms_plus_5"},[]),
    {reply, mochijson2:encode(Docs), State};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

handle_call(rent_6001_12000, _From, #rent_db{db=DB}=State) ->
  Docs = queries(DB, {"by_price_rooms", "rent_6001-12000_rooms_any"},[]),
    {reply, mochijson2:encode(Docs), State};
handle_call(rent_6001_12000_rm_1_2, _From, #rent_db{db=DB}=State) ->
   Docs = queries(DB, {"by_price_rooms", "rent_6001-12000_rooms_1-2"},[]),
    {reply, mochijson2:encode(Docs), State};
handle_call(rent_6001_12000_rm_3_4, _From, #rent_db{db=DB}=State) ->
 Docs = queries(DB, {"by_price_rooms", "rent_6001-12000_rooms_3-4"},[]),
    {reply, mochijson2:encode(Docs), State};
handle_call(rent_6001_12000_rm_plus_5, _From, #rent_db{db=DB}=State) ->
   Docs = queries(DB, {"by_price_rooms", "rent_6001-12000_rooms_plus_5"},[]),
    {reply, mochijson2:encode(Docs), State};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

handle_call(rent_plus_12001, _From, #rent_db{db=DB}=State) ->
Docs = queries(DB, {"by_price_rooms", "rent_plus12001_rooms_any"},[]),
    {reply, mochijson2:encode(Docs), State};
handle_call(rent_plus_12001_rm_1_2, _From, #rent_db{db=DB}=State) ->
Docs = queries(DB, {"by_price_rooms", "rent_0-3000_rooms_any"},[]),
    {reply, mochijson2:encode(Docs), State};
handle_call(rent_plus_12001_rm_3_4, _From, #rent_db{db=DB}=State) ->
Docs = queries(DB, {"by_price_rooms", "rent_0-3000_rooms_any"},[]),
    {reply, mochijson2:encode(Docs), State};
handle_call(rent_plus_12001_rm_plus_5, _From, #rent_db{db=DB}=State) ->
   Docs = queries(DB, {"by_price_rooms", "rent_0-3000_rooms_any"},[]),
    {reply, mochijson2:encode(Docs), State};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%handle_call({create, Doc}, _From, #rent_db{db=DB}=State) ->
   %% {ok, Doc1} = couchbeam:save_doc(DB, Doc),
    %%{NewDoc} = couchbeam_doc:set_value(<<"id">>, couchbeam_doc:get_id(Doc1), Doc1),
    %%{reply, mochijson2:encode({struct, NewDoc}), State};
    

handle_call(terminate, _From, State) ->
    {stop, normal, State}.


handle_cast(_Msg, State) ->
    {noreply, State}.


handle_info(_Info, State) ->
    {noreply, State}.


terminate(_Reason, _State) ->
    ok.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

queries(DB, Views, Options) ->
	
    {_, AllDocs} = couchbeam_view:fetch( DB, Views,Options),
	AllDocs.



