% euristica2 (distanza euclidea)
heuristic(pos(X1, Y1), L) :-
    findall(Distance, (finale(pos(X2, Y2)), Distance is sqrt((X1-X2)^2 + (Y1-Y2)^2)), Distances),
    distanza_min(Distances, L).