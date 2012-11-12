{application, ecouch,
 [
  {description, "CouchDb API"},
  {vsn, "0.1"},
  {id, "ecouch"},
  {modules,      [ec_listener, ec_client, rfc4627]},
  {registered,   [ec_client_sup, ec_listener]},
  {applications, [kernel, stdlib]},
  %%
  %% mod: Specify the module name to start the application, plus args
  %%
  {mod, {ecouch, {"127.0.0.1", "5984"}}},
  {env, []}
 ]
}.


%%Ok, here's an example of an app file. This is used to bootstrap an application in erlang.

%% ecouch does all that for you.
%% open: This is done through the starting of the app file of ecouch. It creates a binding to the couchdb server.
%% fill + query: This is is handled by the ecouch api plus some additional json manipulation.
