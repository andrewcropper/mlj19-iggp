
%% ARITY 0
%% p :- q.
metarule([P,Q],([P,T]:-[[Q,T]])).
%% p :- q,r.
metarule([P,Q,R],([P,T]:-[[Q,T],[R,T]])):-freeze(Q,freeze(R,Q\=R)).
%% p :- q(A).
metarule([P,Q],([P,T]:-[[Q,T,_]])).
%% p :- q(A),r(A)
metarule([P,Q,R],([P,T]:-[[Q,T,A],[R,T,A]])):-freeze(Q,freeze(R,Q\=R)).
%% p :- q(A),r(B).
metarule([P,Q,R],([P,T]:-[[Q,T,_],[R,T,_]])):-freeze(Q,freeze(R,Q\=R)).
%% p :- q(A,B).
metarule([P,Q],([P,T]:-[[Q,T,_,_]])).
%% p :- q(A,B),r(A,B).
metarule([P,Q,R],([P,T]:-[[Q,T,A,B],[R,T,A,B]])):-freeze(Q,freeze(R,Q\=R)).


%%

%% ARITY 1
%% p(A):-q(A)
metarule([P,Q],([P,T,A]:-[[Q,T,A]])).
%% p(A):-q(A),r.
metarule([P,Q,R],([P,T,A]:-[[Q,T,A],[R,T]])).
%% p(A):-q(A),r(A)
metarule([P,Q,R],([P,T,A]:-[[Q,T,A],[R,T,A]])):-freeze(Q,freeze(R,Q\=R)).
%% p(A):-q(A,B).
metarule([P,Q],([P,T,A]:-[[Q,T,A,_]])).
%% p(A):-q(A,B),r(A,B)
metarule([P,Q,R],([P,T,A]:-[[Q,T,A,B],[R,T,A,B]])):-freeze(Q,freeze(R,Q\=R)).
%% p(A):-q(A),r(A,B)
metarule([P,Q,R],([P,T,A]:-[[Q,T,A],[R,T,A,_]])).
%% p(A):-q(A,B),r(B)
metarule([P,Q,R],([P,T,A]:-[[Q,T,A,B],[R,T,B]])).

%% ARITY 2
%% p(A,B):-q(A,B).
metarule([P,Q],([P,T,A,B]:-[[Q,T,A,B]])).
%% p(A,B):-q(A,B),r.
metarule([P,Q,R],([P,T,A,B]:-[[Q,T,A,B],[R,T]])).
%% p(A,B):-q(A,B),r(A,B)
metarule([P,Q,R],([P,T,A,B]:-[[Q,T,A,B],[R,T,A,B]])):-freeze(Q,freeze(R,Q\=R)).
%% p(A,B):-q(B,A).
metarule([P,Q],([P,T,A,B]:-[[Q,T,B,A]])).
%% p(A,B):-q(B,A),r(B,A)
metarule([P,Q,R],([P,T,A,B]:-[[Q,T,B,A],[R,T,B,A]])):-freeze(Q,freeze(R,Q\=R)).
%% p(A,B):-q(A),r(B)
metarule([P,Q,R],([P,T,A,B]:-[[Q,T,A],[R,T,B]])).
%% p(A,B):-q(A,B),r(B)
metarule([P,Q,R],([P,T,A,B]:-[[Q,T,A,B],[R,T,B]])).
%% p(A,B):-q(A),r(A,B)
metarule([P,Q,R],([P,T,A,B]:-[[Q,T,A],[R,T,A,B]])).
%% p(A,B):-q(A,C),r(C,B)
metarule([P,Q,R],([P,T,A,B]:-[[Q,T,A,C],[R,T,C,B]])). %% chain

%% ARITY 3

%% p(A,B,C):-q(A,B,C).
metarule([P,Q],([P,T,A,B,C]:-[[Q,T,A,B,C]])).
%% p(A,B,C):-q(A,B,C),r.
metarule([P,Q,R],([P,T,A,B,C]:-[[Q,T,A,B,C],[R,T]])).
%% p(A,B,C):-q(A,B,C),r(A,B,C).
metarule([P,Q,R],([P,T,A,B,C]:-[[Q,T,A,B,C],[R,T,A,B,C]])):-freeze(Q,freeze(R,Q\=R)). %% double ident
%% p(A,B,C):-q(A),r(B,C).
metarule([P,Q,R],([P,T,A,B,C]:-[[Q,T,A],[R,T,B,C]])).
%% p(A,B,C):-q(A,B),r(C).
metarule([P,Q,R],([P,T,A,B,C]:-[[Q,T,A,B],[R,T,C]])).

