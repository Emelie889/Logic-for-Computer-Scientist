partstring([], _, _).
partstring(List, L, F) :-
    append(_, Temp, List),
    append(F, _, Temp),
    length(F, L),
    L>0.
