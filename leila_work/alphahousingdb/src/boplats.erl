%% Autor Akram
-module(boplats).

-define(Url, "http://www.boplats.se/HSS/Object/object_list.aspx?cmguid=4e6e781e-5257-403e-b09d-7efc8edb0ac8&objectgroup=1").
-define(HTML,"asdadahgdvjbkn aghvsbckn fsghjxb akram fhagmbj gvnbm, mohsen").
%% For this path change to the right path of the include file directory
-include("/home/leila/alphahousingdb/alphahousingdb/include/server_info.hrl").%% Leila
-define (DB,"gothenburg").
-compile(export_all).
-export([main/0]).


main() ->

	     inets:start(),
     {ok, {_Status, _Header, HTML}} = httpc:request(?Url),	
        MainPart= apartmentsInfo(HTML),  
     findApartment(MainPart,[]),
	 ok.
	
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
%%   {PageWithoutRooms,Rooms}=getValue(PageWithoutBorough,"<td align=\""++"center>"++"\"","</td>"),  
{PageWithoutRooms,Rooms}=getValue(PageWithoutBorough,"<td align=\"center\">","</td>"),
   {_PageWithoutRent,Rent}=getValue(PageWithoutRooms,"<td>","</td>"),
   Info ={Address,Borough,Rooms,Rent},

    %% Process the appartment information in "Gothenburg" data base
%% couchbeam will first check if the document is already save and then pass 
%% if not save it and return the saved document because we will use it in other
%% functions to gather all appartments information!
%% Boplats does not have duplicated data but the appartments can have the same information and 
%% still being different since they are saved by appartment nr(Lägenhet nr in booplats)
%% our parser does not continue until getting the unique key, therefore, we check 
%% duplicates before saving the informations.  
%% The conversion using unicode functions resolve the problem with UTF8 Author Leila Keza


Doc ={[{<<"Adress">>, unicode:characters_to_binary(Address)},
				{<<"District">>, unicode:characters_to_binary(
				 lists:append(Borough, "/ Gothenburg"))},
				{<<"Rent">>, unicode:characters_to_binary(Rent)},
				{<<"Rooms">>, unicode:characters_to_binary(Rooms)}]},
      			%%couch_db:create(#couch.db, {Doc}). Leilas Part!
	 	{ok, Db} = couchbeam:open_db(?S, ?DB, ?Options),
   %%{ok, Doc3} = couchbeam:open_doc(Db, "_design/by_price_rooms"),

case couchbeam_doc:is_saved(Doc) of
		true-> Doc;
	false->
		{ok, Doc1} = couchbeam:save_doc(Db, Doc),
Doc1
end.%% end Leilas Codes
         
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

