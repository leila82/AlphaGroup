-module(myappmod).
%-include("../../include/yaws_api.hrl").  %% Uncomment this when using in yaws
-include("/Users/admin/yaws/include/yaws_api.hrl").
-compile(export_all).



out(_A)->
    io:format("Hello").
%%     io:format("~p~n~p~n~p~n",
%% 	      [A#arg.appmoddata,
%% 	       A#arg.appmod_prepath,
%% 	       A#arg.querydata]).
