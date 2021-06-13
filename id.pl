%Iterative Deepening

%Impostiamo il limite iniziale
:-dynamic(limite/1).
limite(1).

runID:-
    statistics(walltime, [_ | [_]]),
    id(Soluzione),
    write('Soluzione: '), write(Soluzione), nl,
    write('Lunghezza: '), length(Soluzione, L), write(L),nl,
    statistics(walltime, [_ | [ExTime]]),
    write('Tempo esecuzione: '), write(ExTime), write(' ms').

id(Soluzione):-
    ricercaPercorso(Soluzione),
    !,
    retract(limite(_)),
    assert(limite(1)).
    
ricercaPercorso(Soluzione):-
    limite(L),
    Limite is L,
    iniziale(I),
    ricercaProfLimitata(I, [], Limite, Soluzione).

ricercaPercorso(Soluzione):-
    limite(L),
    NuovoLim is L + 1,
    maxProf(MP),
    NuovoLim =< MP,
    retract(limite(_)),
    assert(limite(NuovoLim)),
    ricercaPercorso(Soluzione).

ricercaProfLimitata(I, _, _, []):-
    finale(I),!.

ricercaProfLimitata(I, Visitati, Limite, [Azione | SeqAzioni]):-
    Limite>0,
    applicabile(Azione, I),
    trasforma(Azione, I, INuovo),
    \+member(INuovo, Visitati),
    NuovoLim is Limite - 1,
    ricercaProfLimitata(INuovo, [I|Visitati], NuovoLim, SeqAzioni).
    
