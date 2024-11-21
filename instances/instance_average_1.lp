day(1..5).
time_slot(1..60).
patient(1..4).
visit(1, "Radiography").
duration(1, 1).
visit(4, "Blood Sample").
duration(4, 1).
visit(2, "TAC").
duration(2, 2).
visit(3, "NMR").
duration(3, 3).
required(1, 3).
required(2, 1).
required(3, 4).
required(3, 2).
required(3, 3).
required(4, 1).
required(4, 4).
required(4, 2).