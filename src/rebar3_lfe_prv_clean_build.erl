-module(rebar3_lfe_prv_clean_build).

-export([init/1,
         do/1,
         format_error/1]).

-include("rebar3_lfe.hrl").

-define(PROVIDER, 'clean-build').
-define(DEPS, [{default, clean}]).

%% =============================================================================
%% Plugin API
%% =============================================================================

init(State) ->
  Description = "Remove the rebar _build directory",
  Provider = providers:create([
      {namespace,  ?NAMESPACE},
      {name,       ?PROVIDER},
      {module,     ?MODULE},
      {bare,       true},
      {deps,       ?DEPS},
      {example,    "rebar3 lfe clean-build"},
      {opts,       []},
      {short_desc, Description},
      {desc,       info(Description)}
  ]),
  {ok, rebar_state:add_provider(State, Provider)}.

do(State) ->
    rebar_paths:set_paths([deps, plugins], State),
    rebar3_lfe_clean:apps_build(State),
    {ok, State}.

format_error(Reason) ->
    io_lib:format("~p", [Reason]).

%% =============================================================================
%% Internal functions
%% =============================================================================

info(Description) ->
    io_lib:format(
        "~n~s~n"
        "~n"
        "This entirely deletes the ./_build directory created by rebar3.~n",
        [Description]).
