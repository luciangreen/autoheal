% Theorems, proved by exhaustion. Run: swipl -g main -t halt proofs/theorems.pl
:- module(theorems, [main/0]).
:- use_module(prove).
:- discontiguous theorem/1.
:- use_module(library(lists)).
:- use_module(library(apply)).
main :- prove_all(theorems).
:- use_module('../prolog/autoheal').

% Domain: every program in the space as the truth, test sets of one or two inputs of length 0..2 over 1..3,
% and every program as the current (possibly broken) version.
short(I) :- between(0, 2, N), length(I, N), maplist([X]>>between(1, 3, X), I).
tests(Truth, Ts) :- short(A), run(Truth, A, OA), ( Ts = [A-OA] ; short(B), A @< B, run(Truth, B, OB), Ts = [A-OA, B-OB] ).

% 1. A healed version passes every test.
theorem(healed_passes) :- forall(( spec(T), tests(T, Ts), member(C, [prim(reverse), prim(inc), then(tail, double)]), heal(C, Ts, healed(S)) ), passes(S, Ts)).

% 2. A version that already passes is never touched.
theorem(passing_left_alone) :- forall(( spec(T), tests(T, Ts) ), heal(T, Ts, already_passes)).

% 3. Tests made from a program in the space can always be healed.
theorem(always_healable_in_space) :- forall(( spec(T), tests(T, Ts), member(C, [prim(reverse), prim(evens)]) ), ( heal(C, Ts, H), H \== cannot_heal )).

% 4. The heal is a simplest one: no single step passes when it returns two steps.
theorem(simplest_heal) :- forall(( spec(T), tests(T, Ts), heal(prim(inc), Ts, healed(then(_, _))) ), \+ ( names_(Ns), member(F, Ns), passes(prim(F), Ts) )).
names_(Ns) :- autoheal:names(Ns).

% 5. failures lists exactly the failing tests.
theorem(failures_exact) :- forall(( spec(T), tests(T, Ts), spec(C) ), ( failures(C, Ts, Fs), iff(Fs == [], passes(C, Ts)) )).
counterexample(failures_exact, C-Ts-Fs) :- spec(T), tests(T, Ts), spec(C), failures(C, Ts, Fs), \+ iff(Fs == [], passes(C, Ts)).
