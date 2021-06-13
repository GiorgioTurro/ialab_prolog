% applicabile(AZ,S)
applicabile(nord,pos(Riga,Colonna)):-   % ci riferiamo prima alla posizione corrente
    Riga>1,
    RigaSopra is Riga-1,
    \+occupata(pos(RigaSopra,Colonna)).

applicabile(sud, pos(Riga, Colonna)):-
    num_righe(N),                % facciamo fare pattern matching con le info nella base di conoscenza per non sforare i bordi del labirinto
    Riga < N,
    RigaSotto is Riga+1,
    \+occupata(pos(RigaSotto,Colonna)).

applicabile(est, pos(Riga,Colonna)):-
    num_colonne(M),
    Colonna < M,
    ColonnaDestra is Colonna+1,
    \+occupata(pos(Riga, ColonnaDestra)).

applicabile(ovest, pos(Riga, Colonna)):-
    Colonna > 1,
    ColonnaSinistra is Colonna-1,
    \+occupata(pos(Riga, ColonnaSinistra)).

% findall(Azione, applicabile(Azione, pos(1,6)), ListaAzioniApplicabili).
% fornisce una lista di azioni possibili partendo dalla pos iniziale specificata, findall(Variabile, goal, Output)

% trasforma(Azione,StatoAttuale,StatoNuovo)
trasforma(nord, pos(Riga,Colonna), pos(RigaSopra,Colonna)):-RigaSopra is Riga-1. 
% se la strategia adottata lo ritiene applicabile, allora viene effettuata la trasformazione nella nuova posizione
trasforma(sud, pos(Riga,Colonna), pos(RigaSotto,Colonna)):-RigaSotto is Riga+1. 
trasforma(est, pos(Riga,Colonna), pos(Riga,ColonnaDestra)):-ColonnaDestra is Colonna+1.
trasforma(ovest, pos(Riga,Colonna), pos(Riga,ColonnaSinistra)):-ColonnaSinistra is Colonna-1.

%###################################################
% massimaProfondita/1 fornisce un limite massimo di profondità
% entro il quale la ricerca ID deve fermarsi
%###################################################
maxProf(D):-
    num_righe(R),
    num_colonne(L),
    D is R * L.

% Calcolo del costo da S a NuovoS
costo(pos(_,_), pos(_,_), Costo):-
    Costo is 1.

% Calcolo distanza minima
distanza_min([L|Ls], Min):-
    distanza_min(Ls, L, Min).

distanza_min([], Min, Min).

distanza_min([L|Ls], Min0, Min):-
    Min1 is min(L, Min0),
    distanza_min(Ls, Min1, Min).

excludeEuristics([],[],_).
excludeEuristics([Head|Tail],OverEuristicaLista,Euristica):-
    Head >= Euristica,
    !,
    excludeEuristics(Tail,[Head|OverEuristicaLista],Euristica).

excludeEuristics([_|Tail],OverEuristicaLista,Euristica):-
    excludeEuristics(Tail,OverEuristicaLista,Euristica).
    