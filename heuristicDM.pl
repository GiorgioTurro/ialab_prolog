
% Applichiamo la distanza di Manhattan tra uno stato e quello finale
heuristic(pos(X1, Y1), L):-
    findall(Distance, (finale(pos(X2, Y2)), Distance is abs(X1 - X2) + abs(Y1 - Y2)), Distances),
    distanza_min(Distances, L).