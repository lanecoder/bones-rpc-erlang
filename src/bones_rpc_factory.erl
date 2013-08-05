%%%-------------------------------------------------------------------
%%% @author Andrew Bennett <andrew@pagodabox.com>
%%% @copyright 2013, Pagoda Box, Inc.
%%% @doc
%%%
%%% @end
%%% Created :   18 Jul 2013 by Andrew Bennett <andrew@pagodabox.com>
%%%-------------------------------------------------------------------
-module(bones_rpc_factory).

-include("bones_rpc.hrl").

%% API
-export([build/1]).

%%%===================================================================
%%% API functions
%%%===================================================================

build({ext, Head, Data}) ->
    {ok, #bones_rpc_ext_v1{head=Head, data=Data}};
build({synchronize, ID, Adapter}) when is_binary(Adapter) ->
    Head = 0,
    Data = << ID:4/big-unsigned-integer-unit:8, Adapter/binary >>,
    build({ext, Head, Data});
build({acknowledge, ID, Ready}) when is_boolean(Ready) ->
    Head = 1,
    Data = << ID:4/big-unsigned-integer-unit:8, case Ready of false -> 16#C2; true -> 16#C3 end >>,
    build({ext, Head, Data});
build({request, ID, Method, Params}) ->
    {ok, [?BONES_RPC_REQUEST, ID, Method, Params]};
build({response, ID, Error, Result}) ->
    {ok, [?BONES_RPC_RESPONSE, ID, Error, Result]};
build({notify, Method, Params}) ->
    {ok, [?BONES_RPC_NOTIFY, Method, Params]};
build(_) ->
    {error, badarg}.

%%%-------------------------------------------------------------------
%%% Internal functions
%%%-------------------------------------------------------------------