
## Nächste Todos
Der fokus liegt darauf, erstmal etwas spielbares zu produzieren, das
heißt wir machen 3 oder 4 squads mit unterschiedlicher Infantrie.
Simple ai und dann so, dass die Campaign karte, punkte sich in die 
rts battles übertragen und man verliert, wenn man nur
noch 2 chunks oder so hat.

- Battle gewinnen/verlieren und dann anwenden
  - Sektoren erobern
- Simple ai moves: units müssen losgeschikt werden 
  - alle felder einzunehmen
  - Sector conquer target
- armeen erstellen
- armeen updaten
- commented


## Tech-Demo (v1) - basic gameloop
Die gameplay loop existiert, aber ist noch kacke.
Man kann eine Kampange "durchspielen", aber kein menu, usw.
-> zum beispiel "ai-movement" ist nur random movement, etc.
-> keine coolen units...

- Battle-Siegbedingung: chunk-erobern
  - sieg bei 80 % besitz
  - tracken wem ein chunk gehört

- Campaign-Map-Gameplay-Loop
  - move army
  - get money
  - simple ai: reinforce random + attack random

- beides zusammenschweißen
  - problem: wie macht man dass bei mehreren 
    battles hintereinander?

- pausieren

- FIX UNIT RENDERING: alle chunks vor units rendern
- nazi-haftes type checking
- F1-F12 Debug view
  - F1: toggle debug hits, wie zum beispiel die reichweite der units und die kollisions-kreise
  - F2: toggle ein overlay mit allen zahlen der instances: units, chunks, projectiles, atlases, etc.
- code aufräumen und alles kommentieren
- statechecks

## tech-demo (v2) - VisualFun + Gameplay-Fun
- technology in campaign map: simple technology at first
- tanks
- out of map artillery
- logistic-center for reinforcement
- campaign map ai  
- transporter
  - Stellungen: immobile transporter
- Besseres Schuss system: projektile nur für granaten und raketen
- explosionen
- code aufräumen und alles kommentieren
- nazi-haftes type checking
- state-checks
- dead bodies/blood effects

## tech-demo (v2) - more gameplay
- menu

## undefiniert-später
- Diplomatie
- paratroopers
- flammenwerfer
- 
## Content stuff



