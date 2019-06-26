%% ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%% ;;; 8-Puzzle
%% ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%% ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%% ;;; Components
%% ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

%%   (role robot)

%%   (<= (base (cell ?m ?n ?t))
%%       (index ?m)
%%       (index ?n)
%%       (tile ?t))

%%   (base (step 0))

%%   (<= (base (step ?n))
%%       (successor ?m ?n))


%%   (<= (input robot (move ?m ?n))
%%       (index ?m)
%%       (index ?n))


%%   (index 1)
%%   (index 2)
%%   (index 3)

%%   (tile 1)
%%   (tile 2)
%%   (tile 3)
%%   (tile 4)
%%   (tile 5)
%%   (tile 6)
%%   (tile 7)
%%   (tile 8)
%%   (tile b)

%% ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%% ;;; init
%% ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

%%   (init (cell 1 1 8))
%%   (init (cell 1 2 7))
%%   (init (cell 1 3 6))
%%   (init (cell 2 1 5))
%%   (init (cell 2 2 4))
%%   (init (cell 2 3 3))
%%   (init (cell 3 1 2))
%%   (init (cell 3 2 1))
%%   (init (cell 3 3 b))
%%   (init (step 0))

%%   (succ 1 2)
%%   (succ 2 3)

%% ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%% ;;; legal
%% ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  %% (<= (legal robot (move ?m ?o))
  %%     (true (cell ?m ?n b))
  %%     (succ ?n ?o))

  %% (<= (legal robot (move ?m ?n))
  %%     (true (cell ?m ?o b))
  %%     (succ ?n ?o))

  %% (<= (legal robot (move ?m ?n))
  %%     (true (cell ?l ?n b))
  %%     (succ ?l ?m))

  %% (<= (legal robot (move ?l ?n))
  %%     (true (cell ?m ?n b))
  %%     (succ ?l ?m))

pos(legal_move(0,robot, 3, 2)).

legal_move(robot,A,B):-true_cell(A,C,b),succ(C,B).
legal_move(robot,A,B):-true_cell(A,C,b),succ(B,C).
legal_move(robot,A,B):-true_cell(C,B,b),succ(C,A).
legal_move(robot,A,B):-true_cell(C,B,b),succ(A,C).

legal_move(robot,A,B):-legal_move1(A,B,b).
legal_move1(A,B):-true_cell(A,C),succ(C,B).
legal_move1(A,B):-true_cell(A,C),succ(B,C).

%% my_true_cell(1,1, 1, 8).
%% my_true_cell(1,1, 2, 7).
%% my_true_cell(1,1, 3, 6).
%% my_true_cell(1,2, 1, 4).
%% my_true_cell(1,2, 2, 5).
%% my_true_cell(1,2, 3, b).
%% my_true_cell(1,3, 1, 1).
%% my_true_cell(1,3, 2, 2).
%% my_true_cell(1,3, 3, 3).

%% ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%% ;;; next
%% ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

%%   (<= (next (step ?x))
%%       (true (step ?y))
%%       (successor ?y ?x))

%%   (<= (next (cell ?x ?y b))
%%       (does robot (move ?x ?y)))

%%   (<= (next (cell ?u ?y ?z))
%%       (does robot (move ?x ?y))
%%       (true (cell ?u ?y b))
%%       (true (cell ?x ?y ?z))
%%       (distinct ?z b))

%%   (<= (next (cell ?x ?v ?z))
%%       (does robot (move ?x ?y))
%%       (true (cell ?x ?v b))
%%       (true (cell ?x ?y ?z))
%%       (distinct ?z b))

%%   (<= (next (cell ?u ?v ?z))
%%       (true (cell ?u ?v ?z))
%%       (does robot (move ?x ?y))
%%       (or (distinct ?x ?u) (distinct ?y ?v))
%%       (true (cell ?x1 ?y1 b))
%%       (or (distinct ?x1 ?u) (distinct ?y1 ?v)))

next_step(A):-true_step(B),succ(B,A).

next_cell(A,B,b):-does_move(robot,A,B).

next_cell(U,Y,Z):-
    does_move(robot,X,Y),
    true_cell(U,Y,b),
    true_cell(X,Y,Z),
    distinct(Z,b).


%% ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%% ;;; goal
%% ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

%%   (<= (goal robot ?n)
%%       inorder
%%       (true (step ?k))
%%       (scoremap ?k ?n))

%%   (<= (goal robot 0)
%%       (not inorder))

%% ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%% ;;; terminal
%% ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

%%   (<= terminal inorder)
%%   (<= terminal (true (step 50)))

%% ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%% ;;; Views
%% ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

%%   (<= inorder
%%       (true (cell 1 1 1))
%%       (true (cell 1 2 2))
%%       (true (cell 1 3 3))
%%       (true (cell 2 1 4))
%%       (true (cell 2 2 5))
%%       (true (cell 2 3 6))
%%       (true (cell 3 1 7))
%%       (true (cell 3 2 8))
%%       (true (cell 3 3 b)))

%% ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%% ;;; Data
%% ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

%%   (successor 0 1)
%%   (successor 1 2)
%%   (successor 2 3)
%%   (successor 3 4)
%%   (successor 4 5)
%%   (successor 5 6)
%%   (successor 6 7)
%%   (successor 7 8)
%%   (successor 8 9)
%%   (successor 9 10)
%%   (successor 10 11)
%%   (successor 11 12)
%%   (successor 12 13)
%%   (successor 13 14)
%%   (successor 14 15)
%%   (successor 15 16)
%%   (successor 16 17)
%%   (successor 17 18)
%%   (successor 18 19)
%%   (successor 19 20)
%%   (successor 20 21)
%%   (successor 21 22)
%%   (successor 22 23)
%%   (successor 23 24)
%%   (successor 24 25)
%%   (successor 25 26)
%%   (successor 26 27)
%%   (successor 27 28)
%%   (successor 28 29)
%%   (successor 29 30)
%%   (successor 30 31)
%%   (successor 31 32)
%%   (successor 32 33)
%%   (successor 33 34)
%%   (successor 34 35)
%%   (successor 35 36)
%%   (successor 36 37)
%%   (successor 37 38)
%%   (successor 38 39)
%%   (successor 39 40)
%%   (successor 40 41)
%%   (successor 41 42)
%%   (successor 42 43)
%%   (successor 43 44)
%%   (successor 44 45)
%%   (successor 45 46)
%%   (successor 46 47)
%%   (successor 47 48)
%%   (successor 48 49)
%%   (successor 49 50)

%%   (scoremap 26 100)
%%   (scoremap 27 100)
%%   (scoremap 28 100)
%%   (scoremap 29 100)
%%   (scoremap 30 100)
%%   (scoremap 31 98)
%%   (scoremap 32 96)
%%   (scoremap 33 94)
%%   (scoremap 34 92)
%%   (scoremap 35 90)
%%   (scoremap 36 88)
%%   (scoremap 37 86)
%%   (scoremap 38 84)
%%   (scoremap 39 82)
%%   (scoremap 40 80)
%%   (scoremap 41 78)
%%   (scoremap 42 76)
%%   (scoremap 43 74)
%%   (scoremap 44 72)
%%   (scoremap 45 70)
%%   (scoremap 46 68)
%%   (scoremap 47 66)
%%   (scoremap 48 64)
%%   (scoremap 49 62)
%%   (scoremap 50 60)


%% ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%% ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%% ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;