%% %% brute force
metarule([P,Q],([P,T,A,B,C]:-[[Q,T,A,C,B]])).
metarule([P,Q],([P,T,A,B,C]:-[[Q,T,B,A,C]])).
metarule([P,Q,R],([P,T,A,B,C]:-[[Q,T,A,B,D],[R,T,A,C,D]])).
metarule([P,Q,R],([P,T,A,B,C]:-[[Q,T,A,B,D],[R,T,B,C,D]])).



%% ARITY 4
%% brute force
metarule([P,Q],([P,T,A,B,C,D]:-[[Q,T,A,B,D,C]])).
metarule([P,Q],([P,T,A,B,C,D]:-[[Q,T,A,C,B,D]])).
metarule([P,Q],([P,T,A,B,C,D]:-[[Q,T,B,A,C,D]])).
metarule([P,Q,R],([P,T,A,B,C,D]:-[[Q,T,A,B,C,D],[R,T,A,B,C,D]])):-freeze(Q,freeze(R,Q\=R)). %% double ident
metarule([P,Q,R],([P,T,A,B,C,D]:-[[Q,T,A,B,C,E],[R,T,A,B,D,E]])).
metarule([P,Q,R],([P,T,A,B,C,D]:-[[Q,T,A,B,C,E],[R,T,A,C,D,E]])).
metarule([P,Q,R],([P,T,A,B,C,D]:-[[Q,T,A,B,C,E],[R,T,B,C,D,E]])).
metarule([P,Q,R],([P,T,A,B,C,D]:-[[Q,T,A,B,E,F],[R,T,C,D,E,F]])).

%% ARITY 5
%% brute force
metarule([P,Q],([P,T,A,B,C,D,E]:-[[Q,T,A,B,C,D,E]])).
metarule([P,Q],([P,T,A,B,C,D,E]:-[[Q,T,A,B,C,E,D]])).
metarule([P,Q],([P,T,A,B,C,D,E]:-[[Q,T,A,B,D,C,E]])).
metarule([P,Q],([P,T,A,B,C,D,E]:-[[Q,T,A,C,B,D,E]])).
metarule([P,Q],([P,T,A,B,C,D,E]:-[[Q,T,B,A,C,D,E]])).

%% ARITY 6
%% brute force
metarule([P,Q],([P,T,A,B,C,D,E,F]:-[[Q,T,A,B,C,D,E,F]])).
metarule([P,Q],([P,T,A,B,C,D,E,F]:-[[Q,T,A,B,C,D,F,E]])).
metarule([P,Q],([P,T,A,B,C,D,E,F]:-[[Q,T,A,B,C,E,D,F]])).
metarule([P,Q],([P,T,A,B,C,D,E,F]:-[[Q,T,A,B,D,C,E,F]])).
metarule([P,Q],([P,T,A,B,C,D,E,F]:-[[Q,T,A,C,B,D,E,F]])).
metarule([P,Q],([P,T,A,B,C,D,E,F]:-[[Q,T,B,A,C,D,E,F]])).

%% ARITY 7
%% brute force
metarule([P,Q],([P,T,A,B,C,D,E,F,G]:-[[Q,T,A,B,C,D,E,F,G]])).
metarule([P,Q],([P,T,A,B,C,D,E,F,G]:-[[Q,T,A,B,C,D,E,G,F]])).
metarule([P,Q],([P,T,A,B,C,D,E,F,G]:-[[Q,T,A,B,C,D,F,E,G]])).
metarule([P,Q],([P,T,A,B,C,D,E,F,G]:-[[Q,T,A,B,C,E,D,F,G]])).
metarule([P,Q],([P,T,A,B,C,D,E,F,G]:-[[Q,T,A,B,D,C,E,F,G]])).
metarule([P,Q],([P,T,A,B,C,D,E,F,G]:-[[Q,T,A,C,B,D,E,F,G]])).
metarule([P,Q],([P,T,A,B,C,D,E,F,G]:-[[Q,T,B,A,C,D,E,F,G]])).

