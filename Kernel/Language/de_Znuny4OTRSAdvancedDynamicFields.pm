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

    $Self->{Translation}->{'This configuration defines all possible Screens to enable or disable dynamic fields.'} = 'Diese Konfiguration definiert alle möglichen Oberflächen um dynamische Felder zu aktivieren oder zu deaktivieren.';

    # DynamicFieldScreen
    $Self->{Translation}->{'Dynamic Fields for Screen'} = 'Dynamische Felder für die Oberfläche';
    $Self->{Translation}->{'Dynamic Fields Screens'}     = 'Dynamische Felder Oberflächen';
    $Self->{Translation}->{'Assigned Required Fields'}  = 'Zugewiesene Pflichtfelder';
    $Self->{Translation}->{'Dynamic Field Screen Management'}  = 'Dynamische Feldern Oberflächen Verwaltung';

    $Self->{Translation}->{'You can assign Fields to this Screen by dragging the elements with the mouse from the left list to the right list.'} = 'Sie können dieser Oberfläche Dynamische Felder zuweisen, indem Sie sie mit der Maus aus der rechten Liste in die linke Liste verschieben.';
    $Self->{Translation}->{'Manage dynamic field in screens.'} = 'Verwaltung von dynamischen Feldern in Oberflächen';

    return 1;
}

1;
