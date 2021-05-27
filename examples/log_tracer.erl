-module(log_tracer).

-include_lib("emqx_resource/include/emqx_resource_mod.hrl").

-emqx_resource_api_path("/log_tracer").

-export([ on_start/2
        , on_stop/2
        , on_query/4
        , on_health_check/2
        ]).

%% callbacks
-export([format_data/1]).

on_start(InstId, Config) ->
    io:format("== the demo log tracer ~p started.~nconfig: ~p~n", [InstId, Config]),
    {ok, #{logger_handler_id => abc, health_checked => 0}}.

on_stop(InstId, State) ->
    io:format("== the demo log tracer ~p stopped.~nstate: ~p~n", [InstId, State]),
    ok.

on_query(InstId, Request, AfterQuery, State) ->
    io:format("== the demo log tracer ~p received request: ~p~nstate: ~p~n",
        [InstId, Request, State]),
    emqx_resource:query_success(AfterQuery),
    "this is a demo log messages...".

on_health_check(InstId, State = #{health_checked := Checked}) ->
    NState = State#{health_checked => Checked + 1},
    io:format("== the demo log tracer ~p is working well~nstate: ~p~n", [InstId, NState]),
    {ok, NState}.

format_data(#{id := Id, status := Status, state := #{health_checked := NChecked}}) ->
    #{id => list_to_binary(Id), status => Status, checked_count => NChecked}.
