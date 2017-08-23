# Advanced DynamicFields

This package add an easy way to configure dynamic fields.

With a default OTRS it is not possible to do central management of the dynamic fields shown in each screen. You have to configure each view independent via the SysConfig.

# GUI

![Dynamic Fields Screens](doc/en/images/Admin.png)

From now you can do this by with a new administration interface available via 'Admin' -> 'Dynamic Fields Screens'.

![AdminDynamicFieldScreen](doc/en/images/AdminDynamicFieldScreen.png)

The administration GUI shows the categories **DYNAMIC FIELDS SCREENS**, **DEFAULT COLUMNS SCREENS**  und **DYNAMIC FIELDS**.

 * **DYNAMIC FIELDS SCREENS**
 contains all screen where dynamic fields can be configured to be displayed.

 * **DEFAULT COLUMNS SCREENS**
 contains all screens / tables (overviews) where dynamic fields can be added as a column.

 * **DYNAMIC FIELDS**
 contains all dynamic fields which can be added to **DYNAMIC FIELDS SCREENS** and **DEFAULT COLUMNS SCREENS**.

![AdminDynamicFieldScreenEditDynamicField](doc/en/images/AdminDynamicFieldScreenEditDynamicField.png)

![AdminDynamicFieldScreenEditScreen](doc/en/images/AdminDynamicFieldScreenEditScreen.png)

The configuration is easy done by drag and drop.


# Console commands

## Management of Default Columns

To manage the OTRS ticket attributes of a dashboard widget you have to configure the one by one via the SysConfig.
The new console command "Znuny4OTRS::DashboardColumn::Add" supports you with this by configure the given attribute to all dashboards.

### Add

With the following command a help screen is shown:
```
bin/otrs.Console.pl Znuny4OTRS::DefaultColumnsScreen::Add
```

Example:
```
bin/otrs.Console.pl Znuny4OTRS::DefaultColumnsScreen::Add --dynamicfield=FieldName --dynamicfield=FieldName2 --state 1
```

Screen is optional:
```
bin/otrs.Console.pl Znuny4OTRS::DefaultColumnsScreen::Add --dynamicfield=FieldName --dynamicfield=FieldName2 --state 1 --screen='DashboardBackend###0130-TicketOpen' --screen='Ticket::Frontend::AgentTicketQueue###DefaultColumns'
```

### Delete

For deletion the command "Znuny4OTRS::DashboardColumn::Remove" could be used in the same way.

With the following command a help screen is shown:
```
bin/otrs.Console.pl Znuny4OTRS::DefaultColumnsScreen::Remove
```

Example:
```
bin/otrs.Console.pl Znuny4OTRS::DefaultColumnsScreen::Remove --dynamicfield=FieldName --dynamicfield=FieldName2
```

Screen is optional:
```
bin/otrs.Console.pl Znuny4OTRS::DefaultColumnsScreen::Remove --dynamicfield=FieldName --dynamicfield=FieldName2 --screen='DashboardBackend###0130-TicketOpen' --screen='Ticket::Frontend::AgentTicketQueue###DefaultColumns'
```


## Management of 'Dynamic Fields Screens' via console

With a default OTRS you have to configure each screen in single step to manage dynamic fields via the SysConfig. The new console command "Znuny4OTRS::DynamicFieldScreen::Add" supports to do this job. The given dynamic fields are configured to all screens with the given state.
By using the parameter screen it is possible to configure specific screens. By default all available screens are configured.

### Add

With the following command a help screen is shown:
```
bin/otrs.Console.pl Znuny4OTRS::DynamicFieldScreen::Add
```

All available screens and dynamic fields are shown by this command:
```
bin/otrs.Console.pl Znuny4OTRS::DynamicFieldScreen::Add --values
```

Example:
```
bin/otrs.Console.pl Znuny4OTRS::DynamicFieldScreen::Add --dynamicfield=FieldName --dynamicfield=FieldName2 --state 1
```

The screen parameter is optional:
```
bin/otrs.Console.pl Znuny4OTRS::DynamicFieldScreen::Add --dynamicfield=FieldName --dynamicfield=FieldName2 --state 1 --screen=AgentTicketNote --screen=AgentTicketZoom
```

### Delete

To remove dynamic screen the command "Znuny4OTRS::DynamicFieldScreen::Remove" can be used similar.

With the following command a help screen is shown:
```
bin/otrs.Console.pl Znuny4OTRS::DynamicFieldScreen::Remove
```

All available screens and dynamic fields are shown by this command:
```
bin/otrs.Console.pl Znuny4OTRS::DynamicFieldScreen::Remove --values
```

Example:
```
bin/otrs.Console.pl Znuny4OTRS::DynamicFieldScreen::Remove --dynamicfield=FieldName --dynamicfield=FieldName2
```

The screen parameter is optional:
```
bin/otrs.Console.pl Znuny4OTRS::DynamicFieldScreen::Remove --dynamicfield=FieldName --dynamicfield=FieldName2 --screen=AgentTicketNote --screen=AgentTicketZoom
```
