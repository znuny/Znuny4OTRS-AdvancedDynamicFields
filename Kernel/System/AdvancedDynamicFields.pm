# --
# Copyright (C) 2012-2020 Znuny GmbH, http://znuny.com/
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
    'Kernel::System::Log',
    'Kernel::System::Package',
    'Kernel::System::ZnunyHelper',
);

=head1 NAME

Kernel::System::AdvancedDynamicFields

=head1 SYNOPSIS

All AdvancedDynamicFields functions.

=head1 PUBLIC INTERFACE

=head2 new()

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

=head2 GetValidDynamicFields()

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
        ResultType => 'HASH',
        Valid      => $DynamicFieldValid,
    );

    my $DynamicFields = {};

    DYNAMICFIELD:
    for my $DynamicField ( @{$DynamicFieldList} ) {

        next DYNAMICFIELD if !IsHashRefWithData($DynamicField);

        $DynamicFields->{ $DynamicField->{Name} } = $DynamicField->{Label};
    }

    return $DynamicFields;
}

=head2 DynamicFieldNonRequiredScreensListGet()

Returns a list of non required screens for dynamic fields.
'Ticket::Frontend::AgentTicketZoom###DynamicField' has no option '2'

    my $DynamicFieldNonRequiredScreensList = $AdvancedDynamicFieldsObject->DynamicFieldNonRequiredScreensListGet(
        Result => 'ARRAY', # HASH or ARRAY, defaults to ARRAY
    );

Returns as HASH:

    my $DynamicFieldNonRequiredScreensList = {

       'Ticket::Frontend::AgentTicketZoom###DynamicField' => 'AgentTicketZoom',
       'Ticket::Frontend::AgentTicketZoom###ProcessWidgetDynamicField' => 'ProcessWidgetDynamicField'
       [...]
    };

Returns as ARRAY:

    my $DynamicFieldNonRequiredScreensList = [
       'Ticket::Frontend::AgentTicketZoom###DynamicField',
       'Ticket::Frontend::AgentTicketZoom###ProcessWidgetDynamicField',
       [...]
    ];

=cut

sub DynamicFieldNonRequiredScreensListGet {
    my ( $Self, %Param ) = @_;

    my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');
    my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');

    $Param{Result} = lc( $Param{Result} // 'array' );

    my $NonRequiredScreens;

    my $Screen = 'DynamicFieldNonRequiredScreens';
    $NonRequiredScreens = {};
    my $ScreenRegistrations = $ConfigObject->Get($Screen);

    REGISTRATION:
    for my $Registration ( sort keys %{$ScreenRegistrations} ) {
        if ( $Registration =~ m{^ITSM.*}xmsi ) {
            my $IsInstalled = $PackageObject->PackageIsInstalled(
                Name => $Registration,
            );
            next REGISTRATION if !$IsInstalled;
        }

        %{$NonRequiredScreens} = (
            %{$NonRequiredScreens},
            %{ $ScreenRegistrations->{$Registration} },
        );
    }

    # check if config is already valid / defined
    for my $CurrentConfig ( sort keys %{$NonRequiredScreens} ) {
        my ( $ConfigPath, $Key ) = split '###', $CurrentConfig;
        my $ConfigData = $ConfigObject->Get($ConfigPath);

        delete $NonRequiredScreens->{$CurrentConfig} if !defined $ConfigData->{$Key};
    }

    return $NonRequiredScreens if lc $Param{Result} ne 'array';

    my @Array = sort keys %{$NonRequiredScreens};
    $NonRequiredScreens = \@Array;

    return $NonRequiredScreens;
}

=head2 ValidateShowID()

Validate screen config and changed option value of current dynamic field or screen

    my %NewConfig = $AdvancedDynamicFieldsObject->ValidateShowID(
        Element => $Element,
        Config  => \%Config,
    );

    my %NewConfig = $AdvancedDynamicFieldsObject->ValidateShowID(
        Element => $Element,
        Config  => {
            'Ticket::Frontend::AgentTicketNote###DynamicField' => 2,
            'Ticket::Frontend::AgentTicketZoom###DynamicField' => 2,
        }
    );

Returns:

    my %NewConfig = (
        'Ticket::Frontend::AgentTicketNote###DynamicField' => 2,
        'Ticket::Frontend::AgentTicketZoom###DynamicField' => 1,
    );

=cut

sub ValidateShowID {
    my ( $Self, %Param ) = @_;

    my $LogObject         = $Kernel::OM->Get('Kernel::System::Log');
    my $ZnunyHelperObject = $Kernel::OM->Get('Kernel::System::ZnunyHelper');
    my $ConfigObject      = $Kernel::OM->Get('Kernel::Config');

    NEEDED:
    for my $Needed (qw(Config Element)) {

        next NEEDED if defined $Param{$Needed};

        $LogObject->Log(
            Priority => 'error',
            Message  => "Parameter '$Needed' is needed in !",
        );
        return;
    }

    my @NonRequiredScreens = @{
        $Self->DynamicFieldNonRequiredScreensListGet(
            Result => 'ARRAY',
            )
    };

    my %NewConfig = %{ $Param{Config} };

    my $ValidDynamicFieldScreenList = $ZnunyHelperObject->_ValidDynamicFieldScreenListGet(
        Result => 'ARRAY',
    );

    my $ElementType;
    for my $ValidDynamicFieldScreenType ( sort keys %{$ValidDynamicFieldScreenList} ) {
        my @ValidDynamicFieldScreens = @{ $ValidDynamicFieldScreenList->{$ValidDynamicFieldScreenType} };

        my $IsElementIsScreen = grep { $Param{Element} eq $_ } @ValidDynamicFieldScreens;
        if ($IsElementIsScreen) {
            $ElementType = 'Screen';
        }
    }

    my $DynamicFields = $Self->GetValidDynamicFields();
    if ( $DynamicFields->{ $Param{Element} } ) {
        $ElementType = 'DynamicField';
    }

    return %NewConfig if !$ElementType;

    if ( $ElementType eq 'Screen' ) {
        my $IsScreenNonRequiredScreen = grep { $Param{Element} eq $_ } @NonRequiredScreens;

        return %NewConfig if !$IsScreenNonRequiredScreen;

        my %ChangedConfig = map { $_ => 1 } grep { $Param{Config}->{$_} eq 2 } sort keys %{ $Param{Config} };

        %NewConfig = (
            %{ $Param{Config} },
            %ChangedConfig,
        );
        return %NewConfig;
    }

    if ( $ElementType eq 'DynamicField' ) {

        my %ChangedConfig;

        SCREEN:
        for my $Screen ( sort keys %{ $Param{Config} } ) {

            my $IsScreenNonRequiredScreen = grep { $Screen eq $_ } @NonRequiredScreens;

            next SCREEN if !$IsScreenNonRequiredScreen || $Param{Config}->{$Screen} ne 2;
            $ChangedConfig{$Screen} = 1;
        }

        %NewConfig = (
            %{ $Param{Config} },
            %ChangedConfig,
        );
        return %NewConfig;
    }

    return %NewConfig;
}

1;
