% In questa funzione andiamo a comparare 2 costi di 2 percorsi in modo tale da trovare quello più conveniente
% f(n) = g(n) + h(n)
aStarComparator(R, nodo(_, _, G_Cost1, H_Cost1), nodo(_, _, G_Cost2, H_Cost2)):-
    F1 is G_Cost1 + H_Cost1,
    F2 is G_Cost2 + H_Cost2,
    F1 >= F2 -> R = >; R = < .


%    nodo/4
% - S
% - AzioniPerS
% - CostoAttuale, Costo sostenuto finora
% - StimaEuristica
runAStar:-
    statistics(walltime, [_ | [_]]),
    aStar(Sol),
    write('Soluzione: '), write(Sol),nl,
    write('Lunghezza: '), length(Sol, L), write(L),nl,
    statistics(walltime, [_ | [ExTime]]),
    write('Tempo esecuzione: '), write(ExTime), write(' ms').

aStar(Soluzione):-
    iniziale(S),
    heuristic(S,HeuristicS),
    aStarRicercaPercorso([nodo(S,[],0,HeuristicS)],[],Soluzione),
    !.

% aStarRicercaPercorso/3
aStarRicercaPercorso([nodo(S, AzioniPerS,_,_)|_],_,AzioniPerS):-
    finale(S),
    !.

aStarRicercaPercorso([nodo(S,AzioniPerS,CostoAttuale,HeuristicAttuale)|CodaStati],Visitati,Soluzione):-
    findall(Az, applicabile(Az, S), ListaAzioniApplicabili),    % troviamo tutte le azioni che l'agente può fare partendo dallo stato S
    generaStatiFigli(nodo(S,AzioniPerS,CostoAttuale,HeuristicAttuale), [S|Visitati], ListaAzioniApplicabili, StatiFigli),   % troviamo gli stati figli per S
    append(CodaStati, StatiFigli, CodaRis), 
    predsort(aStarComparator, CodaRis, CodaSorted), % quale tra i figli è il migliore da percorrere
    aStarRicercaPercorso(CodaSorted, [S|Visitati], Soluzione).
    

% generaStatiFigli/4
generaStatiFigli(_,_,[],[]).

generaStatiFigli(nodo(S,AzioniPerS,CostoAttuale,HeuristicAttuale), Visitati, [Az|AltreAzioni], [nodo(NuovoS,[Az|AzioniPerS], NuovoCosto, EuristicaSUp)|AltriFigli]):-
    trasforma(Az, S, NuovoS),
    \+member(NuovoS, Visitati),
    !,
    costo(S, NuovoS, Costo),
    NuovoCosto is CostoAttuale + Costo,
    heuristic(NuovoS, EuristicaSUp),
    generaStatiFigli(nodo(S,AzioniPerS,CostoAttuale,HeuristicAttuale), [NuovoS|Visitati], AltreAzioni, AltriFigli).


generaStatiFigli(Nodo,Visitati,[_|AltreAzioni],AltriFigli):-
    generaStatiFigli(Nodo,Visitati,AltreAzioni,AltriFigli).

%End of file