%% ARITY 8
%% brute force
metarule([P,Q],([P,T,A,B,C,D,E,F,G,H]:-[[Q,T,A,B,C,D,E,F,G,H]])).
metarule([P,Q],([P,T,A,B,C,D,E,F,G,H]:-[[Q,T,A,B,C,D,E,F,H,G]])).
metarule([P,Q],([P,T,A,B,C,D,E,F,G,H]:-[[Q,T,A,B,C,D,E,G,F,H]])).
metarule([P,Q],([P,T,A,B,C,D,E,F,G,H]:-[[Q,T,A,B,C,D,F,E,G,H]])).
metarule([P,Q],([P,T,A,B,C,D,E,F,G,H]:-[[Q,T,A,B,C,E,D,F,G,H]])).
metarule([P,Q],([P,T,A,B,C,D,E,F,G,H]:-[[Q,T,A,B,D,C,E,F,G,H]])).
metarule([P,Q],([P,T,A,B,C,D,E,F,G,H]:-[[Q,T,A,C,B,D,E,F,G,H]])).
metarule([P,Q],([P,T,A,B,C,D,E,F,G,H]:-[[Q,T,B,A,C,D,E,F,G,H]])).

%% ARITY 10
%% brute force
metarule([P,Q],([P,T,A,B,C,D,E,F,G,H,I]:-[[Q,T,A,B,C,D,E,F,G,H,I]])).

%% CONSTANTS

%% DECREASE ARITY

%% p(a):-q.
metarule([P,Q,A],([P,T,A]:-[[Q,T]])).
%% p(a,b):-q.
metarule([P,Q,A,B],([P,T,A,B]:-[[Q,T]])).
%% p(a,B):-q(B).
metarule([P,Q,A],([P,T,A,B]:-[[Q,T,B]])).
%% p(A,x):-q(A).
metarule([P,Q,X],([P,T,A,X]:-[[Q,T,A]])).


%% THESE ALLOW CONSTANTS AS THE FIRST OR LAST ARGUMENT IN THE HEAD
%% p(x,A,B):-q(A,B).
metarule([P,Q,X],([P,T,X,A,B]:-[[Q,T,A,B]])).
%% p(A,B,x):-q(A,B).
metarule([P,Q,X],([P,T,A,B,X]:-[[Q,T,A,B]])). %% curry_down_3C (makes C a constant)
%% p(x,A,B,C):-q(A,B,C)
metarule([P,Q,X],([P,T,X,A,B,C]:-[[Q,T,A,B,C]])).
%% p(A,B,C,x):-q(A,B,C)
metarule([P,Q,X],([P,T,A,B,C,X]:-[[Q,T,A,B,C]])).
%% p(x,A,B,C,D):-q(A,B,C,D)
metarule([P,Q,X],([P,T,X,A,B,C,D]:-[[Q,T,A,B,C,D]])).
%% p(A,B,C,D,x):-q(A,B,C,D)
metarule([P,Q,X],([P,T,A,B,C,D,X]:-[[Q,T,A,B,C,D]])).
%% p(x,A,B,C,D,E):-q(A,B,C,D,E)
metarule([P,Q,X],([P,T,X,A,B,C,D,E]:-[[Q,T,A,B,C,D,E]])).
%% p(A,B,C,D,E,x):-q(A,B,C,D,E)
metarule([P,Q,X],([P,T,A,B,C,D,E,X]:-[[Q,T,A,B,C,D,E]])).
%% p(x,A,B,C,D,E,F):-q(A,B,C,D,E,F)
metarule([P,Q,X],([P,T,X,A,B,C,D,E,F]:-[[Q,T,A,B,C,D,E,F]])).
%% p(A,B,C,D,E,F,x):-q(A,B,C,D,E,F)
metarule([P,Q,X],([P,T,A,B,C,D,E,F,X]:-[[Q,T,A,B,C,D,E,F]])).
%% p(x,A,B,C,D,E,F,G):-q(A,B,C,D,E,F,G)
metarule([P,Q,X],([P,T,X,A,B,C,D,E,F,G]:-[[Q,T,A,B,C,D,E,F,G]])).
%% p(A,B,C,D,E,F,G,x):-q(A,B,C,D,E,F,G)
metarule([P,Q,X],([P,T,A,B,C,D,E,F,G,X]:-[[Q,T,A,B,C,D,E,F,G]])).
%% p(x,A,B,C,D,E,F,G,H):-q(A,B,C,D,E,F,G,H)
metarule([P,Q,X],([P,T,X,A,B,C,D,E,F,G,H]:-[[Q,T,A,B,C,D,E,F,G,H]])).
%% p(A,B,C,D,E,F,G,H,x):-q(A,B,C,D,E,F,G,H)
metarule([P,Q,X],([P,T,A,B,C,D,E,F,G,H,X]:-[[Q,T,A,B,C,D,E,F,G,H]])).

