%% Autor Akram
-module(boplats).
-compile(export_all).
-export([main/0]).
-define(Url, "http://www.boplats.se/HSS/Object/object_list.aspx?cmguid=4e6e781e-5257-403e-b09d-7efc8edb0ac8&objectgroup=1").
-define(HTML,"asdadahgdvjbkn aghvsbckn fsghjxb akram fhagmbj gvnbm, mohsen").
-record(couch, {db}).

main() ->
     inets:start(),
     {ok, {_Status, _Header, HTML}} = httpc:request(?Url),
	 {ok, PID} = couch_db_sup:start_child(),%%Leila
    {ok, #couch{db=PID}},%%Leila
     MainPart= apartmentsInfo(HTML),  
     findApartment(MainPart,[]),
	 alphagroup_sup:terminate_child(PID),%%Leila
	{ok, #couch{db=PID}}.%%Leila.


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
   %%{Address,Borough,Rooms,Rent}

   %% Edited by Leila 
Doc =[{<<"Adress">>, list_to_binary(Address)},
				{<<"District">>, list_to_binary(
				 lists:append(Borough, "/ Gothenburg"))},
				{<<"Rent">>, list_to_binary(Rent)},
				{<<"Rooms">>, list_to_binary(Rooms)}],
      			couch_db:create(#couch.db, {Doc}).%% Leilas Part!
	    
            %%fun ({json,{struct,[{<<"ok">>,true}, {<<"id">>, DocID}, {<<"rev">>, DocRev}]}}) ->
                 %%   put(doc_id_1, DocID),
                    %%put(doc_rev_1, DocRev),
                    %%true;
                %%(_) ->
                   %% false
           %% end,
           %% erlang_couchdb:create_document({"localhost", 5984}, "housingdb", Doc),          
       
      %%  ok.%% End Leilas Codes 


  




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

