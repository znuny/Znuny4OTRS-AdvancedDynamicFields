# --
# Copyright (C) 2012-2022 Znuny GmbH, http://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::System::VariableCheck qw(:all);

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);

my $ZnunyHelperObject           = $Kernel::OM->Get('Kernel::System::ZnunyHelper');
my $AdvancedDynamicFieldsObject = $Kernel::OM->Get('Kernel::System::AdvancedDynamicFields');
my $HelperObject                = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $DynamicFieldNonRequiredScreensList = $AdvancedDynamicFieldsObject->GetDynamicFieldNonRequiredScreensList(
    Result => 'ARRAY',
);

$Self->IsDeeply(
    $DynamicFieldNonRequiredScreensList,
    [
        'Ticket::Frontend::AgentTicketPrint###DynamicField',
        'Ticket::Frontend::AgentTicketZoom###DynamicField',
        'Ticket::Frontend::AgentTicketZoom###ProcessWidgetDynamicField',
        'Ticket::Frontend::CustomerTicketOverview###DynamicField',
        'Ticket::Frontend::CustomerTicketPrint###DynamicField',
        'Ticket::Frontend::CustomerTicketSearch###DynamicField',
        'Ticket::Frontend::CustomerTicketZoom###DynamicField',
        'Ticket::Frontend::OverviewMedium###DynamicField',
        'Ticket::Frontend::OverviewPreview###DynamicField',
        'Ticket::Frontend::OverviewSmall###DynamicField'
    ],
    'GetDynamicFieldNonRequiredScreensList ARRAY',
);

$DynamicFieldNonRequiredScreensList = $AdvancedDynamicFieldsObject->GetDynamicFieldNonRequiredScreensList(
    Result => 'HASH',
);

$Self->IsDeeply(
    $DynamicFieldNonRequiredScreensList,
    {
        'Ticket::Frontend::AgentTicketPrint###DynamicField'             => 'AgentTicketPrint',
        'Ticket::Frontend::AgentTicketZoom###DynamicField'              => 'AgentTicketZoom',
        'Ticket::Frontend::AgentTicketZoom###ProcessWidgetDynamicField' => 'ProcessWidgetDynamicField',
        'Ticket::Frontend::CustomerTicketOverview###DynamicField'       => 'CustomerTicketOverview',
        'Ticket::Frontend::CustomerTicketPrint###DynamicField'          => 'CustomerTicketPrint',
        'Ticket::Frontend::CustomerTicketSearch###DynamicField'         => 'CustomerTicketSearch',
        'Ticket::Frontend::CustomerTicketZoom###DynamicField'           => 'CustomerTicketZoom',
        'Ticket::Frontend::OverviewMedium###DynamicField'               => 'OverviewMedium',
        'Ticket::Frontend::OverviewPreview###DynamicField'              => 'OverviewPreview',
        'Ticket::Frontend::OverviewSmall###DynamicField'                => 'OverviewSmall',
    },
    'GetDynamicFieldNonRequiredScreensList HASH',
);

my %NonRequiredScreens = (
    'Ticket::Frontend::AgentTicketPrint###DynamicField'             => 2,
    'Ticket::Frontend::AgentTicketZoom###DynamicField'              => 2,
    'Ticket::Frontend::AgentTicketZoom###ProcessWidgetDynamicField' => 2,
    'Ticket::Frontend::CustomerTicketOverview###DynamicField'       => 2,
    'Ticket::Frontend::CustomerTicketPrint###DynamicField'          => 2,
    'Ticket::Frontend::CustomerTicketSearch###DynamicField'         => 2,
    'Ticket::Frontend::CustomerTicketZoom###DynamicField'           => 2,
    'Ticket::Frontend::OverviewMedium###DynamicField'               => 2,
    'Ticket::Frontend::OverviewPreview###DynamicField'              => 2,
    'Ticket::Frontend::OverviewSmall###DynamicField'                => 2,
);

my $RandomID1 = $HelperObject->GetRandomID();
my $RandomID2 = $HelperObject->GetRandomID();

my @DynamicFields = (
    {
        Name          => 'TestDynamicField' . $RandomID1,
        Label         => "TestDynamicField" . $RandomID1,
        InternalField => 0,
        ObjectType    => 'Ticket',
        FieldType     => 'Text',
        Config        => {
            DefaultValue => "",
        },
    },
    {
        Name          => 'TestDynamicField' . $RandomID2,
        Label         => "TestDynamicField" . $RandomID2,
        InternalField => 0,
        ObjectType    => 'Ticket',
        FieldType     => 'Text',
        Config        => {
            DefaultValue => "",
        },
    },
);

my $Success = $ZnunyHelperObject->_DynamicFieldsCreate(@DynamicFields);

# Element: Screen

my $Element;
my %NewConfig;
my %Config = (
    'TestDynamicField' . $RandomID1 => 1,
    'TestDynamicField' . $RandomID2 => 2,
);

