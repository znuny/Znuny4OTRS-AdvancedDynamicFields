# --
# Copyright (C) 2012-2016 Znuny GmbH, http://znuny.com/
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

    # Frontend
    $Self->{Translation}->{'You can assign elements to this Screen/Field by dragging the elements with the mouse from the left list to the right list.'} = 'Sie können diese Elemente den Oberflächen/Feldern zuweisen, indem Sie sie mit der Maus aus der rechten Liste in die linke Liste verschieben.';
    $Self->{Translation}->{'Manage dynamic field in screens.'} = 'Verwaltung von dynamischen Feldern in Oberflächen';

    # $Self->{Translation}->{'This configuration defines all possible Screens to enable or disable dynamic fields.'} = 'Diese Konfiguration definiert alle möglichen Oberflächen um dynamische Felder zu aktivieren oder zu deaktivieren.';

    # Elements
    $Self->{Translation}->{'Management of Dynamic Fields <-> Screens'} = 'Verwaltung von Dynamische Feldern <-> Oberflächen';

    $Self->{Translation}->{'Dynamic Fields Screens'} = 'Dynamische Felder Oberflächen';
    $Self->{Translation}->{'DynamicField Screens'}    = 'Dynamische Felder Oberflächen';
    $Self->{Translation}->{'Default Columns Screens'}  = 'DefaultColumns Oberflächen';
    $Self->{Translation}->{'Dynamic Fields'}          = 'Dynamische Felder';

    $Self->{Translation}->{'Available Elements'}         = 'Verfügbare Elemente';
    $Self->{Translation}->{'Assigned Elements'}          = 'Zugewiesene Elemente';
    $Self->{Translation}->{'Assigned Required Elements'} = 'Zugewiesene Pflichtelemente';

    $Self->{Translation}->{'Dynamic Fields for this Screen'}  = 'Dynamische Felder für die Oberfläche';
    $Self->{Translation}->{'Screens for this Dynamic Field'}  = 'Oberflächen für das dynamische Feld';

    # Filter
    $Self->{Translation}->{'Filter Dynamic Fields Screen'}        = 'Oberflächen für Dynamische Felder filtern';
    $Self->{Translation}->{'Filter available elements'}         = 'Verfügbare Elemente filtern';
    $Self->{Translation}->{'Filter assigned elements'}          = 'Zugewiesene Elemente filtern';
    $Self->{Translation}->{'Filter assigned required elements'} = 'Zugewiesene Pflichtelemente filtern';

    $Self->{Translation}->{'Add DynamicField'}                      = 'Dynamiches Feld hinzufügen';

    $Self->{Translation}->{'Toggle all available elements'}         = 'Alle verfügbare Elemente umschalten';
    $Self->{Translation}->{'Toggle all assigned elements'}          = 'Alle zugewiesene Elemente umschalten';
    $Self->{Translation}->{'Toggle all assigned required elements'} = 'Alle zugewiesene Pflichtelemente umschalten';

    $Self->{Translation}->{'seleced to available elements'}         = 'Selektierte zu verfügbare Elemente';
    $Self->{Translation}->{'seleced to assigned elements'}          = 'Selektierte zu zugewiesene Elemente';
    $Self->{Translation}->{'seleced to assigned required elements'} = 'Selektierte zu zugewiesene Pflichtelemente';

    # SysConfig
    $Self->{Translation}->{'This configuration defines if only valids or all (invalids) dynamic fields should be shown.'} = 'Diese Konfiguration definiert ob nur gültige oder alle (ungültige) dynamischen Felder angezeigt werden sollen.';
    $Self->{Translation}->{'This configuration defines all possible Screens to enable or disable default columns'} = 'Diese Konfiguration definiert alle möglichen Oberflächen in denen dynamische Felder als DefaultColumns aktiviert/deaktiviert werden können.';
    $Self->{Translation}->{'This configuration defines all possible Screens to enable or disable dynamic fields'} = 'Diese Konfiguration definiert alle möglichen Oberflächen in denen dynamische Felder als DynamicFields aktiviert/deaktiviert werden können.';

    return 1;
}

1;
