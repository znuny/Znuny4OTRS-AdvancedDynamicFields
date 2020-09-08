# --
# Copyright (C) 2012-2020 Znuny GmbH, http://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::de_Znuny4OTRSAdvancedDynamicFields;

use strict;
use warnings;

use utf8;

sub Data {
    my $Self = shift;

    # Import / Export
    # Frontend
    $Self->{Translation}->{'Here you can upload a configuration file to import dynamic fields to your system. The file needs to be in .yml format as exported by dynamic field management module.'} = 'Hier können Sie eine Konfigurationsdatei hochladen, um dynamische Felder auf Ihr System zu importieren. Die Datei muss im .yml-Format vorliegen, wie es von dem dynamischen Feld Verwaltungsmodul exportiert wird.';

    $Self->{Translation}->{'Here you can export a configuration file of dynamic fields and dynamic field screens to import these on another system. The configuration file is exported in yml format.'} = 'Hier können Sie eine Konfigurationsdatei von dynamischen Feldern und dynamischen Felder Oberflächen exportieren, um diese auf einem anderen System zu importieren. Die Konfigurationsdatei wird im yml Format exportiert.';

    $Self->{Translation}->{"Select the desired elements and confirm the import with 'import'."} = "Selektieren Sie die gewünschten Elemente und bestätigen Sie den Import mit 'importieren'.";

    $Self->{Translation}->{'Select the items you want to '} = 'Wählen Sie die Elemente aus, um sie zu ';

    $Self->{Translation}->{'Here you can manage the dynamic fields in the respective screens.'} = 'Hier können Sie die dynamischen Felder in den jeweiligen Oberflächen verwalten.';

    $Self->{Translation}->{'The following dynamic fields can not be imported because of an invalid backend.'} = 'Die folgenden dynamischen Felder können aufgrund eines ungültigen Backends nicht importiert werden.';

    $Self->{Translation}->{'DynamicFields Import'} = 'Dynamische Felder importieren';
    $Self->{Translation}->{'DynamicFields Export'} = 'Dynamische Felder exportieren';

    $Self->{Translation}->{'Screens'} = 'Oberflächen';
    $Self->{Translation}->{'Fields'}  = 'Felder';

    $Self->{Translation}->{'Export'}  = 'Exportieren';
    $Self->{Translation}->{'Import'}  = 'Importieren';

    # Screens
    # Frontend
    $Self->{Translation}->{'You can assign elements to this Screen/Field by dragging the elements with the mouse from the left list to the right list.'} = 'Sie können diese Elemente den Oberflächen/Feldern zuweisen, indem Sie sie mit der Maus aus der rechten Liste in die linke Liste verschieben.';

    $Self->{Translation}->{'Manage dynamic field in screens.'} = 'Verwaltung von dynamischen Feldern in Oberflächen.';

    $Self->{Translation}->{'Settings were reset.'} = 'Einstellungen wurden zurückgesetzt.';
    $Self->{Translation}->{'Settings were saved.'} = 'Einstellungen wurden gespeichert.';

    $Self->{Translation}->{'System was not able to save the setting!'}  = 'Das System konnte die Einstellung nicht speichern!';
    $Self->{Translation}->{'System was not able to reset the setting!'} = 'Das System konnte die Einstellung nicht zurücksetzen!';

    # Elements
    $Self->{Translation}->{'Management of Dynamic Fields <-> Screens'} = 'Verwaltung von Dynamische Feldern <-> Oberflächen';

    $Self->{Translation}->{'Dynamic Fields Screens'}  = 'Dynamische Felder Oberflächen';
    $Self->{Translation}->{'DynamicField Screens'}    = 'Dynamische Felder Oberflächen';
    $Self->{Translation}->{'Default Columns Screens'} = 'DefaultColumns Oberflächen';
    $Self->{Translation}->{'Dynamic Fields'}          = 'Dynamische Felder';

    $Self->{Translation}->{'Available Elements'}         = 'Verfügbare Elemente';
    $Self->{Translation}->{'Disabled Elements'}          = 'Deaktivierte Elemente';
    $Self->{Translation}->{'Assigned Elements'}          = 'Zugewiesene Elemente';
    $Self->{Translation}->{'Assigned Required Elements'} = 'Zugewiesene Pflichtelemente';

    $Self->{Translation}->{'Dynamic Fields for this Screen'}  = 'Dynamische Felder für die Oberfläche';
    $Self->{Translation}->{'Screens for this Dynamic Field'}  = 'Oberflächen für das dynamische Feld';

    # Filter
    $Self->{Translation}->{'Filter Dynamic Fields Screen'}      = 'Oberflächen für Dynamische Felder filtern';
    $Self->{Translation}->{'Filter available elements'}         = 'Verfügbare Elemente filtern';
    $Self->{Translation}->{'Filter disabled elements'}          = 'Deaktivierte Elemente filtern';
    $Self->{Translation}->{'Filter assigned elements'}          = 'Zugewiesene Elemente filtern';
    $Self->{Translation}->{'Filter assigned required elements'} = 'Zugewiesene Pflichtelemente filtern';

    $Self->{Translation}->{'Add DynamicField'}                      = 'Dynamiches Feld hinzufügen';

    $Self->{Translation}->{'Toggle all available elements'}         = 'Alle verfügbare Elemente umschalten';
    $Self->{Translation}->{'Toggle all assigned elements'}          = 'Alle zugewiesene Elemente umschalten';
    $Self->{Translation}->{'Toggle all disabled elements'}          = 'Alle deaktivierte Elemente umschalten';
    $Self->{Translation}->{'Toggle all assigned required elements'} = 'Alle zugewiesene Pflichtelemente umschalten';

    $Self->{Translation}->{'selected to available elements'}         = 'Selektierte zu verfügbare Elemente';
    $Self->{Translation}->{'selected to disabled elements'}          = 'Selektierte zu deaktivierte Elemente';
    $Self->{Translation}->{'selected to assigned elements'}          = 'Selektierte zu zugewiesene Elemente';
    $Self->{Translation}->{'selected to assigned required elements'} = 'Selektierte zu zugewiesene Pflichtelemente';

    # SysConfig
    $Self->{Translation}->{'This configuration defines if only valids or all (invalids) dynamic fields should be shown.'} = 'Diese Konfiguration definiert ob nur gültige oder alle (ungültige) dynamischen Felder angezeigt werden sollen.';

    $Self->{Translation}->{'This configuration defines all screens that do not allow dynamic field input to be required.'} = 'Diese Konfiguration definiert alle Oberflächen, in denen dynamische Felder keine Pflichteingaben erfordern dürfen.';
    $Self->{Translation}->{'Contains dynamic field screen config keys and their action, grouped by object type.'}
        = 'Enthält die Config-Keys zur Aktivierung von dynamischen Feldern in den verschiedenen Dialogen, inkl. zugehöriger Action, gruppiert nach Objekttyp.';
    $Self->{Translation}->{'This configuration defines all possible screens to enable or disable default columns.'} = 'Diese Konfiguration definiert alle möglichen Oberflächen in denen dynamische Felder als DefaultColumns aktiviert/deaktiviert werden können.';

    $Self->{Translation}->{'This configuration defines all possible screens to enable or disable dynamic fields.'} = 'Diese Konfiguration definiert alle möglichen Oberflächen in denen dynamische Felder als DynamicFields aktiviert/deaktiviert werden können.';

    return 1;
}

1;
