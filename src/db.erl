-module(db).

-export([new/0, destroy/1, write/3, read/2, delete/2, match/2, merge/2]).

-record(db_entry, {key = undefined, elem = undefined}).

%% Creates a new database
new() ->
	[].

%% Obviously totaly and utterly destroys the database
destroy(_Db) ->
	ok.

%% Calles write/4 to add a temporary storage list
%% if the Db variable is a list
write(Key, Elem, Db) when is_list(Db) == true ->
	write(Key, Elem, Db, []);
%% If a list was not passed as the database an error is given
write(_Key, _Elem, _NotADb) ->
	{error, not_a_db}.

%% If both database and store is empty add the newly created record to a list and return it
write(Key, Elem, [], []) ->
	[#db_entry{key = Key, elem = Elem}];
%% If the database list is empty but the store isn't the key is free in the database
%% add the new record as the head of the store list and return the new list
write(Key, Elem, [], Store) ->
	[#db_entry{key = Key, elem = Elem} | Store];
%% When the key of the head doens't match the new item add the old record to the store
%% then recurse on the tail of the database list
write(Key, Elem, [H | T], Store) when H#db_entry.key /= Key ->
	write(Key, Elem, T, [H | Store]);
%% When the key of the head mathces the new item recurse on the tail of the database list
%% ignoring the old record, letting the new one be added to the end of the database list
write(Key, Elem, [_H | T], Store) ->
	write(Key, Elem, T, Store).

%% If the key is not found return an error
read(_Key, []) ->
	{error, instance_not_found};
%% If the database given is not a list an error is given
read(_Key, _NotADb) when is_list(_NotADb) == false ->
	{error, not_a_db};
%% If the key matches the head return the element value
read(Key, [H | _T]) when H#db_entry.key == Key ->
	{ok, H#db_entry.elem};
%% If the key doesn't match the head but the list is not empty recurse on the tail
read(Key, [_H | T]) ->
	read(Key, T).

%% Call delete/3 to add a temporary storage list
%% if the Db variable is a list
delete(Key, Db) when is_list(Db) == true ->
	delete(Key, Db, []);
%% If the database is not a list an error is given
delete(_Key, _NotADb) ->
	{error, not_a_db}.
	
%% After the list has been searched (and the key possibly deleted) return the remaining stored items
delete(_Key, [], Store) ->
	Store;
%% When the key doens't match the head add the head to the store and recurse on the tail
delete(Key, [H | T], Store) when H#db_entry.key /= Key ->
	delete(Key, T, [H | Store]);
%% When the key does match ignore the head and recurse on the tail
delete(Key, [_H | T], Store) ->
	delete(Key, T, Store).
	
%% Call match/3 to add a temporary storage list
%% if the Db variable is a list
match(Elem, Db) when is_list(Db) == true ->
	match(Elem, Db, []);
%% If the database is not a list an error is given
match(_Elem, _NotADb) ->
	{error, not_a_db}.

%% When the list is empty return the stored list of matched items
match(_Elem, [], Store) ->
	Store;
%% If the element value of the head matches the requested element add the key to the store list
%% then recurse on the tail
match(Elem, [H | T], Store) when H#db_entry.elem == Elem ->
	match(Elem, T, [H#db_entry.key | Store]);
%% If the element value doens't match ignore the head and recurse on the tail
match(Elem, [_H | T], Store) ->
	match(Elem, T, Store).

%% Checks if the databases are both lists
%% If they are it calls merge_v/2
merge(Db1, Db2) when (is_list(Db1) == true) and (is_list(Db2) == true)->
	merge_v(Db1, Db2);	
%% If one of the passed databases is not a list an error is given
merge(_NotADb1, _NotADb2) ->
	{error, not_a_db}.
	
%% When the first database is empty return the second database
merge_v([], Db) ->
	Db;	
%% Use the write function to write the head of the first database into the second database
%% (letting write check if it exsists already and checking if it's a record of type db_entry) 
%% then recurse on the tail of the first database 
merge_v([H | T], Db2) when is_record(H,db_entry) == true ->
	merge_v(T, write(H#db_entry.key,H#db_entry.elem,Db2));
%% Throws the malformed list entry and recurses on the remaining list
merge_v([_H | T], Db2) ->
	merge_v(T, Db2).