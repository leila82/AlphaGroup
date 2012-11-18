-module(activity).
-author("Gokul").
-compile(export_all).

%% This module is for yaws.conf file to include in runmod.
%% When an yaws server is been started -
%% -(assuming yaws.conf file has a key 'runmod' set to value 'activity')


start()->
    ok.
