% ============================================================
% Problema: Taranul, Lupul, Capra si Varza
% Rezolvare cu BFS - Breadth First Search
% ============================================================

% ------------------------------------------------------------
% Reprezentarea starii:
% stare(Taran, Lup, Capra, Varza)
%
% Fiecare element poate fi:
% stg = malul stang
% dr  = malul drept
% ------------------------------------------------------------

stare_initiala(stare(stg, stg, stg, stg)).
stare_finala(stare(dr, dr, dr, dr)).

% ------------------------------------------------------------
% Malul opus
% ------------------------------------------------------------

opus(stg, dr).
opus(dr, stg).

% ------------------------------------------------------------
% Verificarea unei stari valide
% ------------------------------------------------------------

stare_valida(stare(Taran, Lup, Capra, Varza)) :-
    \+ (Lup = Capra, Taran \= Lup),
    \+ (Capra = Varza, Taran \= Capra).

% ------------------------------------------------------------
% Mutari posibile
% ------------------------------------------------------------

mutare(
    stare(Taran, Lup, Capra, Varza),
    stare(TaranNou, Lup, Capra, Varza),
    'Taranul traverseaza singur'
) :-
    opus(Taran, TaranNou),
    stare_valida(stare(TaranNou, Lup, Capra, Varza)).

mutare(
    stare(Taran, Taran, Capra, Varza),
    stare(TaranNou, TaranNou, Capra, Varza),
    'Taranul traverseaza cu lupul'
) :-
    opus(Taran, TaranNou),
    stare_valida(stare(TaranNou, TaranNou, Capra, Varza)).

mutare(
    stare(Taran, Lup, Taran, Varza),
    stare(TaranNou, Lup, TaranNou, Varza),
    'Taranul traverseaza cu capra'
) :-
    opus(Taran, TaranNou),
    stare_valida(stare(TaranNou, Lup, TaranNou, Varza)).

mutare(
    stare(Taran, Lup, Capra, Taran),
    stare(TaranNou, Lup, Capra, TaranNou),
    'Taranul traverseaza cu varza'
) :-
    opus(Taran, TaranNou),
    stare_valida(stare(TaranNou, Lup, Capra, TaranNou)).

% ------------------------------------------------------------
% Rezolvare BFS
% ------------------------------------------------------------

rezolva(Solutie) :-
    stare_initiala(Start),
    bfs([[Start]], [], DrumInvers),
    reverse(DrumInvers, Solutie).

bfs([[StareCurenta | Drum] | _], _, [StareCurenta | Drum]) :-
    stare_finala(StareCurenta).

bfs([[StareCurenta | Drum] | RestCoada], Vizitate, Solutie) :-
    findall(
        [StareNoua, StareCurenta | Drum],
        (
            mutare(StareCurenta, StareNoua, _),
            \+ member(StareNoua, [StareCurenta | Drum]),
            \+ member(StareNoua, Vizitate)
        ),
        DrumuriNoi
    ),
    append(RestCoada, DrumuriNoi, CoadaNoua),
    bfs(CoadaNoua, [StareCurenta | Vizitate], Solutie).

% ------------------------------------------------------------
% Afisare solutie
% ------------------------------------------------------------

afiseaza_solutie :-
    rezolva(Solutie),
    nl,
    write('Solutia problemei Lupul, Capra si Varza este:'), nl, nl,
    afiseaza_pasi(Solutie, 0).

afiseaza_pasi([], _).

afiseaza_pasi([Stare], Nr) :-
    write('Pasul '), write(Nr), write(': '),
    write(Stare), nl.

afiseaza_pasi([Stare1, Stare2 | Rest], Nr) :-
    write('Pasul '), write(Nr), write(': '),
    write(Stare1), nl,
    mutare(Stare1, Stare2, Descriere),
    write('   -> '), write(Descriere), nl,
    NrNou is Nr + 1,
    afiseaza_pasi([Stare2 | Rest], NrNou).