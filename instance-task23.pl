% ---------------------------------------------------------------------
%  ----- Informatics 2D - 2012/13 - Second Assignment - Planning -----
% ---------------------------------------------------------------------
%
% Write here you matriculation number (only - your name is not needed)
% Matriculation Number: s1245523
%
%
% ------------------------- Problem Instance --------------------------
% This file is a template for a problem instance: the definition of an
% initial state and of a goal. 

% debug(on).	% need additional debug information at runtime?



% --- Load domain definitions from an external file -------------------

:- [domain-task21].		% Replace with the domain for this problem




% --- Definition of the initial state ---------------------------------

robot(nB).
robot(w).

adjacent(a1, a2).
adjacent(a2, a1).

adjacent(a2, a3).
adjacent(a3, a2).

adjacent(a2, a4).
adjacent(a4, a2).

adjacent(a4, a5).
adjacent(a5, a4).

adjacent(a5, a6).
adjacent(a5, a5).


at(w, a3, s0).
at(nB, a1, s0).

carryPlate(s0).
inBed(s0).
hungry(s0).

clear(a2, s0).
clear(a4, s0).
clear(a5, s0).
clear(a6, s0).




% --- Goal condition that the planner will try to reach ---------------

goal(S) :-	not(hungry(S)), not(carryPlate(S)).				% fill in the goal definition




% ---------------------------------------------------------------------
% ---------------------------------------------------------------------
