# --
# Copyright (C) 2012-2020 Znuny GmbH, http://znuny.com/
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

my $DynamicFieldNonRequiredScreensList = $AdvancedDynamicFieldsObject->DynamicFieldNonRequiredScreensListGet(
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
    'DynamicFieldNonRequiredScreensListGet ARRAY',
);

$DynamicFieldNonRequiredScreensList = $AdvancedDynamicFieldsObject->DynamicFieldNonRequiredScreensListGet(
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
    'DynamicFieldNonRequiredScreensListGet HASH',
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

1;
