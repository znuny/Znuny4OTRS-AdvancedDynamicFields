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

use Kernel::System::VariableCheck qw(:all);

use vars (qw($Self));

# create configuration backup
# get the Znuny4OTRS Selenium object
my $SeleniumObject = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

# store test function in variable so the Selenium object can handle errors/exceptions/dies etc.
my $SeleniumTest = sub {

    # initialize Znuny4OTRS Helpers and other needed objects
    my $ZnunyHelperObject  = $Kernel::OM->Get('Kernel::System::ZnunyHelper');
    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $HelperObject       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

    # Add Dynamic Field
    for my $Count ( 0 .. 3 ) {

        $ZnunyHelperObject->_DynamicFieldsCreateIfNotExists(
            {
                Name          => 'UnitTestText' . $Count,
                Label         => "UnitTestText" . $Count,
                ObjectType    => 'Ticket',
                FieldType     => 'Text',
                InternalField => 0,
                Config        => {
                    DefaultValue => '',
                    Link         => '',
                },
            },
        );

        my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
            Name => 'Test' . $Count,
        );

        my $IsResult = $Self->True(
            $DynamicField,    # test data
            "DynamicField: 'UnitTestText$Count' was created succussfully.",
        );
    }

    # GUI AdminDynamicFieldScreen

    # create test user and login
    my %TestUser = $SeleniumObject->AgentLogin(
        Groups => [ 'admin', 'users' ],
    );

    # navigate to Admin page
    $SeleniumObject->AgentInterface(
        Action      => 'Admin',
        WaitForAJAX => 0,
    );

    $SeleniumObject->ElementExists(
        Selector     => '[data-module="AdminDynamicFieldScreen"]',
        SelectorType => 'css',
    );

    # navigate to AdminDynamicFieldScreen page
    $SeleniumObject->AgentInterface(
        Action      => 'AdminDynamicFieldScreen',
        WaitForAJAX => 0,
    );

    $Self->True(
        $SeleniumObject->find_element( '#AgentTicketNote', 'css' )->is_displayed(),
        "DynamicFieldScreen 'AgentTicketNote' is visible",
    );

    $Self->True(
        $SeleniumObject->find_element( '#AgentTicketQueue', 'css' )->is_displayed(),
        "DefaultColumnsScreen 'AgentTicketQueue' is visible",
    );

    # check dynFields
    for my $Count ( 0 .. 3 ) {

        $Self->True(
            $SeleniumObject->find_element( "#UnitTestText$Count", 'css' )->is_displayed(),
            "DefaultColumnsScreen 'Test$Count' is visible",
        );
    }

    $Self->True(
        $SeleniumObject->find_element( '#AgentTicketNote', 'css' )->is_displayed(),
        "DynamicFieldScreen 'AgentTicketNote' is visible",
    );

    my %ScreenMapping = (
        AgentTicketNote  => 'DynamicField',
        AgentTicketQueue => 'DefaultColumns',
    );

    SCREEN:
    for my $Screen (qw(AgentTicketNote AgentTicketQueue)) {

        # navigate to AdminDynamicFieldScreen page
        $SeleniumObject->AgentInterface(
            Action      => 'AdminDynamicFieldScreen',
            WaitForAJAX => 0,
        );

        $SeleniumObject->find_element( "#$Screen", 'css' )->click();

        # check dynFields
        for my $Count ( 0 .. 3 ) {
            $Self->True(
                $SeleniumObject->find_element( "#UnitTestText$Count", 'css' )->is_displayed(),
                "DefaultColumnsScreen 'Test$Count' is visible",
            );
        }

        # set UnitTestText0 to DISABLED ELEMENTS
        $SeleniumObject->find_element( "#UnitTestText0 > input[type='checkbox']:nth-child(1)", 'css' )->click();
        $SeleniumObject->find_element( '#AllSelectedDisabledElements',                         'css' )->click();
        $SeleniumObject->find_element( "#UnitTestText0 > input[type='checkbox']:nth-child(1)", 'css' )->click();

        # set UnitTestText1 to ASSIGNED ELEMENTS
        $SeleniumObject->find_element( "#UnitTestText1 > input[type='checkbox']:nth-child(1)", 'css' )->click();
        $SeleniumObject->find_element( '#AllSelectedAssignedElements',                         'css' )->click();
        $SeleniumObject->find_element( "#UnitTestText1 > input[type='checkbox']:nth-child(1)", 'css' )->click();

        # set UnitTestText2 to ASSIGNED REQUIRED ELEMENTS
        $SeleniumObject->find_element( "#UnitTestText2 > input[type='checkbox']:nth-child(1)", 'css' )->click();
        $SeleniumObject->find_element( '#AllSelectedAssignedRequiredElements',                 'css' )->click();
        $SeleniumObject->find_element( "#UnitTestText2 > input[type='checkbox']:nth-child(1)", 'css' )->click();

        # submit form
        $SeleniumObject->find_element( '#Form > div.Field.SpacingTop > button', 'css' )->click();

        # wait for submit to reload page
        sleep(5);

        # use PackageSetupInit to rebuild Config
        $ZnunyHelperObject->_RebuildConfig();

        # make sure to use a new config object
        $Kernel::OM->ObjectsDiscard(
            Objects => ['Kernel::Config'],
        );

        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
        my $Config       = $ConfigObject->Get("Ticket::Frontend::$Screen");

        my $Prefix = '';
        if ( $ScreenMapping{$Screen} eq 'DefaultColumns' ) {
            $Prefix = 'DynamicField_';
        }

        # check dynFields
        for my $Count ( 0 .. 3 ) {

            # UnitTestText3 is a completely unassigned dynamic field whose status
            # must be handled as undefined
            my $ExpectedValue = $Count;
            if ( $Count == 3 ) {
                $ExpectedValue = undef;
            }

            $Self->Is(
                $Config->{ $ScreenMapping{$Screen} }->{ $Prefix . "UnitTestText" . $Count },
                $ExpectedValue,
                "Set dynamicField 'UnitTestText$Count' for Screen: '$Screen' correctly.",
            );
        }

        # create test Ticket and Articles
        my $TicketID = $HelperObject->TicketCreate();

        my $ArticleIDFirst = $HelperObject->ArticleCreate(
            TicketID => $TicketID,
        );

        my $ArticleIDSecond = $HelperObject->ArticleCreate(
            TicketID => $TicketID,
        );

        # navigate to created test ticket in AgentTicketNote page
        $SeleniumObject->AgentInterface(
            Action      => $Screen,
            TicketID    => $TicketID,
            WaitForAJAX => 0,
        );

        if ( $ScreenMapping{$Screen} eq 'DefaultColumns' ) {
            last SCREEN;
        }

        # check dynFields
        for my $Count ( 1 .. 2 ) {

            $Self->True(
                $SeleniumObject->find_element( "#LabelDynamicField_UnitTestText$Count", 'css' )->is_displayed(),
                "DynamicField 'UnitTestText$Count' is visible",
            );
        }
    }
};

# finally run the test(s) in the browser
$SeleniumObject->RunTest($SeleniumTest);

1;
