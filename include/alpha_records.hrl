-record(rental, {rooms,area,rent,address,district}).
-record(appartment,{location=undefined,published=undefined,rent=undefined,price=undefined,objType=undefined,orgin_SourceLink=undefined,rooms=undefined,area=undefined,construction_Type=undefined}).%ObjType={Villa|Lgh,Etc..},Orgin_SourceLink=URL(),Rooms,Area,Construction_Type={new,old}}).
-record(location,{position=undefined,street=undefined,city=undefined,muncipality=undefined,district=undefined}). %{streetAddress,city,MuncipalityName,countyName}
%% in maps {0,0} res in overall 
-record(position,{latitude=0,longitude=0}).
