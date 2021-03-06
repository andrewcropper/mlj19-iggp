%% ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%% ;;; Minimal Even
%% ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

%% (<= (legal player (choose ?x)) (num ?x))

%% (<= (next (chosen ?x)) (does player (choose ?x)))
%% (<= (next (chosen ?x)) (true (chosen ?x)))

%% (<= terminal (true (chosen ?x)) (even ?x))

%% (<= (goal player 10) (true (chosen ?x)) (even ?x))

%% (<= (num ?x) (succ ?x ?y))
%% (<= (num ?y) (succ ?x ?y))

%% (succ 0  1)
%% (succ 1  2)
%% (succ 2  3)
%% (succ 3  4)
%% (succ 4  5)
%% (succ 5  6)
%% (succ 6  7)
%% (succ 7  8)
%% (succ 8  9)
%% (succ 9  10)

%% (even 0)
%% (<= (even ?x) (even ?y) (succ ?y ?z) (succ ?z ?x))

legal_choose(player,A):-num(A).

next_chosen(X):-does_chose(player,X).
next_chosen(X):-true_chosen(X).

goal(player,10):-true_chosen(X),even(X).


%% (<= terminal (true (chosen ?x)) (even ?x))

terminal:- true_chosen(A),even(A).