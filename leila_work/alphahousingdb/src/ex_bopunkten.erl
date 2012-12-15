-module(ex_bopunkten).
-compile(export_all).					
-compile(export_all).
-define(Url, "http://www.bopunkten.se/annonser/goteborg").
-include("/home/leila/alphahousingdb/alphahousingdb/include/server_info.hrl").
-define (DB,"gothenburg").
%%-record(boplatApartment,{regionR,rumR,boytaR,hyraR,boendetypR,kontactR,skapadR}).
-export([start/0, parse/1]).
%% Authors : Akram Beygi, Sadi Khan.
%% Module completion date : 21st November 2012.
%% This function is used for starting the module 
%% This sends a HTTP request to the bopunkten website which in reply sends the bopunkten html source%% page data.There is a function(getPageNumber)  is used for also finding how many pages are there t%%be extracted from the website.



%% FOR RUNNING THIS MODULE USE (MODULE NAME: Start()).
start() ->
	
    inets:start(),	
    Url="http://www.bopunkten.se/annonser/goteborg",
    {ok, {_Status, _Header, HTML}} = httpc:request(get,{?Url,[]},[],[{body_format,string}]),  
    PageInfo=getPageInfo(HTML),
    PageNumber=0,
    PageNumbers=getPageNumber(PageInfo,PageNumber),
    main(PageNumbers,Url,[]).

%% This function is used for getting to each page and calling the parsing function to the 
%% list and moving to the next page.

main(Num,Url,AppList)->
    case Num of
	0->
	    AppList;
	_->
	    {ok, {_Status, _Header, HTML}} = httpc:request(get,{?Url,[]},[],[{body_format,string}]),  
	    MainPart=apartmentsInfo(HTML),
	    List= findApartment(MainPart,AppList),
	    Sida = lists:append("sida",integer_to_list(Num-1)),
	    main(Num-1,lists:append(Url,Sida),List)
		
end.

%% We are using the findApartment function to get each apartment from all of the apartments and pars%% this apartment information and add information to the list.
%% After that we move to the info of other apartments and then the same process is continued. 


findApartment(MainInformation,AppList)->
    {Apartment,LeftApartments} = nextApartment(MainInformation),
    ApatmentLength=string:len(Apartment),  
    case ApatmentLength < 9 of
      true ->
           AppList;
      false ->
           MainApartment=apartmentMainInfo(Apartment),
           Apartment1 =  parse(MainApartment),
		   
		   
           findApartment(LeftApartments,[Apartment1|AppList])   
    end.

%% This getPageInfo function is used for getting how many pages are there for the extraction.
getPageInfo(Html)->
    Start = string:str(Html, "<div class=\"pagination\">"),
    Stop= string:str(Html, "<div class=\"sub-primary\">")+25,
    Length=Stop-Start,
    Field = string:substr(Html, Start, Length), 
print_char(Field),    
    Field.

%% This function is related to the previous function for parsing how many pages information.

getPageNumber(Html,PageNumber)->
    Start = string:str(Html, "</a>")+4,
    Stop= string:str(Html, "<div class=\"sub-primary\">")+25,
  case Start of
    4->
	PageNumber;
    _->
    Length=Stop-Start,
    Field = string:substr(Html, Start, Length), 
  
	  getPageNumber(Field,PageNumber+1)
	  
end.	     
%% This function is used for catching the value for each apartment for example(address, room, area o%% -f the certain apartment)
apartmentMainInfo(Html)->
    Start = string:str(Html, "</a>")+4,
    Stop= string:str(Html, "</tr>")+5,
    Length=Stop-Start,
    Field = string:substr(Html, Start, Length), 
    Start1 = string:str(Field, "</td>")+5,
    Stop1= string:str(Field, "</tr>")+5,
    Length1=Stop1-Start1,
    Field1 = string:substr(Field, Start1, Length1), 
    Field1.


%% This function consists of all information related to the apartments which we need to parse.
%% This function is allowing us to get the main information part by using the start position and the end position of a page.
apartmentsInfo(Html)->
    Start = string:str(Html, "<tbody>"),
    Stop= string:str(Html, "</tbody>"),
    Length=Stop-Start+8,
    Field = string:substr(Html, Start, Length), 
    Field.

