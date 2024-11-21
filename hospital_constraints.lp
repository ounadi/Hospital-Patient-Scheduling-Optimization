% Constants and domains
day(1..5).
time_slot(1..60).
patient(1..10).
visit(1..4).

% Visit durations
duration(1, 1). % Radiography: 10 minutes
duration(2, 2). % TAC: 20 minutes
duration(3, 3). % NMR: 30 minutes
duration(4, 1). % Blood Sample: 10 minutes


% Decision variables: Schedule visit V for patient P on day D at time T
1 { schedule(P, V, D, T) : day(D), time_slot(T) } 1 :- patient(P), required(P, V).

% Constraints
% A patient cannot have two visits at the same time and must respect the duration
:- schedule(P, V1, D, T1), schedule(P, V2, D, T2), V1 != V2, 
   duration(V1, Dur1), duration(V2, Dur2), 
   T1 <= T2, T2 < T1 + Dur1.
:- schedule(P, V1, D, T1), schedule(P, V2, D, T2), V1 != V2, 
   duration(V1, Dur1), duration(V2, Dur2), 
   T2 <= T1, T1 < T2 + Dur2.

% Blood samples must end before 11:00 (time slot 18)
:- schedule(P, 4, D, T), T + 1 > 18.

% Patients must stay seated for 30 minutes (3 time units) after a blood sample
:- schedule(P, 4, D, T1), schedule(P, V, D, T2), V != 4, T1 + 4 > T2.

% Track the days each patient visits
visit_day(P, D) :- schedule(P, _, D, _).

% Calculate waiting time between visits for a patient
waiting_time(P, D, T1, T2, Dur1) :- schedule(P, V1, D, T1), schedule(P, V2, D, T2), T1 < T2, V1 != V2, duration(V1, Dur1), T2 >= T1 + Dur1.

% Minimize the number of days each patient visits and the total waiting time
#minimize { 10*D,P : visit_day(P, D) }.
#minimize { T2 - (T1 + Dur1),P,D : waiting_time(P, D, T1, T2, Dur1) }.

% Show the schedule predicate
#show schedule/4.
