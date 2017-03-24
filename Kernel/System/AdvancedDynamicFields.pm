# --
# Copyright (C) 2012-2017 Znuny GmbH, http://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
## nofilter(TidyAll::Plugin::OTRS::Legal::OTRSAGCopyright)

package Kernel::System::AdvancedDynamicFields;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DynamicField',
);

=head1 NAME

Kernel::System::AdvancedDynamicFields

=head1 SYNOPSIS

All AdvancedDynamicFields functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $AdvancedDynamicFieldsObject = $Kernel::OM->Get('Kernel::System::AdvancedDynamicFields');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=item GetValidDynamicFields()

Returns a list of valid dynamic fields.

    my $DynamicFields = $AdvancedDynamicFieldsObject->GetValidDynamicFields();

Returns:

    my $DynamicFields = {
        'Field1' => 'Field 1',
        'Field2' => 'Field2',
    };

=cut

sub GetValidDynamicFields {
    my ( $Self, %Param ) = @_;

    my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

    my $DynamicFieldValid = $ConfigObject->Get('Znuny4OTRSAdvancedDynamicFields::DynamicFieldValid');

    my $DynamicFieldList = $DynamicFieldObject->DynamicFieldListGet(
        ObjectType => 'Ticket',
        ResultType => 'HASH',
        Valid      => $DynamicFieldValid,
    );

    my $DynamicFields //= {};

    DYNAMICFIELD:
    for my $DynamicField ( @{$DynamicFieldList} ) {

        next DYNAMICFIELD if !IsHashRefWithData($DynamicField);

        # do not show internal fields for process management
        next DYNAMICFIELD if $DynamicField->{Name} eq 'ProcessManagementProcessID';
        next DYNAMICFIELD if $DynamicField->{Name} eq 'ProcessManagementActivityID';

        $DynamicFields->{ $DynamicField->{Name} } = $DynamicField->{Label};
    }

    return $DynamicFields;
}

=item GetValidScreens()

Returns a list of valid screens.

    my $ValidScreens = $AdvancedDynamicFieldsObject->GetValidScreens();

Returns:

    my $ValidScreens = {
        'DynamicFieldScreens' => {
           'Ticket::Frontend::AgentTicketZoom###DynamicField' => 'AgentTicketZoom',
           'Ticket::Frontend::AgentTicketZoom###ProcessWidgetDynamicField' => 'ProcessWidgetDynamicField'
           [...]
        },
        'DefaultColumnsScreens' => {
            'DashboardBackend###0110-TicketEscalation' => 'DashboardWidget TicketEscalation',
            'DashboardBackend###0130-TicketOpen' => 'DashboardWidget TicketOpen',
            [...]
        }
    };

=cut

sub GetValidScreens {
    my ( $Self, %Param ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $ValidScreens;
    for my $Screen (qw( DynamicFieldScreens DefaultColumnsScreens )) {

        $ValidScreens->{$Screen} = $ConfigObject->Get("Znuny4OTRSAdvancedDynamicFields::$Screen");

        for my $CurrentConfig ( sort keys %{ $ValidScreens->{$Screen} } ) {

            my ( $ConfigPath, $Key ) = split '###', $CurrentConfig;

            my $ConfigData = $ConfigObject->Get($ConfigPath);

            delete $ValidScreens->{$Screen}->{$CurrentConfig} if !defined $ConfigData->{$Key};

        }
    }

    return $ValidScreens;
}

=item GetValidAdditionalScreens()

Returns all additional screens for Znuny4OTRSAdvancedDynamicFields.

    my $ValidAdditionalScreens = $AdvancedDynamicFieldsObject->GetValidAdditionalScreens();

Returns:

    my $ValidAdditionalScreens = {
        'DynamicFieldScreens' => {
           'Ticket::Frontend::AgentTicketZoom###DynamicField' => 'AgentTicketZoom',
           'Ticket::Frontend::AgentTicketZoom###ProcessWidgetDynamicField' => 'ProcessWidgetDynamicField'
           [...]
        },
        'DefaultColumnsScreens' => {
            'DashboardBackend###0110-TicketEscalation' => 'DashboardWidget TicketEscalation',
            'DashboardBackend###0130-TicketOpen' => 'DashboardWidget TicketOpen',
            [...]
        }
    };

=cut

sub GetValidAdditionalScreens {
    my ( $Self, %Param ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $ValidAdditionalScreens;

    SCREEN:
    for my $Screen (qw( DynamicFieldScreens DefaultColumnsScreens )) {

        my %Config = %{ $ConfigObject->Get( "Znuny4OTRSAdvancedDynamicFields::" . $Screen . "Additional" ) || {} };
        next SCREEN if !%Config;

        ADDITIONAL:
        for my $Registration ( sort keys %Config ) {
            for my $CurrentConfig ( sort keys %{ $Config{$Registration} } ) {

                my ( $ConfigPath, $Key ) = split '###', $CurrentConfig;
                my $ConfigData = $ConfigObject->Get($ConfigPath);

                next ADDITIONAL if !defined $ConfigData->{$Key};

                $ValidAdditionalScreens->{$Screen}->{$CurrentConfig} = $Config{$Registration}->{$CurrentConfig};
            }
        }
    }

    return $ValidAdditionalScreens;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
