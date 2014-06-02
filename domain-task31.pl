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
:- multifile adjacent/2, at/3, carryPlate/1, hungry/1, clear/2, inBed/1, isOut/1.





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



% --- Precondition for primitive actions ------------------------------
% describe when an action can be carried out, in a generic situation S
%
% poss( doSomething(...), S ) :- preconditions(..., S).


poss(move(O, X, Y), S) :-    %robot 'O' is moving from 'X' to 'Y'.
at(O, X, S),
clear(Y, S),
robot(O),
adjacent(X, Y).

poss(grab, S) :-   %Nursebot grabbing the plate
not(carryPlate(S)),
at(nB, a1, S),
at(plate, a1, S).

poss(dispose, S) :-   %NurseBot disposing the plate.
carryPlate(S),
at(nB, a4, S).

poss(feed, S) :-  %Nursebot feeding the patient.
inBed(S),
hungry(S),
carryPlate(S),
at(nB, a3, S).

poss(load, S) :-   %Nursebot Loading the patient.
at(nB, a6, S),
at(w, a5, S),
inBed(S),
not(hungry(S)).

poss(open, S) :-  %Nursebot opening the door.
at(nB, a5, S),
not(doorIsOpen(S)).

poss(close, S) :-  %Nursebot closing the door. (This action is unused in all tasks)
at(nB, a5, S),
doorIsOpen(S).

poss(getOut, S) :-   %patient and WheelChair going out together from a5.
patientOnWheelChair(S),
doorIsOpen(S),
at(w, a5, S).





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

clear(X, result(A, S)) :-  % A square is clear if nothing is in it or something is about to move out from it.
A = move(_, X, _);
clear(X, S), not(A = move(_, _, X)).

hungry(result(A, S)) :-
hungry(S), not(A = feed).

inBed(result(A, S)) :-   %As you can see now that we 'load' action, the patient might not be in bed.
inBed(S), not(A = load).

doorIsOpen(result(A, S)) :-
A = open;
doorIsOpen(S), not(A = close).

isOut(result(A, S)) :-     %IsOut has only situation arguments, because it is only the patient on the WheelChair that is supposed to be out, so we know what is out.
A = getOut;
isOut(S).

patientOnWheelChair(result(A, S)) :-  %once patient loaded, no action to going back to bed.
A = load;
patientOnWheelChair(S).


%Total time running for 31: 17.992 s




% ---------------------------------------------------------------------
% ---------------------------------------------------------------------
