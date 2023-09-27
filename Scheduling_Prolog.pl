ta_slot_assignment([ta(N,L)|T],[ta(N,L1)|T],N):- L>0,L1 is L-1.

ta_slot_assignment([ta(N,L)|T],[ta(N,L)|T1],N1):-N1\=N, ta_slot_assignment(T,T1,N1).



slot_assignment(N,TAs,Rem,Assig):-helper(N,TAs,TAs,[],Rem,P),permutation(P,Assig).

helper(0,_,R1,R2,R1,R2).
helper(N,[ta(Name,_)|T],Modified,Assig,R1,R2):-N>0, 
ta_slot_assignment(Modified,Res,Name), N1 is N-1, 
helper(N1,T,Res,[Name|Assig],R1,R2).

helper(N,[_|T],Modified,Assig,R1,R2):-N>0,helper(N,T,Modified,Assig,R1,R2).



max_slots_per_day(DaySched,Max) :-flatten(DaySched,R),helper1(R,Max).

helper1([],_).
helper1([H|T],Max):-count(H,[H|T],R,[],Modified), R=<Max,helper1(Modified,Max).

count(_,[],0,L,L).
count(H,[H|T],C,L,Modified):-count(H,T,C1,L,Modified),C is C1+1.
count(H,[X|T],C,L,Modified):-count(H,T,C,[X|L],Modified), H\=X.

%flatten([H|T],R):-flatten(H,R1),flatten(T,R2),append(R1,R2,R).
%flatten(X,[X]):- \+is_list(X).
%flatten([],[]).



day_schedule([],A,A,[]).
day_schedule([HS|TS],TAs,R,[HA|TA]):-slot_assignment(HS,TAs,Rem,HA),
day_schedule(TS,Rem,R,TA).



week_schedule([],_,_,[]).
week_schedule([HD|TD],TAs,Max,[HR|TR]):-day_schedule(HD,TAs,RemTAs,HR),
max_slots_per_day(HR,Max), week_schedule(TD,RemTAs,Max,TR).