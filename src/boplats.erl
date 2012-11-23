-module(boplats).
-compile(export_all).
-define(Url, "http://www.boplats.se/HSS/Object/object_list.aspx?cmguid=4e6e781e-5257-403e-b09d-7efc8edb0ac8&objectgroup=1").
-define(HTML,"asdadahgdvjbkn aghvsbckn fsghjxb akram fhagmbj gvnbm, mohsen").
%-record(boplatApartment, {address,borough,rooms,rent}).
%-record(rental, {rooms,area,rent,address,district}).
-include("../include/alpha_records.hrl").


main() ->
     inets:start(),
     {ok, {_Status, _Header, HTML}} = httpc:request(?Url),
     MainPart= apartmentsInfo(HTML),  
     findApartment(MainPart,[]).


findApartment(MainInformation,AppList)->
    {Apartment,LeftApartments} = nextApartment(MainInformation),
    ApatmentLength=string:len(Apartment),
    case ApatmentLength < 6 of
	true ->
	    AppList;
	false ->
	  Apartment1 =  parse(Apartment),
	    findApartment(LeftApartments,[Apartment1|AppList])
    end.


parse(Apartment)->

   {PageWithoutDetail,_Detailes}=getValue(Apartment,"<td>","</td>"), 
   {PageWithoutAddress,Address}=getValue(PageWithoutDetail,"<td>","</td>"),
   {PageWithoutBorough,Borough}=getValue(PageWithoutAddress,"<td>","</td>"),
   {PageWithoutRooms,Rooms}=getValue(PageWithoutBorough,"<td align=\"center\">","</td>"),
   {_PageWithoutRent,Rent}=getValue(PageWithoutRooms,"<td>","</td>"),
%%   #boplatApartment{address=Address,boroug=Borough,rooms=Rooms,rent=Rent}.
%%   #rental{address=Address,district=Borough,rooms=Rooms,rent=Rent}.
%%   #rental{address=Address,area="n/a",district=Borough,rooms=Rooms,rent=Rent}.
    #rental{address=Address,area=0,district=Borough,rooms=list_to_integer(Rooms),rent=list_to_integer(Rent)}.


apartmentsInfo(Html)->
    Start = string:str(Html, "<tr class=\""++"tbl_cell_list_even"++"\""),
    Stop= string:str(Html, "<TABLE cellSpacing"),
    Length=Stop-Start+19,
    Field = string:substr(Html, Start, Length),  
    Field.       

nextApartment(Field)->
    Start = string:str(Field, "<tr"),
    Stop = string:str(Field, "</tr>")+5,
    Length=Stop-Start,
case Start of   
    0 ->
	    Apartment="Done",
	    LeftApartment="Done",
	    {Apartment,LeftApartment};
    _->
	    Apartment = string:substr(Field, Start, Length),    
	    StopLeftPage= string:str(Field,"<TABLE cellSpacing"),
	    StartLeftPage=Stop,
	    LengthLeftPage=StopLeftPage-StartLeftPage+19,
	    LeftPage = string:substr(Field,StartLeftPage,LengthLeftPage),
	    {Apartment,LeftPage}
	    
end.
 
getValue(Apartment,Start,Stop)->
case(Start) of
  "<td>" ->
     StartApartment = string:str(Apartment, Start)+4;
 %  "<td align=\"center\">"->
%	StartApartment = string:str(Apartment, Start)+19
    _->
	StartApartment = string:str(Apartment, Start)+19
end,

 StopApartment =  string:str(Apartment, Stop),
     ValueLength=StopApartment-StartApartment,
     Value = string:substr(Apartment,StartApartment,ValueLength), 
     StartNextApartment=StopApartment+5,
     StopNextApartment=string:str(Apartment,"</tr>")+5,
     NewApartmentLength=StopNextApartment-StartNextApartment,
     LeftApartment=string:substr(Apartment,StartNextApartment,NewApartmentLength),     
     {LeftApartment, Value}.


%% %% @spec reform(String())->String()
%% %% @description 
%% %% @retrun_type returns a string()
%% reform(String)->
%%     string:join(fixReplace(String),"").

%% fixReplace([H|T]) -> [fixSwe([H])|fixReplace(T)];
%% fixReplace([])->[].

%% fixSwe(String)->
%%     String1 = re:replace(String, "å","a", [{return,list}]),
%%     String2 = re:replace(String1, "ä","a", [{return,list}]), %
%%     String3 = re:replace(String2, "ö", "o",[{return,list}]),
%%     String4 = re:replace(String3, "Å", "A",[{return,list}]),
%%     String5 = re:replace(String4, "é","e" ,[{return,list}]),
%%     String6 = re:replace(String5, "Ä", "A", [{return,list}]),
%%     String7 = re:replace(String6, "Ö","O",[{return,list}]),
%%     String8 = re:replace(String7, "\r", "", [{return,list}]),
%%     re:replace(String8, "\n", "", [{return,list}]). 
