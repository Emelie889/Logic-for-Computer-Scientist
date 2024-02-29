% Predicate to find a path from A to B and save it in Paths.
path(A, B, Paths) :-
    walk(A, B, [A], Paths).

% Base case: If A is equal to B, we have reached the destination.
walk(A, A, Visited, Visited).

% Recursive case: Check if there is an edge from A to X,
% and if there is a path from X to B, append X to the Path.
walk(A, B, Visited, Paths) :-
    edge(A, X),
    \+ member(X, Visited),
    walk(X, B, [X|Visited], Paths).

node(a).
node(b).
node(c).
node(d).
node(e).
node(f).

edge(a, e).
edge(e, d).
edge(d, c).
edge(c, b).
edge(b, a).
edge(d, a).
edge(e, c).
edge(f, b).
