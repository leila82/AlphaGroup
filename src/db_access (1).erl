-module(db_access).

-define(debug, true).

-ifdef(debug).
-define(DEBUG_INFO(Msg), io:format("{~p:~p}:: ~p~n", [?MODULE, ?LINE, Msg])).
-else.
-define(DEBUG_INFO(Msg), true).
-endif.

-export([get_posts/1, add_post/2]).


%% example:
%% Dbname = "my_db"
%% Dbtable = "my_table"
%% F = fun(X) -> json_obj:get_value("value", X) end,

get_posts(Dbname, Dbtable, F) ->
    ?DEBUG_INFO(accessing_couchdb),
    {ok, Return} = ecouch:view_adhoc(Dbname, Dbtable, "flat"),
    ?DEBUG_INFO(getting_rows),
    RawRows = json_obj:get_value("rows", Return),
    ?DEBUG_INFO(extracting_rows),
    Rows = lists:map(F, RawRows),
    ?DEBUG_INFO(returning_rows),
    lists:reverse(Rows).

add_post(Dbname, Complete) ->    
    ?DEBUG_INFO(adding_new_doc),
    ecouch:doc_create(Name, Complete).
    
update_post(Dbname, Dbtable, Complete) ->    
    ?DEBUG_INFO(updating_doc),
    ecouch:doc_update(Dbname, Dbtable, Complete).
