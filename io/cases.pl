:- module(cases, [title/1, case/3]).
:- use_module('../prolog/autoheal').
:- use_module(engine).
title('autoheal').
list_g(L) :- rnd_int(0, 5, N), length(L, N), maplist([X]>>rnd_int(0, 9, X), L).
spec_g(S) :- findall(X, spec(X), Ss), rnd_pick(Ss, S).
tests_g(Ts) :- spec_g(T), rnd_int(1, 3, K), length(Ts, K), maplist([I-O]>>( list_g(I), run(T, I, O) ), Ts).
case(heal, [C, Ts], heal) :- spec_g(C), tests_g(Ts).
case(failures, [C, Ts], failures) :- spec_g(C), tests_g(Ts).
case(heal_noise, [C, Ts], heal) :- spec_g(C), rnd_int(1, 2, K), length(Ts, K), maplist([I-O]>>( list_g(I), list_g(O) ), Ts).
