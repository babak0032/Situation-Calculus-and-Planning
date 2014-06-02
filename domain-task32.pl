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
:- multifile adjacent/2, at/3, carryPlate/1, hungry/1, clear/2, inBed/1, isOut/1, patientOnWheelChair/1.





% --- Primitive control actions ---------------------------------------
% this section defines the name and the number of parameters of the
% actions available to the planner
%
% primitive_action( dosomething(_,_) ).	% underscore means `anything'

primitive_action( move(_,_,_) ).
primitive_action( grab ).
primitive_action( dispose ).
primitive_action( feed ).
primitive_action( load ).
primitive_action( open ).
primitive_action( getOut).
primitive_action( hopOn).
primitive_action( hopOf(_)).



% --- Precondition for primitive actions ------------------------------
% describe when an action can be carried out, in a generic situation S
%
% poss( doSomething(...), S ) :- preconditions(..., S).


poss(move(O, X, Y), S) :-   %robot 'O' is moving from 'X' to 'Y'.
robot(O),
adjacent(X, Y),
clear(Y, S),
at(O, X, S),
(not(nursebotOnWheelChair(S)) ; not(O = nB)). 

poss(grab, S) :-      %Nursebot grabbing the plate
not(carryPlate(S)),
at(nB, a1, S),
at(plate, a1, S).

poss(dispose, S) :-  %Nursebot disposing the plate.
carryPlate(S),
at(nB, a4, S).

poss(feed, S) :-  %Nursebot feeding the patient.
inBed(S),
hungry(S),
carryPlate(S),
at(nB, a3, S).

poss(load, S) :-  %Nursebot Loading the patient.
at(nB, a6, S),
at(w, a5, S),
not(nursebotOnWheelChair(S)),
inBed(S),
not(hungry(S)).

poss(open, S) :-  %Nursebot Opening the door.
at(nB, a5, S),
not(doorIsOpen(S)).

poss(close, S) :-  %Nursebot closing the door.
at(nB, a5, S),
doorIsOpen(S).

poss(getOut, S) :-  %patient And WheelChair going out together.
doorIsOpen(S),
patientOnWheelChair(S),
at(w, a5, S),
not(isOut(S)).

poss(hopOn, S) :-  %Nursebot hoping on the wheelchair.
at(nB, X ,S),
at(w, Y, S),
adjacent(X, Y),
not(patientOnWheelChair(S)).

poss(hopOf(X), S) :-  %Nursebot hoping of the wheelchair.
at(w, Y, S),
adjacent(X, Y),
clear(X, S),
nursebotOnWheelChair(S).





% --- Successor state axioms ------------------------------------------
% describe the value of fluent based on the previous situation and the
% action chosen for the plan. 
%
% fluent(..., result(A,S)) :- positive; previous-state, not(negative)

carryPlate(result(A, S)) :-
A = grab;
carryPlate(S), not(A = dispose).


%With the action "hopOn" and "hopOf", the "at" axiom becomes really the different betwwen wheelchair and nursebot. so to make thing clear, we hvae to split them into two parts. one part for the wheelchair and one part for the nursebot.

at(w, X, result(A, S)) :-
A = move(w, _, X);
at(w, X, S), not(A = move(w, X, _)).

at(nB, X, result(A, S)) :-
A = move(nB, _, X);
at(nB, X, S), not(A = move(nB, X, _)), not(A = hopOn), not(A = hopOf(_)), not((nursebotOnWheelChair(S), A = move(w, X, _)));  %This is the importent part, we are saying that if the wheelchair is moving with the nursebot on the top, the nursebot will not be in the same plave again.
at(w, X, S), A = hopOn;
at(w, Y, S), A = hopOf(X);
nursebotOnWheelChair(S), A = move(w, _, X).


%This is my version of at when I was trying to use one at for both, it was working but in 7 minutes!!

%at(O, X, result(A, S)) :-
%A = move(O, _, X);
%A = hopOn, at(w, X, S), O = nB;
%O = nB, nursebotOnWheelChair(S), A = hopOf(X);
%nursebotOnWheelChair(S), not(A = hopOf(X)), A = move(w, _, X), O = nB;
%at(O, X, S), not(A = move(O, X, _)), (not(O =nB); (not(A = hopOn), not(A = hopOf(_)))), not(((O = nB), nursebotOnWheelChair(S), A = move(w, X, _))).


clear(X, result(A, S)) :-
A = move(_, X, _);
clear(X, S), not(A = move(_, _, X)).

hungry(result(A, S)) :-
hungry(S), not(A = feed).

inBed(result(A, S)) :-
inBed(S), not(A = load).

doorIsOpen(result(A, S)) :-
doorIsOpen(S), not(A = close);
A = open.

isOut(result(A, S)) :-
A = getOut;
isOut(S).

patientOnWheelChair(result(A, S)) :-
patientOnWheelChair(S);
A = load.

nursebotOnWheelChair(result(A, S)) :-
A = hopOn;
nursebotOnWheelChair(S), not(A = hopOf(_)).


%Total time running for task 32 :: 8.695 s





% ---------------------------------------------------------------------
% ---------------------------------------------------------------------
