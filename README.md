# agony
A game that need to be, but does not want to.

## Strategy: Content + Gameplay
Spiele die guten Content ermöglichen, aber dadurch zum selbst-spielen
anregen.

HOI -> Historic Depth + scope
Project Zomboid -> Realistic but fun survival
Rimworld -> Create your own story
Minecraft -> absolute Freiheit
Total War -> Cool battle-visuals + power-fantasy
Factorio -> programming-fun without programming
TTT -> Social fun
AgeOfEmpires -> Competitive fun, Medivial coolness

Zudem:
Gameplay, dass man nicht woanders bekommt.

Meine Fun-Motoren:
- Moderne-Schlacht-Coolness mit einem Sand-boxy-feeling.
- Sandbox-schlachten für Content-Creators.
- Challenges für Content-Creators.
- Power-Fantasy
- Böse / GUt gameplay; inquisition



## Basic Rules
- slow development 
- check all the state all the time
- dont overengineer

Jede Game-Mechanik muss exponentiell Gameplay-spaß hinzufügen, denn 
sie wird exponentiell schwerer zu implementieren.


## Roadmap

- [ ] Create Basic Structure

## Gameplay

Wictig: der Kern ist das RTS-Gameplay. Die Campaign map ist erstmal nur
ein Mittel zum Zweck.
-> keine erfahrungspunkte, aber konsistenter schaden: was eine kompanie verliert ist weg
es sei denn man kauft es wieder dazu.

-> ich kann die demo sogar ohne campaign machen -> man erobert siegpunkte.

### Campaign
- Campaign 
- Build up cities

Eine Schlacht -> ein Regiment.3.000–4.500 
Nicht alle auf einmal auf der Karte.
-> man holt eine Kompanie auf einmal rein.
-> maximal 4 Kompanien auf einmal im game ~ 600-800 Soldaten (weniger wenn man auch Panzer hat)
-> maximal hat eine Schlacht also 12 Kompanien: mehr kann in der 
  kampangenkarte nicht auf einer Tile sitzen.
Man kann später größere verbände erforschen, etc.
-> Soldiers are controlled as Troops of 10 units: squads.
-> alle fahrzeuege sind individuell kontrollierbar


Feldjägerkompanie: besetzen
Jägerkompanie: hauptinfantrie
Panzergranzierkompanie: Panzerunterstützung
Panzerkompanie: Panzer
Pionierkompanie: verteidigungsbau
Artilleriekompanie: Artillerie

Man kann rauszoomen: Zoomstufen die dann einen anderen View und andere 
Interaktionen ermöglichen.
-> Man kämpft um tiles und schiebt dort seine Armeen hin und her.
->

Kompanie-Based: 
-> Eine Kompanie: 100-200 Soldaten.

Kampfkompanien

Diese Kompanien sind primär für direkte Gefechte gegen den Feind ausgelegt.

    Panzerkompanie
        Rolle: Schwer gepanzerte Hauptkampftruppe.
        Anwendungsfall: Offensivoperationen gegen gut verteidigte Ziele, Durchbrechen von Feindlinien.
        Ausrüstung: Leopard 2 Kampfpanzer. 13–14 Kampfpanzer Leopard 2

    Panzergrenadierkompanie 12–14 Schützenpanzer Puma oder Marder
        Rolle: Mechanisierte Infanterie zur Unterstützung von Panzern.
        Anwendungsfall: Angriffe auf befestigte Stellungen, Häuserkampf, Begleitschutz für Panzer.
        Ausrüstung: Puma oder Marder Schützenpanzer.

    Jägerkompanie
        Rolle: Leichte Infanterie für vielseitige Einsätze.
        Anwendungsfall: Operationen in bewaldeten oder urbanen Gebieten, Verteidigung und Patrouille.
        Ausrüstung: Leichte Infanteriewaffen, Boxer oder Eagle IV Radfahrzeuge.

    Fallschirmjägerkompanie
        Rolle: Luftlandefähige Infanterie für schnelle Einsätze.
        Anwendungsfall: Hinter feindlichen Linien, schnelle Reaktion auf Krisensituationen.
        Ausrüstung: Tragbare schwere Waffen, Wiesel-Fahrzeuge.

    Gebirgsjägerkompanie
        Rolle: Spezialisierte Infanterie für Einsätze in Gebirgen und schwierigen Klimazonen.
        Anwendungsfall: Kampf in rauem Gelände, Winteroperationen.
        Ausrüstung: Infanteriewaffen, Bergsteigerausrüstung.

