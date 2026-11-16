% autoheal: when a predicate fails its tests, regenerate it from them. The tests are
% Input-Output pairs; the current version and its replacements come from a space of simple
% list programs (one step, or one step after another). autoheal keeps the current version if it
% passes, else returns the simplest version in the space that passes every test, or says it
% cannot heal (no version passes).
%?- heal(prim(reverse), [[1,2]-[1,2], [2,1]-[1,2]], H).     % H = healed(prim(msort))
%?- heal(prim(msort), [[2,1]-[1,2]], H).                   % H = already_passes
%?- heal(prim(inc), [[1]-[5,5]], H).                       % H = cannot_heal
:- module(autoheal, [prim/3, spec/1, run/3, passes/2, heal/3, failures/3]).
:- use_module(library(lists)).
:- use_module(library(apply)).

prim(reverse, L, R) :- reverse(L, R).
prim(msort, L, R) :- msort(L, R).
prim(dedupe, L, R) :- sort(L, R).
prim(tail, L, R) :- ( L = [_|T] -> R = T ; R = [] ).   % steadfast: binds R only after choosing the branch
prim(double, L, R) :- maplist([X, Y]>>(Y is 2 * X), L, R).
prim(inc, L, R) :- maplist([X, Y]>>(Y is X + 1), L, R).
prim(evens, L, R) :- include([X]>>(X mod 2 =:= 0), L, R).
names([reverse, msort, dedupe, tail, double, inc, evens]).

spec(prim(F)) :- names(Ns), member(F, Ns).
spec(then(F, G)) :- names(Ns), member(F, Ns), member(G, Ns).
run(prim(F), I, O) :- prim(F, I, O).
run(then(F, G), I, O) :- prim(F, I, M), prim(G, M, O).

passes(S, Tests) :- forall(member(I-O, Tests), run(S, I, O)).
failures(S, Tests, Fs) :- findall(I-want(O)-got(G), ( member(I-O, Tests), run(S, I, G), G \== O ), Fs).

heal(Cur, Tests, H) :- ( passes(Cur, Tests) -> H = already_passes ; spec(S), passes(S, Tests) -> H = healed(S) ; H = cannot_heal ).
