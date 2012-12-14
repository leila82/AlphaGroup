# Alpha Housing



#Instructions to Run

Setup
	Yaws server running on local host with the following configuration
	 In yaws.conf
	    -Set 
	    	 runmod = activity
	    	 ebin_dir = [absolute path]/AlphaGroup/ebin
		 include_dir = [absolute path]/AlphaGroup/include/
		 include_dir = [absolute]/AlphaGroup/src/Interface
	    -In Virtual sever setup set doc root to [path]/AlphaGroup/src/Interface
	    	appmods = <cgi-bin, yaws_appmod_cgi>
	

	CouchDB
		There should be three databases created under names #gothenburg #malmo #stockholm
		These should be contained with design documents submitted with the project in Couch_DB folder
		

- Start the Yaws server
- Go to the localhost(virtual server, depends on what adress you had given in yaws.conf for virtiual server setup)