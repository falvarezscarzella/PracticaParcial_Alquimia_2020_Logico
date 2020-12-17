% BASE DE CONOCIMIENTO


herramienta(ana, circulo(50,3)).
herramienta(ana, cuchara(40)).
herramienta(beto, circulo(20,1)).
herramienta(beto, libro(inerte)).
herramienta(cata, libro(vida)).
herramienta(cata, circulo(100,5)).


%PUNTO 1

jugador(ana, [agua, vapor, tierra, hierro]).
jugador(cata, [agua, fuego, tierra, aire]).
jugador(beto, Elementos):-
    jugador(ana, Elementos).


construir(pasto, [agua, tierra]).
construir(hierro, [fuego, agua, tierra]).
construir(huesos, [agua, pasto]).
construir(presion, [hierro, vapor]).
construir(vapor, [agua, fuego]).
construir(playStation, [silicio, hierro, plastico]).
construir(silicio, [tierra]).
construir(plastico, [huesos, presion]).

esElemento(Elemento):-
    construir(_, Elementos),
    member(Elemento, Elementos).

esElemento(Elemento):-
    construir(Elemento, _).

esElemento(Elemento):-
    jugador(_, Elementos),
    member(Elemento, Elementos).

% PUNTO 2

tieneIngredientesPara(Jugador,Elemento):-
    jugador(Jugador,ElementosQueTiene),
    construir(Elemento,ElementosNecesarios),
    forall(member(ElementoQueTiene,ElementosNecesarios),member(ElementoQueTiene,ElementosQueTiene)).

% PUNTO 3

estaVivo(fuego).
estaVivo(agua).    
estaVivo(Elemento):-
    construir(Elemento,Ingredientes),
    member(Ingrediente,Ingredientes),
    estaVivo(Ingrediente).

% PUNTO 4

cantidadElementosNecesarios(Elemento,Cantidad):-
    construir(Elemento,Ingredientes),
    length(Ingredientes,Cantidad).
    
herramientaSirvePara(libro(inerte),Elemento):-
    not(estaVivo(Elemento)).

herramientaSirvePara(libro(vida),Elemento):-
    estaVivo(Elemento).

herramientaSirvePara(cuchara(Longitud),Elemento):-
    CantidadQueSoporta is Longitud/10,
    cantidadElementosNecesarios(Elemento,Cantidad),
    Cantidad =< CantidadQueSoporta.

herramientaSirvePara(circulo(Diametro,Niveles),Elemento):-
    CantidadQueSoporta is (Diametro/100)*Niveles,
    cantidadElementosNecesarios(Elemento,Cantidad),
    Cantidad =< CantidadQueSoporta.

tieneLaHerramientaPara(Jugador,Elemento):-
    herramienta(Jugador,Herramienta),
    herramientaSirvePara(Herramienta,Elemento).

puedeConstruir(Jugador,Elemento):-
    tieneIngredientesPara(Jugador,Elemento),
    tieneLaHerramientaPara(Jugador,Elemento).

% PUNTO 5

elementosBasicos(Elemento):-
    esElemento(Elemento),
    not(construir(Elemento,_)).

tieneLosElementosBasicos(Jugador):-
    jugador(Jugador,ElementosQueTiene),
    forall(elementosBasicos(ElementoBasico),member(ElementoBasico,ElementosQueTiene)).

noTieneElemento(Jugador,Elemento):-
    esElemento(Elemento),
    jugador(Jugador,ElementosQueTiene),
    not(member(Elemento,ElementosQueTiene)).

puedeConstruirLoQueNoTiene(Jugador):-
    jugador(Jugador,_),
    forall(noTieneElemento(Jugador,Elemento),tieneLaHerramientaPara(Jugador,Elemento)).

esTodoPoderoso(Jugador):-
    tieneLosElementosBasicos(Jugador),
    puedeConstruirLoQueNoTiene(Jugador).

% PUNTO 6

cuantoPuedeConstruir(Jugador,CantidadDeElementos):-
    jugador(Jugador,_),
    findall(Elemento,puedeConstruir(Jugador,Elemento),Elementos),
    length(Elementos,CantidadDeElementos).
    
quienGana(Jugador):-
    cuantoPuedeConstruir(Jugador,CantidadGanadora),
    forall((cuantoPuedeConstruir(OtroJugador,Cantidad),Jugador \= OtroJugador),Cantidad < CantidadGanadora).    

%PUNTO 7

/*  
    Por ejemplo en la linea 19, el enunciado dice que Ana no tiene vapor, pero en la base de conocimiento esto no se especifica 
    ya que no es necesario. Por el concepto de universo cerrado solo sera True todo lo que cumpla con el predicado y
    False todo lo que no, no es necesario especificar los casos en que se espera un False. 
*/


%PUNTO 8

puedeLlegarATener(Jugador,Elemento):-
    jugador(Jugador,ElementosQueTiene),
    member(Elemento,ElementosQueTiene).

puedeLlegarATener(Jugador,Elemento):-
    puedeConstruir(Jugador,Elemento). 
       
puedeLlegarATener(Jugador,Elemento):-
    tieneLaHerramientaPara(Jugador,Elemento),
    construir(Elemento,Ingredientes),
    forall(member(Ingrediente,Ingredientes),puedeLlegarATener(Jugador,Ingrediente)).
