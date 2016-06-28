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
    $Self->{Translation}->{'Management of DynamicFields <-> Screens'} = 'Verwaltung von Dynamische Feldern <-> Oberflächen';

    $Self->{Translation}->{'Dynamic Fields Screens'} = 'Dynamische Felder Oberflächen';
    $Self->{Translation}->{'DynamicFieldScreens'}    = 'Dynamische Felder Oberflächen';
    $Self->{Translation}->{'DefaultColumnsScreens'}  = 'DefaultColumns Oberflächen';
    $Self->{Translation}->{'DynamicFields'}          = 'Dynamische Felder';

    $Self->{Translation}->{'Available Elements'}         = 'Verfügbare Elemente';
    $Self->{Translation}->{'Assigned Elements'}          = 'Zugewiesene Elemente';
    $Self->{Translation}->{'Assigned Required Elements'} = 'Zugewiesene Pflichtelemente';

    $Self->{Translation}->{'Dynamic Fields for this Screen'}  = 'Dynamische Felder für die Oberfläche';
    $Self->{Translation}->{'Screens for this Dynamic Field'}  = 'Oberflächen für das dynamische Feld';

    # Filter
    $Self->{Translation}->{'Filter DynamicField Screen'}        = 'Oberflächen für Dynamische Felder filtern';
    $Self->{Translation}->{'Filter available elements'}         = 'Verfügbare Elemente filtern';
    $Self->{Translation}->{'Filter assigned elements'}          = 'Zugewiesene Elemente filtern';
    $Self->{Translation}->{'Filter assigned required elements'} = 'Zugewiesene Pflichtelemente filtern';

    return 1;
}

1;
