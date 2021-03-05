# ADFC Analyse
## Fahrrad Verkehrsmengen Daten erfasst durch das Stadtradeln Projekt

### Setup

#### Elixir

Für das Data Processing musst du [Elixir](https://elixir-lang.org/) und [Erlang](https://www.erlang.org/) auf deinem Rechner installiert haben.
Hier geht es zu der Installation Anleitung: [Install Elixir](https://elixir-lang.org/install.html)

#### Daten

Lade die [Verkehrsmengen](https://www.mcloud.de/web/guest/suche/-/results/filter/relevance/stadtradeln/provider%3ATU+Dresden/0/detail/ECF9DF02-37DC-4268-B017-A7C2CF302006) Daten herunter und benenne die `.csv`-Dateien ggf. um zu z.b. `verkehrsmengen_2018.csv`

Du solltest jetzt 3 Dateien in diesem Ordner haben:

```
verkehrsmengen_2018.csv
verkehrsmengen_2019.csv
verkehrsmengen_2020.csv
```

### Data Processing
Filter zuerst alle Datenpunkte heraus, welche nicht auf Koeln zutreffen. Setze hierzu die `year` variable in `filter.exs` auf das Jahr welches du filtern möchtest. Danach führe folgendes aus:

```elixir
mix run filter.exs
```

Dies wird eine `verkehrsmengen_koeln_YEAR.csv` Datei erstellen in welche nur noch die Datenpunkte für das Kölner Stadtgebiet beinhaltet.

Konvertiere nun die `.csv`-Datei in eine `.geojson`-Datei indem du ein oder mehrere Jahre in der `years` Variable im `convert.exs` Skript definierst. Wenn du mehrere Jahre angibts werden die Datenpunkte für diese Jahre kombiniert und nur in einer neuen Datei ausgegeben.

Nachdem du die `years` variable angepasst hast, führe folgenden Befehl aus:

```elixir
mix run convert.exs
```

Jetzt solltest du eine `verkehrsmengen_koeln_YEAR_YEAR.geojson`-Datei haben.

#### **ACHTUNG**
Du musst leider noch das letzte Komma `,` aus der `.geojson` Datei löschen, sonst ist diese invalide. Öffne hierzu die `.geojson`-Datei un lösche das letzte Komma hinter 

```
...
{"geometry":{"coordinates":[[6.7493,50.847797],[6.749468,50.847705]],"type":"LineString"},"properties":{"occurrences":6},"type":"Feature"},
{"geometry":{"coordinates":[[6.7493,50.847797],[6.749468,50.847705]],"type":"LineString"},"properties":{"occurrences":6},"type":"Feature"}, <---- Dieses Komma löschen
]
}
```

Diese kannst du relativ einfach zu [Mapbox](https://www.mapbox.com/) hochladen. 
Installiere hierzu zuerst die [Mapbox CLI](https://github.com/mapbox/mapbox-cli-py).

Danach, verändere die `YEAR_YEAR`-variable im folgenden Befehl und führe diesen aus (Einfach `ENTER` drücken).

```
mapbox upload verkehrsmengen verkehrsmengen_koeln_YEAR_YEAR.geojson
```

Diese Daten werden dann zu einem [Tileset](https://docs.mapbox.com/studio-manual/reference/tilesets/) konvertiert und du kannst dieses in einem neuen [Style](https://docs.mapbox.com/studio-manual/reference/styles/) verwenden.