-module(db_access).

-define(debug, true).

-ifdef(debug).
-define(DEBUG_INFO(Msg), io:format("{~p:~p}:: ~p~n", [?MODULE, ?LINE, Msg])).
-else.
-define(DEBUG_INFO(Msg), true).
-endif.

-export([get_posts/3, add_post/2, update_post/3, get_table_item/3, 
    get_listings_item/2]).


%% example:
%% Dbname = "my_db"
%% Dbtable = "my_table"
%% F = fun(X) -> json_obj:get_value("value", X) end,

%% Gets all posts from table "Dbtable" from database "Dbname". Function "F"
%% is mapped to the rows, which allows the extraction of specific fields.
get_posts(Dbname, Dbtable, F) ->
    ?DEBUG_INFO(accessing_couchdb),
    {ok, Return} = ecouch:view_access(Dbname, Dbtable, "flat"),
    ?DEBUG_INFO(getting_rows),
    RawRows = json_obj:get_value("rows", Return),
    ?DEBUG_INFO(extracting_rows),
    Rows = lists:map(F, RawRows),
    ?DEBUG_INFO(returning_rows),
    lists:reverse(Rows).

%% Create a document under Dbname.
add_post(Dbname, Complete) ->    
    ?DEBUG_INFO(adding_new_doc),
    ecouch:doc_create(Dbname, Complete).

%% Update document.
update_post(Dbname, Dbtable, Complete) ->    
    ?DEBUG_INFO(updating_doc),
    ecouch:doc_update(Dbname, Dbtable, Complete).

%% Get a list of all the doc fields specified by "Value".
get_table_item(Dbname, Dbtable, Value) ->
    get_posts(Dbname, Dbtable,
        fun(X) -> json_obj:get_value(Value, X) end).

%% Get a list of all the doc fields specified by "Value" from a listings object.
get_listings_item(Listings, Value) ->
    F = fun(X) -> json_obj:get_value(Value, X) end,
    Rows = lists:map(F, Listings),
    lists:reverse(Rows).
