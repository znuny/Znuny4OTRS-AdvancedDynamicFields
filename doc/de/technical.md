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

## DynamicFieldScreensAdditional
```
    <!-- Znuny4OTRSAdvancedDynamicFields DynamicFieldScreens registration -->
    <ConfigItem Name="DynamicFieldScreens###Znuny4OTRS-PackageName" Required="1" Valid="1">
        <Description Translatable="1">This configuration defines all possible screens to enable or disable dynamic fields.</Description>
        <Group>Znuny4OTRS-AdvancedDynamicFields</Group>
        <SubGroup>Core</SubGroup>
        <Setting>
            <Hash>
                <Item Key="Ticket::Frontend::AgentTicketNewFunction###DynamicField">AgentTicketNewFunction</Item>
                <Item Key="Ticket::Frontend::AgentTicketNewFunction2###DynamicField">AgentTicketNewFunction2</Item>
            </Hash>
        </Setting>
    </ConfigItem>
```

## DefaultColumnsScreensAdditional
```
    <!-- Znuny4OTRSAdvancedDynamicFields DefaultColumnsScreens registration -->
    <ConfigItem Name="DefaultColumnsScreens###Znuny4OTRS-PackageName" Required="1" Valid="1">
        <Description Translatable="1">This configuration defines all possible screens to enable or disable default columns.</Description>
        <Group>Znuny4OTRS-AdvancedDynamicFields</Group>
        <SubGroup>Core</SubGroup>
        <Setting>
            <Hash>
                <!-- DefaultColumns -->
                <Item Key="Ticket::Frontend::AgentTicketNewFunction###DefaultColumns">AgentTicketNewFunction</Item>
                <Item Key="Ticket::Frontend::AgentTicketServiceNewFunction###DefaultColumns">AgentTicketServiceNewFunction</Item>
                <!-- DefaultColumns and Dashboard Widgets -->
                <Item Key="DashboardBackend###0100-TicketPendingReminderNewFunction">DashboardWidget TicketPendingReminderNewFunction</Item>
                <Item Key="AgentCustomerInformationCenter::Backend###0130-CIC-TicketOpenNewFunction">DashboardWidget CIC-TicketOpenNewFunction</Item>
            </Hash>
        </Setting>
    </ConfigItem>
```