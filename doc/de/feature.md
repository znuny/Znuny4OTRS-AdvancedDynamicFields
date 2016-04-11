# Consultant Helfer

Viele Aufgaben die bei einer Einrichtung oder Aktualisierung eines Kundensystems vorgenommen werden müssen sind aufgrund diverser Limitierungen sehr mühsam. Diese Erweiterung soll die Arbeiten an Kundensystemen erleichtern.

## Verwaltung von Dashboard DefaultColumns

Um im OTRS Standard Ticket Attribute in allen Dashboard SysConfig Konfigurationen hinzuzufügen, bearbeiten oder zu löschen muss jeder Konfigurationseintrag manuell über die SysConfig Oberfläche angepasst werden. Das neue OTRS Konsolenkommando "Znuny4OTRS::DashboardColumn::Add" erleichtert diese Arbeit, indem das übergebene Ticket Attribut in allen entsprechenden Dashboard Konfigurationen mit dem übergebenen Wert gesetzt wird.

Die Hilfe kann wie folgt ausgegeben werden:
```
./bin/otrs.Console.pl Znuny4OTRS::DashboardColumn::Add
```

Beispielaufruf:
```
./bin/otrs.Console.pl Znuny4OTRS::DashboardColumn::Add DynamicField_Test 2
```

Zum Löschen kann das Konsolenkommando "Znuny4OTRS::DashboardColumn::Remove" analog verwendet werden.

Die Hilfe kann wie folgt ausgegeben werden:
```
./bin/otrs.Console.pl Znuny4OTRS::DashboardColumn::Remove
```

Beispielaufruf:
```
./bin/otrs.Console.pl Znuny4OTRS::DashboardColumn::Remove DynamicField_Test
```
