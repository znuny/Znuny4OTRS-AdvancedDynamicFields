# --
# Copyright (C) 2012-2017 Znuny GmbH, http://znuny.com/
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
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreSystemConfiguration => 1,
    },
);

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

# ---
    # GUI AdminDynamicFieldScreen
# ---

    # create test user and login
    my %TestUser = $SeleniumObject->AgentLogin(
        Groups => [ 'admin', 'users' ],
    );

    # navigate to Admin page
    $SeleniumObject->AgentInterface(
        Action      => 'AdminDynamicField',
        WaitForAJAX => 0,
    );

    for my $Elements (qw(DynamicFieldImportExportWidget DynamicFieldImport DynamicFieldExport )) {

        # check elements
        $Self->True(
            $SeleniumObject->find_element( "#$Elements", 'css' )->is_displayed(),
            "Element $Elements is visible",
        );
    }

    $SeleniumObject->find_element( "#DynamicFieldExport", 'css' )->click();

    for my $Elements (qw(DynamicFieldsTable DynamicFields DynamicFieldScreens Export )) {

        # check elements
        $Self->True(
            $SeleniumObject->find_element( "#$Elements", 'css' )->is_displayed(),
            "Element $Elements is visible",
        );
    }

    $SeleniumObject->find_element( "#Export", 'css' )->click();

};

# finally run the test(s) in the browser
$SeleniumObject->RunTest($SeleniumTest);

1;