Unterstützungskompanien

Diese Kompanien unterstützen die Kampftruppen durch spezialisierte Fähigkeiten.

    Artilleriekompanie
        Rolle: Fernunterstützung durch präzise Feuerunterstützung.
        Anwendungsfall: Zerstörung von Feindstellungen und Unterstützung des Vormarschs.
        Ausrüstung: Panzerhaubitze 2000. 6–8 Panzerhaubitzen 2000  Feuerleitfahrzeuge  MAN-LKW

    Pionierkompanie
        Rolle: Technische Unterstützung, Geländepräparation.
        Anwendungsfall: Brückenbau, Minenräumen, Hindernisbau.
        Ausrüstung: Brückenlegepanzer Biber, Minenräumpanzer Keiler.

    Flugabwehrkompanie
        Rolle: Schutz vor Luftangriffen.
        Anwendungsfall: Verteidigung gegen feindliche Flugzeuge, Drohnen und Hubschrauber.
        Ausrüstung: Ozelot-Flugabwehrsysteme.

Logistik- und Unterstützungsstrukturen

Essentiell für Versorgung, Kommunikation und Sicherheit.

    Logistikkompanie
        Rolle: Versorgung und Transport von Nachschub.
        Anwendungsfall: Treibstoffversorgung, Reparaturen, Munitionslieferung.
        Ausrüstung: MAN-LKW, Tanklastwagen, Bergepanzer.

    Sanitätskompanie
        Rolle: Medizinische Versorgung.
        Anwendungsfall: Aufbau von Feldlazaretten, Versorgung Verwundeter.
        Ausrüstung: Boxer San, Rettungsfahrzeuge.

    Fernmeldekompanie
        Rolle: Kommunikations- und Informationsmanagement.
        Anwendungsfall: Aufbau und Sicherstellung von Funk- und Datenverbindungen.
        Ausrüstung: Mobile IT- und Funksysteme.

    ABC-Abwehrkompanie
        Rolle: Schutz vor chemischen, biologischen und nuklearen Gefahren.
        Anwendungsfall: Dekontamination, Aufklärung von ABC-Gefahren.
        Ausrüstung: Spürpanzer Fuchs, Entgiftungsanlagen.

Polizei- und Sicherungseinheiten

Für Ordnung und Sicherheit innerhalb und außerhalb der Truppe.

    Feldjägerkompanie
        Rolle: Militärpolizeiliche Aufgaben.
        Anwendungsfall: Verkehrslenkung, Personenschutz, Sicherung von Konvois.
        Ausrüstung: Eagle IV, zivile Fahrzeuge, Polizeiausrüstung.

    Sicherungskompanie
        Rolle: Schutz und Sicherung von strategischen Standorten.
        Anwendungsfall: Bewachung von Basen, Flughäfen, Logistikknotenpunkten.
        Ausrüstung: Leichte Infanteriewaffen, Radfahrzeuge.



- Nicht genau historisch, sondern angepasst an die game notnwednigkeiten

Jedes der größeren länder hat zwei fraktionen: so kann man ein schicksal auswählen.

Erstmal ist die kampangnenkarte klein und hat nur zwei länder
und dann mit der zeit fügt man emehr und mehr hinzu.

Anfang: Frankreich/deutschland: Bruderkrieg

Deutschland: kaiserlich/faschismus

Italien: GottesStaat/Faschismus

Frankreich: Monarchie/Republik

Rebellen-fraktionen

Polen: Nationalstaat
Ungarn: Königreich
Dänemark: Monarchie/Republik

Russland: Zarenreich/Sozialismus

Usa: Demokratie/Kapitalismus

England: Monarchie/Republik

Japan: Kaiserreich/Faschismus

China: Kaiserreich/Sozialismus

Spanien: Monarchie/Republik

Türkei: Osmanisches Reich/Republik


bis zu 20 Squads

### Battle

