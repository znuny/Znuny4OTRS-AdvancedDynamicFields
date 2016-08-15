# --
# Copyright (C) 2012-2016 Znuny GmbH, http://znuny.com/
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
        RestoreSystemConfiguration => 1,
        RestoreDatabase            => 1,
    },
);

my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
my $ZnunyHelperObject  = $Kernel::OM->Get('Kernel::System::ZnunyHelper');
my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
my $HelperObject       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $AddCommandObject   = $Kernel::OM->Get('Kernel::System::Console::Command::Znuny4OTRS::DefaultColumnsScreen::Add');
my $RemoveCommandObject
    = $Kernel::OM->Get('Kernel::System::Console::Command::Znuny4OTRS::DefaultColumnsScreen::Remove');

# get all possible screens
my %DefaultColumnsScreens        = %{ $ConfigObject->Get('Znuny4OTRSAdvancedDynamicFields::DefaultColumnsScreens') };
my %DefaultColumnsScreensReverse = reverse %DefaultColumnsScreens;

my @DynamicFields;

# Add Dynamic Field
for my $Count ( 1 .. 3 ) {

    push @DynamicFields, "Test$Count";

    $ZnunyHelperObject->_DynamicFieldsCreateIfNotExists(
        {
            Name       => 'Test' . $Count,
            Label      => 'Label' . $Count,
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            Config     => {
                DefaultValue => '',
            },
        },
    );

    my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
        Name => 'Test' . $Count,
    );

    my $IsResult = $Self->True(
        $DynamicField,    # test data
        "DynamicField: 'Test$Count' was created succussfully.",
    );
}

#
# Test configurations
#
my @Tests = (
    {
        Name   => 'Trying to get all possible DynamicField and Screen.',
        Action => 'Add',
        Data   => {
            Values => 1,
        },
        ExpectedExitCode => 0,    # ExitCodeOk = 0  // ExitCodeError = 1
    },
    {
        Name   => 'Trying to add DynamicField Test1 to DashboardBackend###0120-TicketNew with State 1',
        Action => 'Add',
        Data   => {
            DynamicFields         => ['Test1'],
            State                 => 1,
            DefaultColumnsScreens => [
                'DashboardBackend###0120-TicketNew',
            ],
        },
        ExpectedExitCode => 0,
    },
    {
        Name =>
            'Trying to add DynamicField Test1 .. Test3 to AgentCustomerInformationCenter::Backend###0130-CIC-TicketOpen and Ticket::Frontend::AgentTicketQueue###DefaultColumns with State 2',
        Action => 'Add',
        Data   => {
            DynamicFields         => \@DynamicFields,
            State                 => 2,
            DefaultColumnsScreens => [
                'AgentCustomerInformationCenter::Backend###0130-CIC-TicketOpen',
                'Ticket::Frontend::AgentTicketQueue###DefaultColumns',
            ],
        },
        ExpectedExitCode => 0
    },
    {
        Name   => 'Trying to add DynamicField Test1 to all Screen with State 3',
        Action => 'Add',
        Data   => {
            DynamicFields => \@DynamicFields,
            State         => 3,
        },
        ExpectedExitCode => 0,
    },
    {
        Name   => 'Trying to remove DynamicField Test1 from DashboardBackend###0120-TicketNew.',
        Action => 'Remove',
        Data   => {
            DynamicFields         => ['Test1'],
            State                 => undef,
            DefaultColumnsScreens => [
                'DashboardBackend###0120-TicketNew'
            ],
        },
        ExpectedExitCode => 0,
    },
    {
        Name =>
            'Trying to remove DynamicField Test1 .. Test3 from AgentCustomerInformationCenter::Backend###0130-CIC-TicketOpen and Ticket::Frontend::AgentTicketQueue###DefaultColumns ',
        Action => 'Remove',
        Data   => {
            DynamicFields         => \@DynamicFields,
            State                 => undef,
            DefaultColumnsScreens => [
                'AgentCustomerInformationCenter::Backend###0130-CIC-TicketOpen',
                'Ticket::Frontend::AgentTicketQueue###DefaultColumns'
            ],
        },
        ExpectedExitCode => 0
    },
    {
        Name   => 'Trying to remove DynamicField Test1 from all Screen',
        Action => 'Remove',
        Data   => {
            DynamicFields => \@DynamicFields,
            State         => undef,
        },
        ExpectedExitCode => 0,
    },
);

TEST:
for my $Test (@Tests) {

    #
    # Execute command
    #

    my @CommandArgumentList;

    # bin/otrs.Console.pl Znuny4OTRS::DefaultColumnsScreen::Add
    # --dynamicfield=FieldName
    # --state 1

    # --values - get all possible values
    if ( defined $Test->{Data}->{Values} ) {
        push @CommandArgumentList, ('--values');
    }

    if ( IsArrayRefWithData( $Test->{Data}->{DynamicFields} ) ) {
        for my $DynamicField ( @{ $Test->{Data}->{DynamicFields} } ) {
            push @CommandArgumentList, ( '--dynamicfield', $DynamicField, );
        }
    }

    # --state 1
    if ( defined $Test->{Data}->{State} ) {
        push @CommandArgumentList, ( '--state', $Test->{Data}->{State}, );
    }

    # --screen=AgentTicketNote
    # --screen=AgentTicketZoom
    if ( IsArrayRefWithData( $Test->{Data}->{DefaultColumnsScreens} ) ) {
        for my $DynamicFieldScreen ( @{ $Test->{Data}->{DefaultColumnsScreens} } ) {
            push @CommandArgumentList, ( '--screen', $DynamicFieldScreen, );
        }
    }

    my $ExitCode;
    if ( $Test->{Action} eq 'Add' ) {
        $ExitCode = $AddCommandObject->Execute(@CommandArgumentList);
    }

    if ( $Test->{Action} eq 'Remove' ) {
        $ExitCode = $RemoveCommandObject->Execute(@CommandArgumentList);
    }

    $Self->Is(
        $ExitCode,
        $Test->{ExpectedExitCode},
        $Test->{Name} . ' - Exit code must match expected one.',
    );

    next TEST if $ExitCode;
    next TEST if $ExitCode != $Test->{ExpectedExitCode};

    # use PackageSetupInit to rebuild Config
    $ZnunyHelperObject->_PackageSetupInit();

    # check is everthing is set correctly
    for my $DefaultColumnsScreens ( @{ $Test->{Data}->{DefaultColumnsScreens} } ) {

        my %Config = $ZnunyHelperObject->_DefaultColumnsGet($DefaultColumnsScreens);

        use Data::Dumper;
        print STDERR 'Debug Dump - %Config = ' . Dumper( \%Config ) . "\n";

        # check for config in screen for all used dynamicfiels
        for my $DynamicField ( @{ $Test->{Data}->{DynamicFields} } ) {

            $Self->Is(
                $Config{$DefaultColumnsScreens}->{"DynamicField_$DynamicField"},
                $Test->{Data}->{State},
                $Test->{Name} . ' - SysConfig and state are correct.',
            );
        }

    }
}

1;
