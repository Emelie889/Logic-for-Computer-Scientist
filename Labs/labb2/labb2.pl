verify(InputFileName) :-
    see(InputFileName),
    read(Prems), read(Goal), read(Proof),
    seen,
    valid_proof(Prems, Goal, Proof, Proof).

valid_proof(Prems, Goal, [X|[]], Bag):-
    (premiss(X, Prems, Bag) ; copy(X, Bag) ;
    andintro(X, Bag) ; andelleft(X, Bag) ;
    andelright(X, Bag) ; orintleft(X, Bag) ;
    orintright(X, Bag) ; orel(X, Bag) ;
    impint(X, Bag) ; impel(X, Bag) ;
    negint(X, Bag) ; negel(X, Bag) ;
    contel(X, Bag) ; negnegint(X, Bag) ;
    negnegel(X, Bag) ; mt(X, Bag) ; pbc(X, Bag) ;
    lem(X) ; box(Prems, X, Bag)),
    X = [_, Goal, _].

valid_proof(Prems, Goal, [X|T], Bag):-
    (premiss(X, Prems, Bag) ; copy(X, Bag) ;
    andintro(X, Bag) ; andelleft(X, Bag) ;
    andelright(X, Bag) ; orintleft(X, Bag) ;
    orintright(X, Bag) ; orel(X, Bag) ;
    impint(X, Bag) ; impel(X, Bag) ;
    negint(X, Bag) ; negel(X, Bag) ;
    contel(X, Bag) ; negnegint(X, Bag) ;
    negnegel(X, Bag) ; mt(X, Bag) ; pbc(X, Bag) ;
    lem(X) ; box(Prems, X, Bag)),
    valid_proof(Prems, Goal, T, Bag).

%ruuuuuuuuules---------

%And introduction
andintro([Num, and(X, Y), andint(Pos1, Pos2)], Bag):-
    Num > Pos1,
    Num > Pos2,
    member([Pos1, X, _], Bag),
    member([Pos2, Y, _], Bag).

%And elimination of left field
andelleft([Num, X, andel1(Pos)], Bag):-
    Num > Pos,
    member([Pos, and(X, _), _], Bag).
%right field
andelright([Num, X, andel2(Pos)], Bag) :-
    Num > Pos,
    member([Pos, and(_, X), _], Bag).
%eller int left field
orintleft([Num, or(X,_), orint1(Pos)], Bag) :-
    Num > Pos,
    member([Pos, X,_], Bag).
%eller int right
orintright([Num, or(_,X), orint2(Pos)], Bag) :-
    Num > Pos,
    member([Pos, X, _], Bag).
%eller elimination
orel([Num, Z, orel(Pos1, Pos2, Pos3, Pos4, Pos5)], Bag) :-
    Num > Pos1,
    Num > Pos2,
    Num > Pos3,
    Num > Pos4,
    Num > Pos5,
    member([Pos1, or(X, Y), _], Bag),

    member([[Pos2, X, assumption]|Box1], Bag),
    lastBoxLine([[Pos2, X, assumption]|Box1], LastLine1),
    [Pos3, Z, _] = LastLine1,
    member([[Pos4, Y, assumption]|Box2], Bag),
    lastBoxLine([[Pos4, Y, assumption]|Box2], LastLine2),
    [Pos5, Z, _] = LastLine2.
%implication el
impel([Num, X, impel(Pos1, Pos2)], Bag) :-
    Num > Pos1,
    Num > Pos2,
    member([Pos1, Y, _], Bag),
    member([Pos2, imp(Y, X), _], Bag).
%impliaction int
impint([Num, imp(X, Y), impint(Pos1, Pos2)], Bag) :-
    Num > Pos1,
    Num > Pos2,
    member([[Pos1, X, assumption]|Box], Bag),
    lastBoxLine([[Pos1, X, assumption]|Box], LastLine),
    [Pos2, Y, _] = LastLine.
%negation int
negint([Num, neg(X), negint(Pos1, Pos2)], Bag) :-
    Num > Pos1,
    Num > Pos2,
    member([[Pos1, X, assumption]|Box], Bag),
    lastBoxLine([[Pos1, X, assumption]|Box], LastLine),
    [Pos2, cont, _] = LastLine.
%copy
copy([Num, X, copy(Pos1)], Bag) :-
    Num > Pos1,
    member([Pos1, X, _], Bag).
%premiss
premiss([_, X, premise], Prems, _) :-
    member(X, Prems).
%negneg intro
negnegint([Num, neg(neg(X)), negnegint(Pos1)], Bag) :-
    Num > Pos1,
    member([Pos1, X, _], Bag).
%negneg elim
negnegel([Num, X, negnegel(Pos1)], Bag) :-    Num > Pos1,
    member([Pos1, neg(neg(X)), _], Bag).
%negation elim
negel([Num, cont, negel(Pos1, Pos2)], Bag) :-
    Num > Pos1,
    Num > Pos2,
    member([Pos1, X, _], Bag),
    member([Pos2, neg(X), _], Bag).
%contel
contel([Num, _, contel(Pos1)], Bag) :-
    Num > Pos1,
    member([Pos1, cont, _], Bag).
%PBC
pbc([Num, X, pbc(Pos1, Pos2)], Bag) :-
    Num > Pos1,
    Num > Pos2,
    member([[Pos1, neg(X), assumption]|Box], Bag),
    lastBoxLine([[Pos1, neg(X), assumption]|Box], LastLine),
    [Pos2, cont, _] = LastLine.

%MT
mt([Num, neg(X), mt(Pos1, Pos2)], Bag) :-
    Num > Pos1,
    Num > Pos2,
    member([Pos1, imp(X, Y), _], Bag),
    member([Pos2, neg(Y), _], Bag).
%LEM
lem([_, or(X,neg(X)), lem]).

%BOX------------
box(_, [X], Bag):-
    X = [_, _, assumption],
    append([X], Bag, _).

box(Prems, [X|T], Bag):-
    X = [_, _, assumption],
    append([X|T], Bag, Bevis),
    valid_proof(Prems, _, T, Bevis).

lastBoxLine([[Num, X, Rule]], [Num, X, Rule]).

lastBoxLine([_|T], Next) :-
    lastBoxLine(T, Next).
