%%%-------------------------------------------------------------------
%%% @authors lengor <chandu.gokul138@gmail.com>, Sadhi Khan
%%% @copyright lengor
%%% @doc
%%%
%%% @end
%%% Created : 10 Oct 2012 by lengor <chandu.gokul138@gmail.com>
%%%-------------------------------------------------------------------

-module(json_handler).
-record(appartment,{location=undefined,published=undefined,price=undefined,objType=undefined,orgin_SourceLink=undefined,rooms=undefined,area=undefined,construction_Type=undefined}).%ObjType={Villa|Lgh,Etc..},Orgin_SourceLink=URL(),Rooms,Area,Construction_Type={new,old}}).
-record(location,{position=undefined,street=undefined,city=undefined,muncipality=undefined,district=undefined}). %{streetAddress,city,MuncipalityName,countyName}
%% in maps {0,0} res in overall 
-record(position,{latitude=0,longitude=0}).
-compile(export_all).

%% Decodes JSON notated strings in to a list of JSON objects
decode_string()-> %% test
%%decode_string(Json_string)->
    Json_string = "{\"totalCount\":692,\"count\":3,\"listings\":[{\"booliId\":1304680,\"listPrice\":1195000,\"published\":\"2012-11-01 11:17:39\",\"location\":{\"namedAreas\":[\"V\\u00e4stra Orminge\"],\"region\":{\"municipalityName\":\"Nacka\",\"countyName\":\"Stockholms l\\u00e4n\"},\"address\":{\"city\":\"Boo\",\"streetAddress\":\"Ormingeringen 43\"},\"position\":{\"latitude\":59.32827192,\"longitude\":18.25144273}},\"objectType\":\"L\\u00e4genhet\",\"source\":{\"name\":\"Svenska M\\u00e4klarhuset\",\"url\":\"http:\\/\\/www.svenskamaklarhuset.se\\/\",\"type\":\"Broker\"},\"rooms\":2,\"livingArea\":70,\"rent\":3754,\"isNewConstruction\":0,\"url\":\"http:\\/\\/www.booli.se\\/bostad\\/lagenhet\\/vastra+orminge\\/ormingeringen+43\\/1304680\"},{\"booliId\":1304673,\"listPrice\":3400000,\"published\":\"2012-11-01 11:16:24\",\"location\":{\"namedAreas\":[\"Saltsj\\u00f6qvarn\"],\"region\":{\"municipalityName\":\"Nacka\",\"countyName\":\"Stockholms l\\u00e4n\"},\"address\":{\"streetAddress\":\"Saltsj\\u00f6qvarns Kaj 1\"},\"position\":{\"latitude\":59.3148,\"longitude\":18.1114}},\"objectType\":\"L\\u00e4genhet\",\"source\":{\"name\":\"Notar\",\"url\":\"http:\\/\\/www.notar.se\\/\",\"type\":\"Broker\"},\"rooms\":2,\"livingArea\":68,\"rent\":4267,\"floor\":6,\"isNewConstruction\":0,\"url\":\"http:\\/\\/www.booli.se\\/bostad\\/lagenhet\\/saltsjoqvarn\\/saltsjoqvarns+kaj+1\\/1304673\"},{\"booliId\":1304529,\"listPrice\":7400000,\"published\":\"2012-11-01 01:35:55\",\"location\":{\"namedAreas\":[\"Saltsj\\u00f6baden\"],\"region\":{\"municipalityName\":\"Nacka\",\"countyName\":\"Stockholms l\\u00e4n\"},\"address\":{\"city\":\"Saltsj\\u00f6baden\",\"streetAddress\":\"Granbacken 3B\"},\"position\":{\"latitude\":59.28028041,\"longitude\":18.30533255}},\"objectType\":\"Villa\",\"source\":{\"name\":\"Bjurfors\",\"url\":\"http:\\/\\/www.bjurfors.se\\/\",\"type\":\"Broker\"},\"rooms\":3,\"livingArea\":143,\"plotArea\":\"584.0\",\"isNewConstruction\":0,\"url\":\"http:\\/\\/www.booli.se\\/bostad\\/villa\\/saltsjobaden\\/granbacken+3b\\/1304529\"}],\"limit\":3,\"offset\":0,\"searchParams\":{\"areaId\":76}}",
 case   mochijson2:decode(Json_string) of
     {invalid_json,_} ->
	 io:format("Please check the invalid data input of JSON string in decode_string");
     {struct,[_,_,{_,List},_,_,_]} ->
	 process_list(List,[]);
     {[_,_,{_,List},_,_,_]} ->
	 process_list(List,[])
 end.

%% Internal Functions

% Plist -> procesed_list
process_list([{H}|[]],PList)->
   [process_object(H)|PList];
 %   process_object(H);

process_list([{H}|T],PList)->
%    io:format("~s",[H]),
 DS = process_object(H), %% Put the ds here
    process_list(T,[DS|PList]).
%loc%{position=undefined,street=undefined,city=undefined,muncipality=undefined,district=undefined}). %{streetAddress,city,MuncipalityName,countyName}
%appartment%{location=undefined,published=undefined,price=undefined,objType=undefined,orgin_SourceLink=undefined,rooms=undefined,area=undefined,construction_Type=undefined
%% Process List and return DS
process_object(Obj)->
    Position = #position{latitude=proplists:get_value(binary:list_to_bin("latitude"),Obj),longitude=proplists:get_value(binary:list_to_bin("longitude"),Obj)},
    Location = #location{position=Position,street=binary:bin_to_list(proplists:get_value(binary:list_to_bin("streetaddress"),Obj)),city=binary:bin_to_list(proplists:get_value(binary:list_to_bin("latitude"),Obj)),muncipality=binary:bin_to_list(proplists:get_value(binary:list_to_bin("muncipalityName"),Obj)),district=binary:bin_to_list(proplists:get_value(binary:list_to_bin("countyName"),Obj))},
    #appartment{location=Location,published=binary:bin_to_list(proplists:get_value(binary:list_to_bin("published"),Obj)),price=binary:bin_to_list(proplists:get_value(binary:list_to_bin("price"),Obj)),objType=binary:bin_to_list(proplists:get_value(binary:list_to_bin("objectType"),Obj)),orgin_SourceLink=binary:bin_to_list(proplists:get_value(binary:list_to_bin("url"),Obj)),rooms=proplists:get_value(binary:list_to_bin("rooms"),Obj),area=proplists:get_value(binary:list_to_bin("livingArea"),Obj),construction_Type=proplists:get_value(binary:list_to_bin("isNewConstruction"),Obj)}.
%    binary:bin_to_list(proplists:get_value(binary:list_to_bin("streetAddress"),Obj)).
%    Bin_Val = binary:list_to_bin("rent"),
%    proplists:get_value(Bin_Val,Obj).

%process_object(_H,T)->
%    T.

%DS = {Location,Published,Price,Position,ObjType={Villa|Lgh,Etc..},Orgin_SourceLink=URL(),Rooms,Area,Construction_Type={new,old},}



%% Local Test Functions

%% Development scrap code

print_list([])->
    ok;
print_list([H|T])->
    io:format("~s",[[H]]),print_list(T).

print_Char(C)->
    io:format("~c~n",[C]).


