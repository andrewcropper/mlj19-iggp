:-['metagol'].
:-['mrules'].

:- use_module(library(lists)).
:- use_module(library(apply)).
:- use_module(library(pairs)).

metagol:max_clauses(100).

learn:-
    get_pos(Pos),
    get_neg(Neg),
    learn(Pos,Neg,Prog),
    pprint(Prog).

do_test :-
    get_pos(Pos),
    get_neg(Neg),
    maplist(test_pos,Pos),
    maplist(test_neg,Neg).

test_pos(Atom):-
    test_atom(Atom,1).
test_neg(Atom):-
    test_atom(Atom,0).
test_atom(Atom,Label):-
    catch((call(Atom) -> write_two(1,Label); write_two(0,Label)),_,write_two(0,Label)).

write_two(A,B):-
    format('~w,~w\n',[A,B]).

get_pos(Pos):-
    get_(pos,Pos).
get_neg(Neg):-
    get_(neg,Neg).
get_(Name,Xs):-
    (current_predicate(Name/1) -> findall(X,(Atom=..[Name,X],call(Atom)),Xs); Xs = []).