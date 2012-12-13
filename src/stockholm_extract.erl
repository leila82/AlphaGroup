-module(stockholm).
%-export([getEtl/0]).
%% author @ Sarah Jamil,
%%  extract Apartments Data from "http://www.bostaddirekt.com/Private/default.aspx?custType=0".
%% -----------------------------------------------------
-compile(export_all).
-record(rental, {rooms,area,rent,address,district}).
getEtl()->
Cmd= "curl \"" ++ "http://www.bostaddirekt.com/Private/default.aspx?custType=0&apmnt=1&other=1&Room=1&RoomsMin=0&SizeMin=0&RentMax=999999&Furnished=-1&PeriodMinMax=min&Period=1&PublDays=61&EstateID=&Areas=7001&SortBy=zip_Name&SortDir=asc&minimize=1" ++ "\"",
  Output = os:cmd(Cmd),

%%  to exstract the HTML :
%% 1. determine the start and the end of html page .
%% 2. determine the start and the end for each apartment and add the valus of each 
%%    apartment into a list.
%% 3. start getting the value of each apartment then cut this value from the aprtment
%%    part and remove to th enext value after that add these values for each apartment
%%    to a tuple of list and add it to a list; then recorsive to the next apartments .


%%determine the start and the end of the HTML page.
  TextFrom=string:str(Output,"<div id=\""++"search_result_content"++"\""++">"),
    if TextFrom==0 -> 
       "No found";
       TextFrom>0 ->
  TextEnd=string:str(Output,"<div class=\""++"searchresult_footer"++"\""++">"), 
  LimitedText=string:substr(Output,TextFrom,(TextEnd-TextFrom)),	
     getTable([],LimitedText,TextEnd)
	     
    end.
%% determine the start and the end of each apartment data.

getTable(TableBuff,LimitedText,TextEnd)->

  TableStartP=string:str(LimitedText,"<tr valign=\"top\" align=\"left\" id="),
  TableEndP=string:str(LimitedText,"<tr valign=\"top\" align=\"left\" class")+58,
    
  if TableStartP == 0->
              lists:reverse(TableBuff);

     TableStartP > 0  -> 
  MiniTable=string:substr(LimitedText,TableStartP,(TableEndP - TableStartP)),
    getData(TableBuff,MiniTable,TextEnd,LimitedText,TableEndP)
  
    end.
%%extract data for each appartment.

getData(TableBuff,MiniTable,TextEnd,LimitedText,TableEndP)->

%%extract the Img.          
    ImgStart=string:str(MiniTable,"<td class=\"object\">")+21,
    ImgEnd=string:str(MiniTable,"</td>")+5,
    _Img=string:substr(MiniTable,ImgStart,ImgEnd),
   % FindType=string:strip(Type, both, $.),
%%extract the Type of Data(apartment, room or villa).
    Rilimit=string:substr(MiniTable,ImgEnd,TextEnd),
    TypeStart2=string:str(Rilimit,"<td class=\"object\">")+22,
    TypeEnd2=string:str(Rilimit,"</td>"),
    _Type2=string:substr(Rilimit,TypeStart2,(TypeEnd2-TypeStart2)), 

%%extract the Adress.   
     Rilimit2=string:substr(Rilimit,TypeEnd2+5,TextEnd),
     AddressStart=string:str(Rilimit2,"<td class=\"object\">")+21,
     AddressEnd=string:str(Rilimit2,"</td>"),
     Address=string:substr(Rilimit2,AddressStart,(AddressEnd-AddressStart)),

%%extract the number of room.
    Rilimit3=string:substr(Rilimit2,AddressEnd+5,TextEnd),
    RoomStart=string:str(Rilimit3,"<td class=\"object\" align=\"center\">")+34,
    RoomEnd=string:str(Rilimit3,"</td>"),
    Room=string:substr(Rilimit3,RoomStart,(RoomEnd-RoomStart)),

%%extract the area.
    Rilimit4=string:substr(Rilimit3,RoomEnd+5,TextEnd),
    AreaStart=string:str(Rilimit4,"<td class=\"object\">")+21,
    AreaEnd=string:str(Rilimit4,"</td>"),
    Area=string:substr(Rilimit4,AreaStart,(AreaEnd-AreaStart)),

%%extract the rent. 
    Rilimit5=string:substr(Rilimit4,AreaEnd+5,TextEnd),
    RentStart=string:str(Rilimit5,"<td class=\"object\">")+21,
    RentEnd=string:str(Rilimit5,"</td>"),
    Rent=string:substr(Rilimit5,RentStart,(RentEnd-RentStart)), 
 

  Data=#rental{district="Stockholm",
      address= eliminate(Address),rooms =eliminate(Room),
      area= eliminate(Area),rent=eliminate(Rent)},

%%recursive to get other apartments
  RelimitedText=string:sub_string(LimitedText,TableEndP,TextEnd),
     getTable([Data|TableBuff],RelimitedText,TextEnd).
    
%%Eliminate distance and excess characters to get the information only
eliminate(Value)->
    Val=re:split(Value," ",[{return, list}]),
    split(Val,[]).

split([H|T],Buff)->
    split(T,[H|Buff]);
split([],Buff)->
    eliminate2(Buff,[]).

eliminate2([H|T],Buff) ->
    String=H,
    String1 = re:replace(String, "\r", "", [{return,list}]),
    String2 = re:replace(String1, "\n", "", [{return,list}]),
    String3 = re:replace(String2, "\t", "", [{return,list}]),
    String4 = re:replace(String3, "<span>", "", [{return,list}]),
    String5 = re:replace(String4, "</span>", "", [{return,list}]),
    String6 = re:replace(String5, "kr", "", [{return,list}]),
    String7 = re:replace(String6, "m", "", [{return,list}]),
    String8 = re:replace(String7, "&sup2;", "", [{return,list}]),

     eliminate2(T,[String8|Buff]);
     eliminate2([],Buff)->
     Str=string:join(Buff," "),
     _Elim=string:strip(Str,both,32).





