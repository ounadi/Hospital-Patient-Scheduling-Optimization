day(1..5).
time_slot(1..60).
patient(1..5).
visit(1, "Radiography").
duration(1, 1).
visit(4, "Blood Sample").
duration(4, 1).
visit(2, "TAC").
duration(2, 2).
required(1, 4).
required(1, 2).
required(2, 4).
required(2, 2).
required(3, 1).
required(3, 4).
required(4, 2).
required(5, 1).
required(5, 2).