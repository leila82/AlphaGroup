-module(activity).
-author("Gokul").
-define(DB_IP,"127.0.0.1").
-define(DB_PN,"5984").
-compile(export_all).

%% This module is for yaws.conf file to include in runmod.
%% When an yaws server is been started -
%% -(assuming yaws.conf file has a key 'runmod' set to value 'activity')


start()->
%%TODO - Check with the ping weather couch is been started on local server or not
    ok.