for my $NonRequiredScreen ( sort keys %NonRequiredScreens ) {
    my $Element = $NonRequiredScreen;

    %NewConfig = $AdvancedDynamicFieldsObject->ValidateShowID(
        Config  => \%Config,
        Element => $Element,
    );

    $Self->IsNotDeeply(
        \%Config,
        \%NewConfig,
        "ValidateShowID - $Element - is not equal to first config",
    );
    $Self->IsDeeply(
        \%NewConfig,
        {
            'TestDynamicField' . $RandomID1 => 1,
            'TestDynamicField' . $RandomID2 => 1,
        },
        "ValidateShowID - $Element - config changed",
    );
}

# Test with RequiredScreen
$Element = 'Ticket::Frontend::AgentTicketNote###DynamicField';

%NewConfig = $AdvancedDynamicFieldsObject->ValidateShowID(
    Config  => \%Config,
    Element => $Element,
);

$Self->IsDeeply(
    \%Config,
    \%NewConfig,
    "ValidateShowID - $Element - is equal to first config",
);

# Element: DynamicField
$Element = 'TestDynamicField' . $RandomID1;

for my $NonRequiredScreen ( sort keys %NonRequiredScreens ) {
    %Config                     = ();
    $Config{$NonRequiredScreen} = $NonRequiredScreens{$NonRequiredScreen};
    %NewConfig                  = $AdvancedDynamicFieldsObject->ValidateShowID(
        Config  => \%Config,
        Element => $Element,
    );

    $Self->IsNotDeeply(
        \%Config,
        \%NewConfig,
        "ValidateShowID - $Element - is not equal to first config",
    );
    $Self->IsDeeply(
        \%NewConfig,
        {
            $NonRequiredScreen => 1,
        },
        "ValidateShowID - $Element - config changed",
    );
}

# single test
%Config = (
    'Ticket::Frontend::AgentTicketNote###DynamicField' => 2,
    'Ticket::Frontend::AgentTicketZoom###DynamicField' => 2,
);

%NewConfig = $AdvancedDynamicFieldsObject->ValidateShowID(
    Config  => \%Config,
    Element => $Element,
);

$Self->IsDeeply(
    \%NewConfig,
    {
        'Ticket::Frontend::AgentTicketNote###DynamicField' => 2,
        'Ticket::Frontend::AgentTicketZoom###DynamicField' => 1,
    },
    "ValidateShowID - $Element - change value for AgentTicketZoom",
);

# GetDynamicFieldObjectTypeScreens
my %DynamicFieldObjectTypeScreens = $AdvancedDynamicFieldsObject->GetDynamicFieldObjectTypeScreens(
    ObjectType => 'Ticket',
);

