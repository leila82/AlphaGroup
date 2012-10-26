-module(scrapping2).
-compile(export_all).
-define(Url, "https://www.boplats.se/HSS/Default.aspx").
-define(HTML,"asdadahgdvjbkn aghvsbckn fsghjxb akram fhagmbj gvnbm, mohsen").
main() ->
	inets:start(),
	{ok, {_Status, _Header, HTML}} = httpc:request(?Url),
	%{match, [Time]} = re:run(HTML, ?Match, [{capture, all_but_first, binary}]),

    fxn(HTML).
% io:format("~s~n",[HTML]).
% HTML.
% m()->
% HTML = main().
% hello(HTML)->
% string:str( , "Hello World").
fxn(Html)->
    Start = string:str(Html, "<tr class"),

    io:format("Start  ~p~n" , [Start]),
    Stop = string:str(Html, "<TABLE cellSpacing"),
    io:format("Stop  ~p~n" , [Stop]).

    
   % Length=Stop-Start,
    %Field = string:substr(Html, Start, Length),
    %io:format("~s~n", [Field]).
    

   % S2=Start,
    %Len2=Stop-S2,
   % Field2 = string:substr(Field, S2, Len2),

 %   io:format("~s~n", [Field2]).
