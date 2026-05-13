% ============================================================
% Problema: Taranul, Lupul, Capra si Varza
% Rezolvare cu DFS - Depth First Search
% ============================================================

% Reprezentare stare:
% stare(Taran, Lup, Capra, Varza)

stare_initiala(stare(stg, stg, stg, stg)).
stare_finala(stare(dr, dr, dr, dr)).

% Mal opus
opus(stg, dr).
opus(dr, stg).

% O stare este valida daca:
% 1. Lupul nu ramane cu capra fara taran
% 2. Capra nu ramane cu varza fara taran

stare_valida(stare(Taran, Lup, Capra, Varza)) :-
    \+ (Lup = Capra, Taran \= Lup),
    \+ (Capra = Varza, Taran \= Capra).

% ------------------------------------------------------------
% Mutari posibile
% ------------------------------------------------------------

% Taranul trece singur
mutare(
    stare(Taran, Lup, Capra, Varza),
    stare(TaranNou, Lup, Capra, Varza),
    'Taranul traverseaza singur'
) :-
    opus(Taran, TaranNou),
    stare_valida(stare(TaranNou, Lup, Capra, Varza)).

% Taranul trece cu lupul
mutare(
    stare(Taran, Taran, Capra, Varza),
    stare(TaranNou, TaranNou, Capra, Varza),
    'Taranul traverseaza cu lupul'
) :-
    opus(Taran, TaranNou),
    stare_valida(stare(TaranNou, TaranNou, Capra, Varza)).

% Taranul trece cu capra
mutare(
    stare(Taran, Lup, Taran, Varza),
    stare(TaranNou, Lup, TaranNou, Varza),
    'Taranul traverseaza cu capra'
) :-
    opus(Taran, TaranNou),
    stare_valida(stare(TaranNou, Lup, TaranNou, Varza)).

% Taranul trece cu varza
mutare(
    stare(Taran, Lup, Capra, Taran),
    stare(TaranNou, Lup, Capra, TaranNou),
    'Taranul traverseaza cu varza'
) :-
    opus(Taran, TaranNou),
    stare_valida(stare(TaranNou, Lup, Capra, TaranNou)).

% ------------------------------------------------------------
% DFS
% ------------------------------------------------------------

rezolva_dfs(Solutie) :-
    stare_initiala(Start),
    dfs(Start, [Start], DrumInvers),
    reverse(DrumInvers, Solutie).

% Caz de oprire:
% daca starea curenta este starea finala, am gasit solutia

dfs(StareCurenta, Drum, Drum) :-
    stare_finala(StareCurenta).

% Caz recursiv:
% cautam o stare noua valida si nevizitata

dfs(StareCurenta, DrumPartial, Solutie) :-
    mutare(StareCurenta, StareNoua, _),
    \+ member(StareNoua, DrumPartial),
    dfs(StareNoua, [StareNoua | DrumPartial], Solutie).

% ------------------------------------------------------------
% Afisare solutie
% ------------------------------------------------------------

afiseaza_solutie_dfs :-
    rezolva_dfs(Solutie),
    nl,
    write('Solutia gasita cu DFS este:'), nl, nl,
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