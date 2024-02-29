remove_duplicates([], []).

remove_duplicates([H1|T1], [H1|T2]) :-
    remove(H1, T1, E),
    !,
    remove_duplicates(E, T2).

remove(_, [], []).

remove(H1, [H1|T1], E) :- % om H1 finns i tailen
	remove(H1, T1, E).    % tar bort alla H1 i tailen

remove(H1, [H2|T1], [H2|T2]) :-  %"tar bort" alla andra värden som ej är H1
	remove(H1, T1, T2).
