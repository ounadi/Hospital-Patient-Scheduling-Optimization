Problem:
7. Hospital. An hospital is ready to provide k types of visits in different labs (e.g., radiography, TAC, NMR, blood sample, ...). Each visit takes some time, let’s use as unit time 10 minutes, so you have visits at 8.00, 8.10, 8.20, 8.30, 8.40, 8.50, 9.00, 9.20, . . . , 17.50. Some visits might take more than 1 unit time (for instance NMR takes 30 minutes). Part of the input (that depends on the hospital) is the k types of visits and their duration (invent the data here, I am not a doctor). The other part of the inputs are the patients. You have a list of patients wach of them with a set of required visits (e.g. patient 1 needs a blood sample and a TAC). Also here invent the data.
Reason on a time window of 5 days (work week). The aim is to schedule patients to labs in order to minimize (high penalty) the fact of non returning in two separate days and to minimize (smaller penalty) the sum of the time spent for waiting the next visit in the hospital. Blood sample ends at 11.00, the other exams end at 18.00. After blood sample patients have to stay seated for 30 minutes (3 times unit) before entering another visit or leaving the hospital. Of course, the same patient can give at most one visit at a given time.



Tools Used:
MiniZinc IDE and FlatZinc converter.
Clingo for ASP modeling.
Python for result processing and visualization.
