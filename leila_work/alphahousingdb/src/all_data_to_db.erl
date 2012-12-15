%% Author: leila
%% Created: Dec 12, 2012
%% Description: TODO: Add description to all_data_gb
-module(all_data_to_db).

%%This module process the data 
%% Include files
%%

%%
%% Exported Functions
%%
-export([all/0]).

all()->

spawn(stockholm, getEtl, []),
spawn(alpha_extract_M, download,[]),
spawn(boplats, main,[]),
spawn(ex_bopunkten, start, []).
%%
%% API Functions
%%



%%
%% Local Functions
%%

