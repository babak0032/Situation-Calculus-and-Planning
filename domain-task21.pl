


% ---------------------------------------------------------------------
%  ----- Informatics 2D - 2012/13 - Second Assignment - Planning -----
% ---------------------------------------------------------------------
%
% Write here you matriculation number (only - your name is not needed)
% Matriculation Number: s1245523
%
%
% ------------------------- Domain Definition -------------------------
% This file describes a planning domain: a set of predicates and
% fluents that describe the state of the system, a set of actions and
% the axioms related to them. More than one problem can use the same
% domain definition, and therefore include this file


% --- Cross-file definitions ------------------------------------------
% marks the predicates whose definition is spread across two or more
% files
%
:- multifile adjacent/2, at/3, carryPlate/1, hungry/1, clear/2, inBed/1.





% --- Primitive control actions ---------------------------------------
% this section defines the name and the number of parameters of the
% actions available to the planner
%
% primitive_action( dosomething(_,_) ).	% underscore means `anything'

primitive_action( move(_,_,_) ).
primitive_action( grab ).
primitive_action( dispose ).
primitive_action( feed ).



% --- Precondition for primitive actions ------------------------------
% describe when an action can be carried out, in a generic situation S
%
% poss( doSomething(...), S ) :- preconditions(..., S).


poss(move(O, X, Y), S) :-      %robot 'O' is moving from 'X' to 'Y'.
at(O, X, S),
clear(Y, S),
robot(O),       %means it is either the Nursebot or the wheelChair.
adjacent(X, Y).

poss(grab, S) :-
not(carryPlate(S)),
at(nB, a1, S).

poss(dispose, S) :-
carryPlate(S),
at(nB, a4, S).

poss(feed, S) :-
inBed(S),
hungry(S),
carryPlate(S),
at(nB, a3, S).



% --- Successor state axioms ------------------------------------------
% describe the value of fluent based on the previous situation and the
% action chosen for the plan. 
%
% fluent(..., result(A,S)) :- positive; previous-state, not(negative)

carryPlate(result(A, S)) :-
A = grab;
carryPlate(S), not(A = dispose).

at(O, X, result(A, S)) :-
A = move(O, _, X);
at(O, X, S), not(A = move(O, X, _)).

clear(X, result(A, S)) :-
A = move(_, X, _);
clear(X, S), not(A = move(_, _, X)).

hungry(result(A, S)) :-     %we do not have an action that makes a patient hungry!!
hungry(S), not(A = feed).   

inBed(result(A, S)) :-     %Another possible way to mention that the patient is in bed is not mentinoning that the patient is in bed at all, because we don't have an action "getUp patient", but I kept this as an axiom since I may want to add an action which makes the patient not be in bed.  
inBed(S).


%Total time running for 22: 0.057 s
%Total time running for 23: 0.132 s
%Total time running for 24: 38.827 s


% ---------------------------------------------------------------------
% ---------------------------------------------------------------------
