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
:- multifile adjacent/2, at/3, carryPlate/1, hungry/1, clear/2, inBed/1, isOut/1, patientOnWheelChair/1, batteryNB/2, batteryW/2.





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


poss(move(O, X, Y), S) :-          %robot 'O' is moving from 'X' to 'Y'.
robot(O),
adjacent(X, Y),
clear(Y, S),
at(O, X, S),
(not(nursebotOnWheelChair(S)) ; not(O = nB)),
((O = nB, batteryNB(B,S), B >= 2);									%Nursebot will need a battery of at least 2.
(not(nursebotOnWheelChair(S)), O = w, batteryW(B,S), B >= 1 );		%WheelChair will need a battery of at least 1 without the nursebot on it.
(nursebotOnWheelChair(S), O = w, batteryW(B,S), B >= 3)).			%WheelChair will need a battery of at least 3 with the nursbot on it.


poss(grab, S) :-         %Nursebot grabbing the plate.
not(carryPlate(S)),
at(nB, a1, S),
at(plate, a1, S).

poss(dispose, S) :-  %Nursebot disposing the plate.
carryPlate(S),
at(nB, a4, S).

poss(feed, S) :-   %Nursebot feeding the patient.
inBed(S),
hungry(S),
carryPlate(S),
at(nB, a3, S).

poss(load, S) :-    %Nursebot loading the patient on wheelChair.
at(nB, a6, S),
at(w, a5, S),
not(nursebotOnWheelChair(S)),
inBed(S),
not(hungry(S)).

poss(open, S) :-   %Nursebot opening the door.
at(nB, a5, S),
not(doorIsOpen(S)).

poss(close, S) :-  %Nursebot closing the ddor.
at(nB, a5, S),
doorIsOpen(S).

poss(getOut, S) :-  %patient and WheelChair going out together.
doorIsOpen(S),
patientOnWheelChair(S),
at(w, a5, S),
not(isOut(S)),
(batteryW(B, S), B >= 3).

poss(hopOn, S) :-   %Nursebot hoping on wheelChair.
at(nB, X ,S),
at(w, Y, S),
adjacent(X, Y),
not(patientOnWheelChair(S)),
(batteryNB(B, S), B >= 3).

poss(hopOf(X), S) :-  %Nursebot hoping of wheelChair.
at(w, Y, S),
adjacent(X, Y),
clear(X, S),
nursebotOnWheelChair(S),
(batteryNB(B, S), B >= 3).





% --- Successor state axioms ------------------------------------------
% describe the value of fluent based on the previous situation and the
% action chosen for the plan. 
%
% fluent(..., result(A,S)) :- positive; previous-state, not(negative)

carryPlate(result(A, S)) :-
A = grab;
carryPlate(S), not(A = dispose).


at(w, X, result(A, S)) :-
A = move(w, _, X);
at(w, X, S), not(A = move(w, X, _)).

at(nB, X, result(A, S)) :-
A = move(nB, _, X);
at(w, X, S), A = hopOn;
at(w, Y, S), A = hopOf(X);
nursebotOnWheelChair(S), A = move(w, _, X);
at(nB, X, S), not(A = move(nB, X, _)), not(A = hopOn), not(A = hopOf(_)), not((nursebotOnWheelChair(S), A = move(w, X, _))).


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

batteryNB(X, result(A,S)) :-                                                                   %battery for the nutseBot.
(not(A = move(nB, _, _)), not(A = hopOn), not(A = hopOf(_)), batteryNB(P, S), X = P);          %if it doesn't do anything, it will have the same battery.
(A = move(nB, _, _), batteryNB(P, S), X = P -2);											   %moving will reduce the battery by 2.
(A = hopOn, batteryNB(P, S), X = P -3);														   %hoping on and of will reduce the battery by 3.
(A = hopOf(_), batteryNB(P, S), X = P - 3).

%Variable 'P' stands for Previous 

batteryW(X, result(A,S)) :-																	   %battery for the wheelChair.
(not(A = move(w, _, _)), not(A = getOut), batteryW(P, S), X = P);							   %if it doesn't move or geting out, it will have the same battery.
(A = getOut, batteryW(P, S), X = P - 3);													   %geting the patient out will reduce the battery by 3.
(A = move(w, _, _), nursebotOnWheelChair(S), batteryW(P, S), X = P - 3);					   %moving with nursebot will reduce the battery by 3.  
(A = move(w, _, _), not(nursebotOnWheelChair(S)), batteryW(P, S), X = P - 1). 				   %moving without nursebot will reduce the battery by 1.



%Total time running for task 33a :: 48.020 s
%Total time running for task 33b :: 19.587 s
%Total time running for task 33c :: 8.627 s






% ---------------------------------------------------------------------
% ---------------------------------------------------------------------
