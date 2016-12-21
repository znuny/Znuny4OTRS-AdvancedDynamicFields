# Advanced DynamicFields

OTRS hat im standard Framework nur eine bestimmte Anzahl an Oberflächen in denen dynamische Felder aktiviert werden können.

Einige Erweiterungen enthalten jedoch zusätzliche Oberflächen in denen ebenfalls dynamische Felder aktiviert werden können. Um diese Oberflächen auch via Znuny4OTRS-AdvancedDynamicFields konfigurieren zu können, wird für jede Oberfläche eine zusätzliche Konfiguration benötigt.

Znuny4OTRS-AdvancedDynamicFields prüft dann, ob dieses Packet z.B. 'Znuny4OTRS-PackageName' installiert ist und fügt dann die möglichen Oberflächen hinzu.

Diese Konfiguration kann mit dem yeahman hinzugefügt werden:
```
yeah otrs
Advanced Dynamic Fields
```


Alternativ können auch folgende Konfigurationen genutzt werden.

## DefaultColumnsScreensAdditional
```
<!-- Znuny4OTRSAdvancedDynamicFields DefaultColumnsScreens registration -->
<ConfigItem Name="Znuny4OTRSAdvancedDynamicFields::DefaultColumnsScreensAdditional###Znuny4OTRS-PackageName" Required="1" Valid="1">
    <Description Translatable="1">This configuration defines all possible screens to enable or disable default columns.</Description>
    <Group>Znuny4OTRS-AdvancedDynamicFields</Group>
    <SubGroup>DynamicFieldScreen</SubGroup>
    <Setting>
        <Hash>
            <Item Key="PathToDefaultColoumnInSysConfig###DefaultColumns">VisibleName</Item>
            <Item Key="Ticket::Frontend::AgentTicketPackageName###DefaultColumns">AgentTicketWatchlistExtendedOverview</Item>
        </Hash>
    </Setting>
</ConfigItem>
```

## DynamicFieldScreensAdditional
```
<!-- Znuny4OTRSAdvancedDynamicFields DynamicFieldScreens registration -->
<ConfigItem Name="Znuny4OTRSAdvancedDynamicFields::DynamicFieldScreensAdditional###Znuny4OTRS-PackageName" Required="1" Valid="1">
    <Description Translatable="1">This configuration defines all possible screens to enable or disable dynamic fields.</Description>
    <Group>Znuny4OTRS-AdvancedDynamicFields</Group>
    <SubGroup>Core</SubGroup>
    <Setting>
        <Hash>
            <Item Key="PathToDefaultColoumnInSysConfig###DynamicField">VisibleName</Item>
            <Item Key="Ticket::Frontend::AgentTicketPackageName###DynamicField">ModuleName</Item>
        </Hash>
    </Setting>
</ConfigItem>
```