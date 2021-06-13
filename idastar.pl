:-dynamic(ida_nodo/2).


runIDAStar:-
    statistics(walltime, [_ | [_]]),
    idaStar(Sol),
    write('Soluzione: '), write(Sol), nl,
    write('Lunghezza: '), length(Sol, L), write(L),nl,
    statistics(walltime, [_ | [ExTime]]),
    write('Tempo esecuzione: '), write(ExTime), write(' ms').

idaStar(Sol):-
    iniziale(S),
    heuristic(S, EuristicaStart),
    ida(S, Sol, [S], 0, EuristicaStart),!.

ida(S, Sol, Visitati, CostoPercorsoS, Euristica):-
    ricerca_ida(S, Sol, Visitati, CostoPercorsoS, Euristica);
    findall(FS, ida_nodo(_, FS), EuristicaLista),
    exclude(>=(Euristica), EuristicaLista, FilteredEuristicaLista),
    sort(FilteredEuristicaLista, ListaOrdinata),
    nth0(0, ListaOrdinata, NuovaEuristica),
    retractall(ida_nodo(_, _)),
    ida(S, Sol, Visitati, 0, NuovaEuristica).


ricerca_ida(S, [], _, _, _):-
    finale(S).


ricerca_ida(S, [Az|AltreAzioni], Visitati, CostoPercorsoS, Euristica):-
    applicabile(Az, S),
    trasforma(Az, S, NuovoS), 
    \+member(NuovoS, Visitati),
    costo(S, NuovoS, Costo),
    CostoPercorsoNuovaS is CostoPercorsoS + Costo,
    heuristic(NuovoS,CostoHeuristicNuovaS),
    FNuovoS is CostoPercorsoNuovaS + CostoHeuristicNuovaS,
    assert(ida_nodo(NuovoS, FNuovoS)),
	FNuovoS =< Euristica,
    ricerca_ida(NuovoS, AltreAzioni, [NuovoS|Visitati], CostoPercorsoNuovaS, Euristica).
