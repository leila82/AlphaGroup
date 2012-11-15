-module(myappmod).
%-include("../../include/yaws_api.hrl").  %% Uncomment this when using in yaws
-include("/Users/admin/yaws/include/yaws_api.hrl").
-compile(export_all).



out(_A)->
    KV_List = A#arg.querydata,
   Country =  proplists:get_value(country,KV_List)
    io:format("~p~n",[Country]).



%%     io:format("~p~n~p~n~p~n",
%% 	      [A#arg.appmoddata,
%% 	       A#arg.appmod_prepath,
%% 	       A#arg.querydata]).
