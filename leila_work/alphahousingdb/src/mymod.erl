%% Author: leila
%% Created: Nov 23, 2012
%% Description: TODO: Add description to mymod
%% Make sure that the design documents 
%%are saved in the database
%%THE NAME OF THE DESIGN DOC IS THE SAME FOR ALL DB
-module(mymod).

-include("/home/leila/alphahousingdb/alphahousingdb/include/server_info.hrl").%% Leila

-define(Db_malmo, "baba").
-define(Design_doc_name, "by_price_rooms").
-define(Db_gbg, "gothenburg").
-define(Db_stokholm, "stokholm").
-define(Fun1, "rent_0-3000_rooms_1-2").
-define(Fun2, "rent_0-3000_rooms_3-4").
-define(Fun3, "rent_0-3000_rooms_plus_5").
-define(Fun4, "rent_0-3000_rooms_any").
-define(Fun5, "rent_3001-6000_rooms_1-2").
-define(Fun6, "rent_3001-6000_rooms_3-4").
-define(Fun7, "rent_3001-6000_rooms_plus_5").
-define(Fun8, "rent_3001-6000_rooms_any").
-define(Fun9, "rent_6001-12000_rooms_1-2").
-define(Fun10, "rent_6001-12000_rooms_3-4").
-define(Fun11, "rent_6001-12000_rooms_plus_5").
-define(Fun12, "rent_6001-12000_rooms_any").
-define(Fun13, "rent_plus12001_rooms_1-2").
-define(Fun14, "rent_plus12001_rooms_3-4").
-define(Fun15, "rent_plus12001_rooms_plus_5").
-define(Fun16, "rent_plus12001_rooms_any").


%%
%% Include files
%%

%%
%% Exported Functions
%%
-export([conn/0]).


%% The argument is a db name


conn() ->

%% the database is changeable and the design document name is the same and functions can change too
%% but it does not depend on the database! Make sure that the design 
%%document are saved in the right database
%% because the codes are different!
{ok, Db} = couchbeam:open_db(?S, ?Db_gbg, []),
{_, AllDocs} = couchbeam_view:fetch(Db, {?Design_doc_name, ?Fun1},[]),

AllDocs.