%%                   Author:Akram beygi
%%                   The goal of this module is extraction and parsing the information about parking in Gotenbourg.
%%                   these information consist of address,antall parkings in this address, empty parkings,
%%                   how many cars are in the line, min price and max price of parking


-module(parking).
-compile(export_all).
-include("../include/alpha_records.hrl").

-define(Url,"http://www.p-bolaget.goteborg.se/sv/hyra_parkering/Sok-p-plats/").  %% web page address for parking information.
%-record(parking,{address,antal,ko,ledig,minprice,maxprice,lat,lon}).  %% this record(data structure) is used for storing the information.


%%                   Catch the parkering page by sending the httpc request to the server
main()->
    
   % inets:start(),
    call_Inets(),

    {ok,{_Status,_Header,HTML}}=httpc:request(?Url),
    Main=mainPage(HTML),
    findValue(Main,[]).

%%        The way for solving this problem is:
%%              1- getting the main part of http page by asignnig the first position and end position of this main part.
%%              2- these positions are found by checking mannually in web page through finding the unique word or unique characters in the page.
%%              3- using a recursion method for wrapping the http page for two parts as two pages.
%%              4- first page which called Parkering is consist of information for one parking place.
%%                 - these information will parse in nextParkering function.
%%                 - the best way for doing this is using a recursion function for parsing all these information
%%                 - but here in this webpage there are some cases that makes most of them different of each other which I prepared to parse them directly.
%%                 - Store the parsed data in record after Parsing them.
%%                 - return these information and left page.
%%              5-if tbere is any information in left page then use recursion for wrapping this page again.
%%              6- if not then return the all data.

call_Inets()->
    case inets:start() of 
	{error,{already_started,inets}} ->
	    ok;
	ok ->
	    ok
    end.

findValue(MainPart,AppList)->
    {Parkering,LeftPage}= nextParkering(MainPart),
    case Parkering of
	null ->
	    AppList;
	_->
	    LeftPageLength=string:len(LeftPage),
	    case LeftPageLength < 56 of
		true ->
		    AppList;
        	false ->
		    findValue(LeftPage,[Parkering|AppList])
	    end
    end.

%%                 for caching the important part of page which it consists of all of parkering information
mainPage(Page)->
    End = string:str(Page, "</script><div id=\"GoogleMapArea\">")+33,
    Start = string:str(Page, "google.maps.LatLng")+18,
    MainPage=string:substr(Page,Start,End-Start),
    MainPage.




%%   this function is used for parsing the parkering information for the first parkering and will return these data and left page.
nextParkering(Page)->
    End = string:str(Page, "</script><div id=\"GoogleMapArea\">")+33,
    
    StartLatAndLon = string:str(Page, "google.maps.LatLng"), 
    StopLatAndLon= string:str(Page, ";var marker_")-1,
    case StopLatAndLon >0 of
	true ->
	    LatAndLon=string:substr(Page,StartLatAndLon+18,StopLatAndLon-StartLatAndLon-17),
	    Startlon = string:str(LatAndLon, "("), 
	    
	    Stoplon = string:str(LatAndLon, ","), 
	    Stoplat = string:str(LatAndLon, ")"), 
	    
	    Lon=string:substr(LatAndLon,Startlon+1,Stoplon-Startlon-1),
	    Lat=string:substr(LatAndLon,Stoplon+1,Stoplat-Stoplon-1),
	    
	    
	    Start = string:str(Page, "<b>"), 
	    Stop= string:str(Page, "</b>"),
	    Address = string:substr(Page, Start+3,Stop-Start-3),  
	    
	    PageWithoutAddress=string:substr(Page,Stop+4,End-Stop-4), 
	    
	    
	    Extra_b = string:str(PageWithoutAddress, "<b>"), 
	    End_Extra_b = string:str(PageWithoutAddress,"</script><div id=\"GoogleMapArea\">")+33,
	    PageWithout_b=string:substr(PageWithoutAddress,Extra_b+3,End_Extra_b-Extra_b-3), 
	    
	    
	    StartAntal = string:str(PageWithout_b, "</b>"), 
	    StopAntal= string:str(PageWithout_b, "<b>"),
	    Antal=string:substr(PageWithout_b,StartAntal+4,StopAntal-StartAntal-9), 
	    
	    EndWithoutAntal=string:str(PageWithout_b,"</script><div id=\"GoogleMapArea\">")+33,
	    PageWithoutAntal=string:substr(PageWithout_b,StopAntal+3,EndWithoutAntal-StopAntal-3), 
	    StartLedig = string:str(PageWithoutAntal, "</b>"), 
	    StopLedig= string:str(PageWithoutAntal, "<br />"),
	    Ledig=string:substr(PageWithoutAntal,StartLedig+4,StopLedig-StartLedig-7), 
	    
	    
	    EndWithoutLedig=string:str(PageWithoutAntal,"</script><div id=\"GoogleMapArea\">")+33,
	    PageWithoutLedig=string:substr(PageWithoutAntal,StopLedig+6,EndWithoutLedig-StopLedig-6), 
	    StartKo = string:str(PageWithoutLedig, "</b>"), 
	    StopKo= string:str(PageWithoutLedig, "<br />"),
	    Ko=string:substr(PageWithoutLedig,StartKo+4,StopKo-StartKo-7), 
	    
	    EndWithoutKo=string:str(PageWithoutLedig,"</script><div id=\"GoogleMapArea\">")+33,
	    PageWithoutKo=string:substr(PageWithoutLedig,StopKo+6,EndWithoutKo-StopKo-6), 
	    StartMinprice = string:str(PageWithoutKo, "</b>"), 
	    StopMinprice= string:str(PageWithoutKo, "<br />"),
	    Minprice=string:substr(PageWithoutKo,StartMinprice+4,StopMinprice-StartMinprice-15), 
	    

	    EndWithoutMinprice=string:str(PageWithoutKo,"</script><div id=\"GoogleMapArea\">")+33,
	    PageWithoutMinprice=string:substr(PageWithoutKo,StopMinprice+6,EndWithoutMinprice-StopMinprice-6), 
	    StartMaxprice = string:str(PageWithoutMinprice, "</b>"), 
	    StopMaxprice= string:str(PageWithoutMinprice, "</div>"),
	    Maxprice=string:substr(PageWithoutMinprice,StartMaxprice+4,3),
	    
	    
	    EndWithoutMaxprice=string:str(PageWithoutMinprice,"</script><div id=\"GoogleMapArea\">")+33,
	    PageWithoutMaxprice=string:substr(PageWithoutMinprice,StopMaxprice+6,EndWithoutMaxprice-StopMaxprice-6),


            {#parking{address=Address,antal=Antal,ko=Ko,ledig=Ledig,minprice=Minprice,maxprice=Maxprice,lat=Lat,lon=Lon},PageWithoutMaxprice};
	 
	    


             
	  
	false ->
	    {null,null}
    end.
