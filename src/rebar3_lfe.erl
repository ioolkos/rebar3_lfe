-module(rebar3_lfe).

-export([init/1]).

-spec init(rebar_state:t()) -> {ok, rebar_state:t()}.
init(State) ->
  Commands = [ fun rebar3_lfe_prv_compile:init/1,
               fun rebar3_lfe_prv_escriptize:init/1,
               fun rebar3_lfe_prv_repl:init/1,
               fun rebar3_lfe_prv_run:init/1
             ],
  FoldFun  = fun(F, {ok, StateAcc}) -> F(StateAcc) end,
  lists:foldl(FoldFun, {ok, State}, Commands).
