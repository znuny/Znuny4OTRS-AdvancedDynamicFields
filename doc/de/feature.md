# Advanced DynamicFields

Diese Erweiterung erleichtet die Administration der dynamischen Felder im System.

Im OTRS Standard ist es nicht möglich zentral die Konfiguration der dynamischen Felder in den jeweiligen Oberflächen durchzuführen. Für jede Oberfläche muss die entsprechende SysConfig gesucht und angepasst werden.

# GUI

![Dynamische Felder Oberflächen](doc/de/images/Admin.png)

Die Administration der dynamischen Felder über die GUI ist via Admin -> 'Dynamische Felder Oberflächen' durchzuführen.

![AdminDynamicFieldScreen](doc/de/images/AdminDynamicFieldScreen.png)

Die Oberfläche ist kategorisiert in **DYNAMISCHE FELDER OBERFLÄCHEN**, **DEFAULTCOLUMNS OBERFLÄCHEN**  und **DYNAMISCHE FELDER**.

 * **DYNAMISCHE FELDER OBERFLÄCHEN**
 beinhaltet alle Oberflächen in denen ein dynamisches Feld angezeigt werden kann.

 * **DEFAULTCOLUMNS OBERFLÄCHEN**
 beinhaltet alle Oberflächen / Tabellen (Overviews) in denen ein dynamisches Feld als Spalte hinzugefügt werden kann.

 * **DYNAMISCHE FELDER**
 beinhaltet alle dynamischen Felder die zu **DYNAMISCHE FELDER OBERFLÄCHEN** oder **DEFAULTCOLUMNS
OBERFLÄCHEN** hinzugefügt werden können.

![AdminDynamicFieldScreenEditDynamicField](doc/de/images/AdminDynamicFieldScreenEditDynamicField.png)

![AdminDynamicFieldScreenEditScreen](doc/de/images/AdminDynamicFieldScreenEditScreen.png)

Die Administration der einzelnen Elemente kann einfach mittels 'Drag and Drop' durchgeführt werden.

# Konsole

## Verwaltung von DefaultColumns

Um im OTRS Standard Ticket-Attribute in allen Dashboard-Konfigurationen hinzuzufügen, bearbeiten oder zu löschen muss jeder Konfigurationseintrag manuell über die SysConfig Oberfläche angepasst werden. Das neue OTRS Konsolenkommando "Znuny4OTRS::DefaultColumnsScreen::Add" erleichtert diese Arbeit, indem das übergebene Ticket-Attribut in allen entsprechenden Dashboard-Konfigurationen mit dem übergebenen Wert gesetzt wird.

### Hinzufügen

Die Hilfe kann wie folgt ausgegeben werden:
```
bin/otrs.Console.pl Znuny4OTRS::DefaultColumnsScreen::Add
```

Beispielaufruf:
```
bin/otrs.Console.pl Znuny4OTRS::DefaultColumnsScreen::Add --dynamicfield=FieldName --dynamicfield=FieldName2 --state 1
```

Screen ist optional:
```
bin/otrs.Console.pl Znuny4OTRS::DefaultColumnsScreen::Add --dynamicfield=FieldName --dynamicfield=FieldName2 --state 1 --screen='DashboardBackend###0130-TicketOpen' --screen='Ticket::Frontend::AgentTicketQueue###DefaultColumns'
```

### Löschen

Zum Löschen kann das Konsolenkommando "Znuny4OTRS::DefaultColumnsScreen::Remove" analog verwendet werden.

Die Hilfe kann wie folgt ausgegeben werden:
```
bin/otrs.Console.pl Znuny4OTRS::DefaultColumnsScreen::Remove
```

Beispielaufruf:
```
bin/otrs.Console.pl Znuny4OTRS::DefaultColumnsScreen::Remove --dynamicfield=FieldName --dynamicfield=FieldName2
```

Screen ist optional:
```
bin/otrs.Console.pl Znuny4OTRS::DefaultColumnsScreen::Remove --dynamicfield=FieldName --dynamicfield=FieldName2 --screen='DashboardBackend###0130-TicketOpen' --screen='Ticket::Frontend::AgentTicketQueue###DefaultColumns'
```


## Verwaltung von 'Dynamische Felder Oberflächen' via Konsole

Um im OTRS Standard dynamische Felder in allen möglichen Oberflächen hinzuzufügen, bearbeiten oder zu löschen muss jeder Konfigurationseintrag manuell über die SysConfig Oberfläche angepasst werden. Das neue OTRS Konsolenkommando "Znuny4OTRS::DynamicFieldScreen::Add" erleichtert diese Arbeit, indem das übergebene dynamische Felder in allen entsprechenden Oberflächen mit dem übergebenen Wert gesetzt wird.
Es können bestimmte / mehrere Oberflächen mit dem Parameter screen gesetzten werden.
Default werden alle mögliche Oberflächen verwendet.

### Hinzufügen

Die Hilfe kann wie folgt ausgegeben werden:
```
bin/otrs.Console.pl Znuny4OTRS::DynamicFieldScreen::Add
```

Die möglichen Screens und dynamischen Felder können wie folgt ausgegeben werden:
```
bin/otrs.Console.pl Znuny4OTRS::DynamicFieldScreen::Add --values
```

Beispielaufruf:
```
bin/otrs.Console.pl Znuny4OTRS::DynamicFieldScreen::Add --dynamicfield=FieldName --dynamicfield=FieldName2 --state 1
```

Screen ist optional:
```
bin/otrs.Console.pl Znuny4OTRS::DynamicFieldScreen::Add --dynamicfield=FieldName --dynamicfield=FieldName2 --state 1 --screen=AgentTicketNote --screen=AgentTicketZoom
```

### Löschen

Zum Löschen kann das Konsolenkommando "Znuny4OTRS::DynamicFieldScreen::Remove" analog verwendet werden.

Die Hilfe kann wie folgt ausgegeben werden:
```
bin/otrs.Console.pl Znuny4OTRS::DynamicFieldScreen::Remove
```

Die möglichen Screens und dynamischen Felder können wie folgt ausgegeben werden:
```
bin/otrs.Console.pl Znuny4OTRS::DynamicFieldScreen::Remove --values
```

Beispielaufruf:
```
bin/otrs.Console.pl Znuny4OTRS::DynamicFieldScreen::Remove --dynamicfield=FieldName --dynamicfield=FieldName2
```

Screen ist optional:
```
bin/otrs.Console.pl Znuny4OTRS::DynamicFieldScreen::Remove --dynamicfield=FieldName --dynamicfield=FieldName2 --screen=AgentTicketNote --screen=AgentTicketZoom
```