$Self->IsDeeply(
    \%DynamicFieldObjectTypeScreens,
    {
        'AgentCustomerInformationCenter::Backend###0100-CIC-TicketPendingReminder' =>
            'DashboardWidget CIC-TicketPendingReminder',
        'AgentCustomerInformationCenter::Backend###0110-CIC-TicketEscalation' => 'DashboardWidget CIC-TicketEscalation',
        'AgentCustomerInformationCenter::Backend###0120-CIC-TicketNew'        => 'DashboardWidget CIC-TicketNew',
        'AgentCustomerInformationCenter::Backend###0130-CIC-TicketOpen'       => 'DashboardWidget CIC-TicketOpen',
        'AgentCustomerUserInformationCenter::Backend###0100-CUIC-TicketPendingReminder' =>
            'DashboardWidget CUIC-TicketPendingReminder',
        'AgentCustomerUserInformationCenter::Backend###0110-CUIC-TicketEscalation' =>
            'DashboardWidget CUIC-TicketEscalation',
        'AgentCustomerUserInformationCenter::Backend###0120-CUIC-TicketNew'  => 'DashboardWidget CUIC-TicketNew',
        'AgentCustomerUserInformationCenter::Backend###0130-CUIC-TicketOpen' => 'DashboardWidget CUIC-TicketOpen',
        'DashboardBackend###0100-TicketPendingReminder'                      => 'DashboardWidget TicketPendingReminder',
        'DashboardBackend###0110-TicketEscalation'                           => 'DashboardWidget TicketEscalation',
        'DashboardBackend###0120-TicketNew'                                  => 'DashboardWidget TicketNew',
        'DashboardBackend###0130-TicketOpen'                                 => 'DashboardWidget TicketOpen',
        'DashboardBackend###0140-RunningTicketProcess'                       => 'DashboardWidget RunningTicketProcess',
        'Ticket::Frontend::AgentTicketClose###DynamicField'                  => 'AgentTicketClose',
        'Ticket::Frontend::AgentTicketCompose###DynamicField'                => 'AgentTicketCompose',
        'Ticket::Frontend::AgentTicketEmail###DynamicField'                  => 'AgentTicketEmail',
        'Ticket::Frontend::AgentTicketEmailOutbound###DynamicField'          => 'AgentTicketEmailOutbound',
        'Ticket::Frontend::AgentTicketEscalationView###DefaultColumns'       => 'AgentTicketEscalationView',
        'Ticket::Frontend::AgentTicketForward###DynamicField'                => 'AgentTicketForward',
        'Ticket::Frontend::AgentTicketFreeText###DynamicField'               => 'AgentTicketFreeText',
        'Ticket::Frontend::AgentTicketLockedView###DefaultColumns'           => 'AgentTicketLockedView',
        'Ticket::Frontend::AgentTicketMove###DynamicField'                   => 'AgentTicketMove',
        'Ticket::Frontend::AgentTicketNote###DynamicField'                   => 'AgentTicketNote',
        'Ticket::Frontend::AgentTicketOwner###DynamicField'                  => 'AgentTicketOwner',
        'Ticket::Frontend::AgentTicketPending###DynamicField'                => 'AgentTicketPending',
        'Ticket::Frontend::AgentTicketPhone###DynamicField'                  => 'AgentTicketPhone',
        'Ticket::Frontend::AgentTicketPhoneInbound###DynamicField'           => 'AgentTicketPhoneInbound',
        'Ticket::Frontend::AgentTicketPhoneOutbound###DynamicField'          => 'AgentTicketPhoneOutbound',
        'Ticket::Frontend::AgentTicketPrint###DynamicField'                  => 'AgentTicketPrint',
        'Ticket::Frontend::AgentTicketPriority###DynamicField'               => 'AgentTicketPriority',
        'Ticket::Frontend::AgentTicketQueue###DefaultColumns'                => 'AgentTicketQueue',
        'Ticket::Frontend::AgentTicketResponsible###DynamicField'            => 'AgentTicketResponsible',
        'Ticket::Frontend::AgentTicketResponsibleView###DefaultColumns'      => 'AgentTicketResponsibleView',
        'Ticket::Frontend::AgentTicketSearch###DefaultColumns'               => 'AgentTicketSearch',
        'Ticket::Frontend::AgentTicketSearch###DynamicField'                 => 'AgentTicketSearch',
        'Ticket::Frontend::AgentTicketService###DefaultColumns'              => 'AgentTicketService',
        'Ticket::Frontend::AgentTicketStatusView###DefaultColumns'           => 'AgentTicketStatusView',
        'Ticket::Frontend::AgentTicketWatchView###DefaultColumns'            => 'AgentTicketWatchView',
        'Ticket::Frontend::AgentTicketZoom###DynamicField'                   => 'AgentTicketZoom',
        'Ticket::Frontend::AgentTicketZoom###ProcessWidgetDynamicField'      => 'ProcessWidgetDynamicField',
        'Ticket::Frontend::CustomerTicketMessage###DynamicField'             => 'CustomerTicketMessage',
        'Ticket::Frontend::CustomerTicketOverview###DynamicField'            => 'CustomerTicketOverview',
        'Ticket::Frontend::CustomerTicketPrint###DynamicField'               => 'CustomerTicketPrint',
        'Ticket::Frontend::CustomerTicketSearch###DynamicField'              => 'CustomerTicketSearch',
        'Ticket::Frontend::CustomerTicketZoom###DynamicField'                => 'CustomerTicketZoom',
        'Ticket::Frontend::OverviewMedium###DynamicField'                    => 'OverviewMedium',
        'Ticket::Frontend::OverviewPreview###DynamicField'                   => 'OverviewPreview',
        'Ticket::Frontend::OverviewSmall###DynamicField'                     => 'OverviewSmall',
    },
    "GetDynamicFieldObjectTypeScreens - Ticket",
);

my %Screens = (
    'Ticket::Frontend::NOTEXISTS###DynamicField'        => 'NOTEXISTS',
    'Ticket::Frontend::AgentTicketPrint###DynamicField' => 'AgentTicketPrint',
    'Ticket::Frontend::AgentTicketZoom###DynamicField'  => 'AgentTicketZoom',
);

%DynamicFieldObjectTypeScreens = $AdvancedDynamicFieldsObject->GetDynamicFieldObjectTypeScreens(
    ObjectType => 'Ticket',
    Screens    => \%Screens
);

$Self->IsDeeply(
    \%DynamicFieldObjectTypeScreens,
    {
        'Ticket::Frontend::AgentTicketPrint###DynamicField' => 'AgentTicketPrint',
        'Ticket::Frontend::AgentTicketZoom###DynamicField'  => 'AgentTicketZoom',
    },
    "GetDynamicFieldObjectTypeScreens - Ticket - Screens",
);

my @GetDynamicFieldObjectTypes = $AdvancedDynamicFieldsObject->GetDynamicFieldObjectTypes();

$Self->IsDeeply(
    \@GetDynamicFieldObjectTypes,
    [
        'Article',
        'Ticket',
    ],
    "GetGetDynamicFieldObjectTypes",
);

@GetDynamicFieldObjectTypes = $AdvancedDynamicFieldsObject->GetDynamicFieldObjectTypes(
    Screen => 'AgentCustomerInformationCenter::Backend###0100-CIC-TicketPendingReminder'    # optional
);

$Self->IsDeeply(
    \@GetDynamicFieldObjectTypes,
    [
        'Ticket',
    ],
    "GetGetDynamicFieldObjectTypes - Screen",
);

1;
