# Android Smells Catalogue

Der Katalog basiert auf [DocPad](http://docpad.org). Damit lassen statische Webseiten generieren.

## Benutzung

### Installation

siehe [DocPad](http://docpad.org/docs/install).

Unter Ubuntu:

    sudo apt-add-repository ppa:chris-lea/node.js
    sudo apt-get update
    sudo apt-get upgrade
    sudo apt-get install nodejs
    (evtl. nicht nötig: sudo npm install -g npm)
    sudo npm install -g docpad

### Initialisierung

Nach der Installation von DocPad und vor der ersten Verwendung dieses Projekts müssen noch einige Module heruntergeladen werden:

    docpad install robotskirt,eco,related,coffeescript,livereload,geturl


### Neuen Smell anlegen

Neue Smells werden in dem Ordner `src/documents/smells` angelegt. Um mit der Markdown-Syntax zu arbeiten muss die Datei mit `html.md.eco` enden (wird intern von Coffeescript Template zu Markdown und dann zu HTML konvertiert). Ein Beispiel ist momentan unter `uncached_views.html.md.eco` zu sehen.

#### Metadaten

Im Kopf der Smells kann man Metadaten angeben. Hier ein Beispiel:

```
---
title: "Uncached Views"
layout: "smell"
affects: performance
context: ui
refactorings:
    - view_holder
tags:
    - view
    - fragment
    - layout
---
```

Um alle Refactorings in die Seite des Smells einzubinden muss man folgendes einfügen:


```
<% for refactoring in @getRefactorings(): %>
<%- @include(refactoring) %>
<% end %>
```


### Neues Refactoring anlegen

Um ein neues Refactoring anzulegen muss eine Datei, ähnlich wie bei Smells, im Ordner `refactorings` angelegt werden. Das Attribut `refactorings` bei den Smells verweist dabei auf Dateinamen (ohne Endung) der Refactorings, die eingebunden werden soll.


#### Metadaten

Hier ein Beispiel:

```
---
title: "View Holder"
affectsPositive:
    - performance
affectesNegative:
    - complexity
isRefactoring: true
---
```

### Markdown Formatierung

Um eine einheitliche Gestaltung sicher zu stellen sollten alle Smells Überschriften größer 2 benutzen: `##`. Refactorings sollten dagegen Überschriften größer 3 benutzt werden: `###`.

### Test

Im aktuellen Ordner folgenden Befehl ausführen:

```
docpad run
```

Das wird einen Unterordner `out` erstellen und einen einfachen Webserver [http://localhost:9778/](http://localhost:9778/) starten, der auf Änderungen der Ursprungsdateien achtet und Links ordentlich auflöst

### Deploy

Im aktuellen Ordner folgenden Befehl ausführen:

```
docpad generate --env static
```

### TODO

- Namen für Smells
- Namen für Refactorings
- Tabelle Kontext/Smell
- Tabelle Qualität/Smell (Ja/Nein)
- Tabelle Qualität/Refactoring (Qualitativ, Farbkodiert, Fortschrittsanzeige)
- Messung von Qualitäten/Smells gibt statische und dynamische Bedingungen (notwendig/hinreichend)

- **Verbesserte Qualitäten nur persönlicher Eindruck, es fehlen Messungen mit Daten**

#### Notizen

- Android Lint nach Fehlern durchsuchen

**Memory Managment for Android Apps**
- largeHeap Option in AndroidManifest.xml deutet auf hohen Speicherverbrauch hin
    - GC brauch länger bei größerem Heap
    - ab Honeycomb Concurrent GC, davor hat GC alle Threads geblockt
- System.gc() vermeiden
- MemoryLeak wenn Referenz auf View, Activity oder Drawable gehalten wird (und dann Bildschirm gedreht wird)
- [Android Design Patterns](http://www.androiddesignpatterns.com/2013/01/inner-class-handler-memory-leak.html)
    - wo muss Referenz gehalten werden um Leak zu erzeugen
    - automatisch suchbar?

**[Acadopus](http://acadopus.de/java/die-typischen-faelle-von-memory-leaks-in-java-anwendungen_4002.html)**
- Threads verbrauchen 512KB Heap für Stack (Standard)
- Observer Pattern hält Referenz auf Teilnehmer
- Singleton Pattern is Böse

**[Vogella](http://www.vogella.com/articles/AndroidBackgroundProcessing/article.html)**
- Handler von Activity zurückgeben statt eigenem zu erzeugen, wenn  Message-Prozessierung nicht geändert wird
- Cache für teure Objekte verwenden, zum Beispiel nach Bilderdownload