%% INCREASE ARITY
%% p :- q(x).
metarule([P,Q,X],([P,T]:-[[Q,T,X]])).
%% p :- q(a),r(b).
metarule([P,Q,R,A,B],([P,T]:-[[Q,T,A],[R,T,B]])).
%% p(A):-q(A,x)
metarule([P,Q,X],([P,T,A]:-[[Q,T,A,X]])).
%% p(A):-q(x,A)
metarule([P,Q,X],([P,T,A]:-[[Q,T,X,A]])).
%% p(A,B):-q(x,A,B)
metarule([P,Q,X],([P,T,A,B]:-[[Q,T,X,A,B]])).
%% p(A,B):-q(A,B,x)
metarule([P,Q,X],([P,T,A,B]:-[[Q,T,A,B,X]])).
%% p(A,B,C):-q(x,A,B,C)
metarule([P,Q,X],([P,T,A,B,C]:-[[Q,T,X,A,B,C]])).
%% p(A,B,C):-q(A,B,C,x)
metarule([P,Q,X],([P,T,A,B,C]:-[[Q,T,A,B,C,X]])).
%% p(A,B,C,D):-q(x,A,B,C,D)
metarule([P,Q,X],([P,T,A,B,C,D]:-[[Q,T,X,A,B,C,D]])).
%% p(A,B,C,D):-q(A,B,C,D,x)
metarule([P,Q,X],([P,T,A,B,C,D]:-[[Q,T,A,B,C,D,X]])).
%% p(A,B,C,D,E):-q(x,A,B,C,D,E)
metarule([P,Q,X],([P,T,A,B,C,D,E]:-[[Q,T,X,A,B,C,D,E]])).
%% p(A,B,C,D,E):-q(A,B,C,D,E,x)
metarule([P,Q,X],([P,T,A,B,C,D,E]:-[[Q,T,A,B,C,D,E,X]])).
%% p(A,B,C,D,E,F):-q(x,A,B,C,D,E,F)
metarule([P,Q,X],([P,T,A,B,C,D,E,F]:-[[Q,T,X,A,B,C,D,E,F]])).
%% p(A,B,C,D,E,F):-q(A,B,C,D,E,F,x)
metarule([P,Q,X],([P,T,A,B,C,D,E,F]:-[[Q,T,A,B,C,D,E,F,X]])).
%% p(A,B,C,D,E,F,G):-q(x,A,B,C,D,E,F,G)
metarule([P,Q,X],([P,T,A,B,C,D,E,F,G]:-[[Q,T,X,A,B,C,D,E,F,G]])).
%% p(A,B,C,D,E,F,G):-q(A,B,C,D,E,F,G,x)
metarule([P,Q,X],([P,T,A,B,C,D,E,F,G]:-[[Q,T,A,B,C,D,E,F,G,X]])).
%% p(A,B,C,D,E,F,G,H):-q(x,A,B,C,D,E,F,G,H)
metarule([P,Q,X],([P,T,A,B,C,D,E,F,G,H]:-[[Q,T,X,A,B,C,D,E,F,G,H]])).
%% p(A,B,C,D,E,F,G,H):-q(A,B,C,D,E,F,G,H,x)
metarule([P,Q,X],([P,T,A,B,C,D,E,F,G,H]:-[[Q,T,A,B,C,D,E,F,G,H,X]])).


%% ==========

%% INTRODUCE TERMINALS

%% p(A):-q(A),r.
metarule([P,Q,R],([P,T,A]:-[[Q,T,A],[R,T]])).
%% p(A,B):-q(A,B),r.
metarule([P,Q,R],([P,T,A,B]:-[[Q,T,A,B],[R,T]])).
%% p(A,B,C):-q(A,B,C),r.
metarule([P,Q,R],([P,T,A,B,C]:-[[Q,T,A,B,C],[R,T]])).

%% ABDUCTIONS
%% p(x) <-
metarule([P,X],([P,_T,X]:-[])).
%% p(x,y) <-
metarule([P,X,Y],([P,_T,X,Y]:-[])).
%% p(x,y,z) <-
metarule([P,X,Y,Z],([P,_T,X,Y,Z]:-[])).
%% p(x):-q(y)
metarule([P,Q,X,Y],([P,T,X]:-[[Q,T,Y]])).
%% p(x):-q(y,z)
metarule([P,Q,X,Y,Z],([P,T,X]:-[[Q,T,Y,Z]])).
%% p(x,y):-q(z)
metarule([P,Q,X,Y,Z],([P,T,X,Y]:-[[Q,T,Z]])).