%% This function is for taking in and parsing the apartment area.


boytoInfos(BoytoInfo)->
io:format("BoytoInfo:~n~p",[BoytoInfo]),

    Start =1,
    Stop= string:str(BoytoInfo, "<sup>")-7,
    Length=Stop-Start,
    Field = string:substr(BoytoInfo, Start, Length), 
    Field.

%% This function separates the first apartment from other apartments and separates them into two pag%%  es, where one page cosists of the first apartment and the left apartments is taken as LeftPage.

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
	    StopLeftPage= string:str(Field,"</tbody>"),
	    StartLeftPage=Stop,
	    LengthLeftPage=StopLeftPage-StartLeftPage+8,
	    LeftPage = string:substr(Field,StartLeftPage,LengthLeftPage),
	    {Apartment,LeftPage}
	    
    end.

%% This function is used for parsing each apartment.
 
parse(Apartment)->
   {PageWithoutRegion,Region}=getValue(Apartment,"<td>","</td>"),
   {PageWithoutRoom,Room}=getValue(PageWithoutRegion,"<td>","</td>"),
   {PageWithoutBoyta,Boyto}=getValue(PageWithoutRoom,"<td>","</td>"),
   Boyta=boytoInfos(Boyto),

   {PageWithoutHyra,Hyra}=getValue(PageWithoutBoyta,"<td class=\"numeric\">","</td>"),
   {PageWithoutBoendetyp,Boendetyp}=getValue(PageWithoutHyra,"<td class=\"house-type type-2\">","</td>"),
   {PageWithoutkontact,Kontact}=getValue(PageWithoutBoendetyp,"<td>","</td>"),
   {_PageWithoutskapad,Skapad}=getValue(PageWithoutkontact,"<td>","</td>"),
 %% #boplatApartment{regionR=Region,rumR=Room,boytaR=Boyta,hyraR=Hyra,boendetypR=Boendetyp,kontactR=Kontact,skapadR=Skapad}.

 %% This codes store the extracted data to the database as documents! 
%% The conversion using unicode functions resolve the problem with UTF8 Author Leila Keza
Doc = {[{<<"Date">>, unicode:characters_to_binary(Skapad)},
{<<"Contract type">>, unicode:characters_to_binary(Kontact)},
{<<"District">>, unicode:characters_to_binary(
lists:append(Region, " / Gothenburg"))},
{<<"Rent">>, unicode:characters_to_binary(Hyra)},
{<<"Rooms">>, unicode:characters_to_binary(Room)},
{<<"Area">>, unicode:characters_to_binary(Boyta)}]},


{ok, Db} = couchbeam:open_db(?S, ?DB, ?Options),
	
case couchbeam_doc:is_saved(Doc) of
		true-> ok;
	false->
		{ok, Doc1} = couchbeam:save_doc(Db, Doc),
Doc1
end.

%% THESE LINES ARE USED FOR CHECKING THE RESULTS
print_char([])->
    ok;
print_char([C|T])->
    io:format("~s",[[C]]),
    print_char(T).


%%  The getValue function is used for catching the data from each line of each apartment.
getValue(Apartment,Start,Stop)->
case(Start) of

  "<td>" ->
     StartApartment = string:str(Apartment, Start)+4;

   "<td class=\"numeric\">"->
     StartApartment = string:str(Apartment, Start)+20;

   "<td class=\"house-type type-2\">"->
     StartApartment = string:str(Apartment, Start)+30
end,

 StopApartment =  string:str(Apartment, Stop),
     ValueLength=StopApartment-StartApartment,
     Value = string:substr(Apartment,StartApartment,ValueLength), 
     StartNextApartment=StopApartment+5,
     StopNextApartment=string:str(Apartment,"</tr>")+5,
     NewApartmentLength=StopNextApartment-StartNextApartment,
     LeftApartment=string:substr(Apartment,StartNextApartment,NewApartmentLength),  
     {LeftApartment, Value}.



