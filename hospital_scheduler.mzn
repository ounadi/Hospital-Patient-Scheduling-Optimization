% Constants and domains
int: num_days;
int: num_time_slots;
int: num_patients;
int: num_visits;

% Visit durations
array[1..num_visits] of int: duration;
array[1..num_visits] of string: lab_names;

% Required visits for patients
array[1..num_patients, 1..num_visits] of int: required;

% Decision variables: Schedule visit V for patient P on day D at time T
array[1..num_patients, 1..num_visits, 1..num_days, 1..num_time_slots] of var bool: schedule;

% Constraints
% Ensure each required visit is scheduled exactly once
constraint
  forall(p in 1..num_patients, v in 1..num_visits) (
    required[p, v] = 1 -> sum([bool2int(schedule[p, v, d, t]) | d in 1..num_days, t in 1..num_time_slots]) = 1
  );

% A patient cannot have two visits at the same time
constraint
  forall(p in 1..num_patients, d in 1..num_days, t in 1..num_time_slots) (
    sum([bool2int(schedule[p, v, d, t]) | v in 1..num_visits]) <= 1
  );

% Blood samples must end before 11:00 (time slot 18)
constraint
  forall(p in 1..num_patients, d in 1..num_days, t in 1..num_time_slots, v in 1..num_visits) (
    (lab_names[v] == "Blood Sample") -> (t + duration[v] > 18 -> not schedule[p, v, d, t])
  );

% Patients must stay seated for 30 minutes (3 time units) after a blood sample
constraint
  forall(p in 1..num_patients, d in 1..num_days, t1 in 1..num_time_slots, v in 1..num_visits) (
    (lab_names[v] == "Blood Sample") -> (schedule[p, v, d, t1] ->
      forall(t2 in t1+1..min(num_time_slots, t1+3)) (
        sum([bool2int(schedule[p, v2, d, t2]) | v2 in 1..num_visits]) = 0
      )
    )
  );

% Track the days each patient visits
array[1..num_patients, 1..num_days] of var bool: visit_day;
constraint
  forall(p in 1..num_patients, d in 1..num_days) (
    visit_day[p, d] = (sum([bool2int(schedule[p, v, d, t]) | v in 1..num_visits, t in 1..num_time_slots]) > 0)
  );

% Calculate waiting time between visits for a patient
array[1..num_patients] of var int: waiting_time;
constraint
  forall(p in 1..num_patients) (
    waiting_time[p] = sum([
      abs(t2 - (t1 + duration[v1]))
      | d in 1..num_days, v1 in 1..num_visits, v2 in 1..num_visits, t1 in 1..num_time_slots, t2 in 1..num_time_slots
      where schedule[p, v1, d, t1] /\ schedule[p, v2, d, t2] /\ t1 < t2
    ])
  );

% Objective: Minimize the number of days each patient visits and the total waiting time
var int: total_days = sum([bool2int(visit_day[p, d]) | p in 1..num_patients, d in 1..num_days]);
var int: total_waiting_time = sum(waiting_time);
solve minimize total_days * 100 + total_waiting_time;

% Output
output ["Schedule:\n"] ++
  [ if fix(schedule[p, v, d, t]) then
      "Patient \(p) has visit \(lab_names[v]) on day \(d) at time \(t)\n"
    endif | p in 1..num_patients, v in 1..num_visits, d in 1..num_days, t in 1..num_time_slots ] ++
  ["Total days: " ++ show(total_days) ++ "\n", "Total waiting time: " ++ show(total_waiting_time) ++ "\n"];
