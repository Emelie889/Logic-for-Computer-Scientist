% For SICStus, uncomment line below: (needed for member/2)
%:- use_module(library(lists)).
% Load model, initial state and formula from the file.
verify(Input) :-
    see(Input),
    read(T),
    read(L),
    read(S),
    read(F),
    seen,
    check(T, L, S, [], F).

% Literals
check(_, L, S, _, X) :-
    list(L, S, T1),
    member(X, T1).

check(_, L, S, _, neg(X)) :-
    list(L, S, T1),
    \+ member(X, T1).

% And
check(T, L, S, U, and(F, G)) :-
    check(T, L, S, U, F),
    check(T, L, S, U, G).

% Or
check(T, L, S, U, or(F, G)) :-
    (check(T, L, S, U, F) ; check(T, L, S, U, G)).

% AX
check(T, L, S, U, ax(F)) :-
    list(T, S, T1),
    allStates(T, L, T1, U, F).

% EX
check(T, L, S, U, ex(F)) :-
    list(T, S, T1),
    states(T, L, T1, U, F).

% AG
check(_, _, S, U, ag(_)) :-
    member(S, U), !.

check(T, L, S, U, ag(F)) :-
    check(T, L, S, [S | U], F),
    list(T, S, T1),
    allStates(T, L, T1, [S | U], F).

% EG
check(_, _, S, U, eg(_)) :-
    member(S, U), !.

check(T, L, S, U, eg(F)) :-
    check(T, L, S, [S | U], F),
    list(T, S, T1),
    states(T, L, T1, [S | U], F).

% EF
check(T, L, S, U, ef(F)) :-
    \+ member(S, U),
    check(T, L, S, [S | U], F).

check(T, L, S, U, ef(F)) :-
    \+ member(S, U),
    list(T, S, T1),
    states(T, L, T1, [S | U], F).

% AF
check(T, L, S, U, af(F)) :-
    \+ member(S, U),
    check(T, L, S, [S | U], F).

check(T, L, S, U, af(F)) :-
    \+ member(S, U),
    list(T, S, T1),
    allStates(T, L, T1, [S | U], F).

list([[S, K] | _], S, K).

list([_|T1], S, K) :-
    list(T1, S, K).

allStates(_, _, [], _, _).

allStates(T, L, [H | T1], U, B) :-
    check(T, L, H, U, B),
    allStates(T, L, T1, U, B).

states(_, _, [], _, _).

states(T, L, [Next | T1], U, B) :-
    check(T, L, Next, U, B).
