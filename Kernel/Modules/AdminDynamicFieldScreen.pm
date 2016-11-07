# --
# Copyright (C) 2012-2016 Znuny GmbH, http://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminDynamicFieldScreen;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::DynamicField',
    'Kernel::System::Log',
    'Kernel::System::Package',
    'Kernel::System::SysConfig',
    'Kernel::System::Web::Request',
    'Kernel::System::ZnunyHelper',
);

use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {%Param};
    bless( $Self, $Type );

    my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
    my $PackageObject      = $Kernel::OM->Get('Kernel::System::Package');
    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

    my $DynamicFieldValid = $ConfigObject->Get('Znuny4OTRSAdvancedDynamicFields::DynamicFieldValid');

    my $DynamicFieldList = $DynamicFieldObject->DynamicFieldListGet(
        ObjectType => 'Ticket',
        ResultType => 'HASH',
        Valid      => $DynamicFieldValid,
    );

    $Self->{DynamicFields} = {};

    DYNAMICFIELD:
    for my $DynamicField ( @{$DynamicFieldList} ) {

        next DYNAMICFIELD if !IsHashRefWithData($DynamicField);

        # do not show internal fields for process management
        next DYNAMICFIELD if $DynamicField->{Name} eq 'ProcessManagementProcessID';
        next DYNAMICFIELD if $DynamicField->{Name} eq 'ProcessManagementActivityID';

        $Self->{DynamicFields}->{ $DynamicField->{Name} } = $DynamicField->{Label};
    }

    $Self->{DynamicFieldScreens}   = $ConfigObject->Get('Znuny4OTRSAdvancedDynamicFields::DynamicFieldScreens');
    $Self->{DefaultColumnsScreens} = $ConfigObject->Get('Znuny4OTRSAdvancedDynamicFields::DefaultColumnsScreens');

    my %DynamicFieldScreensAdditional
        = %{ $ConfigObject->Get('Znuny4OTRSAdvancedDynamicFields::DynamicFieldScreensAdditional') || {} };

    if (%DynamicFieldScreensAdditional) {

        ADDITIONAL:
        for my $Name ( sort keys %DynamicFieldScreensAdditional ) {

            my $IsInstalled = $PackageObject->PackageIsInstalled(
                Name => $Name,
            );

            next ADDITIONAL if !$IsInstalled;

            %{ $Self->{DynamicFieldScreens} } = (
                %{ $Self->{DynamicFieldScreens} },
                %{ $DynamicFieldScreensAdditional{$Name} },
            );
        }
    }

    my %DefaultColumnsScreensAdditional
        = %{ $ConfigObject->Get('Znuny4OTRSAdvancedDynamicFields::DefaultColumnsScreensAdditional') || {} };

    return $Self if !%DefaultColumnsScreensAdditional;

    ADDITIONAL:
    for my $Name ( sort keys %DefaultColumnsScreensAdditional ) {

        my $IsInstalled = $PackageObject->PackageIsInstalled(
            Name => $Name,
        );

        next ADDITIONAL if !$IsInstalled;

        %{ $Self->{DefaultColumnsScreens} } = (
            %{ $Self->{DefaultColumnsScreens} },
            %{ $DefaultColumnsScreensAdditional{$Name} },
        );
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get objects
    my $ConfigObject      = $Kernel::OM->Get('Kernel::Config');
    my $LogObject         = $Kernel::OM->Get('Kernel::System::Log');
    my $SysConfigObject   = $Kernel::OM->Get('Kernel::System::SysConfig');
    my $ZnunyHelperObject = $Kernel::OM->Get('Kernel::System::ZnunyHelper');
    my $LayoutObject      = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject       = $Kernel::OM->Get('Kernel::System::Web::Request');

    $Self->{Subaction} = $ParamObject->GetParam( Param => 'Subaction' ) || '';

    my %DynamicFields         = %{ $Self->{DynamicFields} };
    my %DynamicFieldScreens   = %{ $Self->{DynamicFieldScreens} };
    my %DefaultColumnsScreens = %{ $Self->{DefaultColumnsScreens} };

    # check needed stuff
    NEEDED:
    for my $Needed (qw(Element Type)) {

        $Param{$Needed} = $ParamObject->GetParam( Param => $Needed );
        next NEEDED if $Param{$Needed};

        $Self->{Subaction} = '';
    }

    # ------------------------------------------------------------ #
    # Edit
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Edit' ) {

        my %Config;

        # get config of element
        if ( $Param{Type} eq 'DynamicField' ) {
            %Config = $Self->_GetDynamicFieldConfig( DynamicField => $Param{Element} );
        }
        elsif ( $Param{Type} eq 'DynamicFieldScreen' ) {
            %Config = $Self->_GetDynamicFieldScreenConfig( ConfigItem => $Param{Element} );
        }
        elsif ( $Param{Type} eq 'DefaultColumnsScreen' ) {
            %Config = $Self->_GetDefaultColumnsScreenConfig( ConfigItem => $Param{Element} );
        }

        $Self->_ShowEdit(
            %Param,
            Data => \%Config,
        );
    }

    # ------------------------------------------------------------ #
    # ActvityDialogEditAction
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'EditAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # check required parameters
        my @AvailableElements = $ParamObject->GetArray( Param => 'AvailableElements' );

        my @DisabledElements         = $ParamObject->GetArray( Param => 'DisabledElements' );
        my @AssignedElements         = $ParamObject->GetArray( Param => 'AssignedElements' );
        my @AssignedRequiredElements = $ParamObject->GetArray( Param => 'AssignedRequiredElements' );

        # get all Elements
        my %AvailableElements        = map { $_ => undef } @AvailableElements;
        my %DisabledElements         = map { $_ => '0' } @DisabledElements;
        my %AssignedElements         = map { $_ => '1' } @AssignedElements;
        my %AssignedRequiredElements = map { $_ => '2' } @AssignedRequiredElements;

        # build config hash
        my %Config = (
            %AvailableElements,
            %DisabledElements,
            %AssignedElements,
            %AssignedRequiredElements,
        );

        my %ScreenConfig;
        $ScreenConfig{ $Param{Element} } ||= {};

        # get config of element
        if ( $Param{Type} eq 'DynamicField' ) {

            $Self->_SetDynamicFields(
                DynamicField => $Param{Element},
                Config       => \%Config,
            );
        }
        elsif ( $Param{Type} eq 'DynamicFieldScreen' ) {

            for my $DynamicField ( sort keys %Config ) {
                $ScreenConfig{ $Param{Element} }->{$DynamicField} = $Config{$DynamicField};
            }

            $ZnunyHelperObject->_DynamicFieldsScreenEnable(%ScreenConfig);
        }
        elsif ( $Param{Type} eq 'DefaultColumnsScreen' ) {

            for my $DynamicField ( sort keys %Config ) {
                $ScreenConfig{ $Param{Element} }->{ 'DynamicField_' . $DynamicField } = $Config{$DynamicField};
            }

            $ZnunyHelperObject->_DefaultColumnsEnable(%ScreenConfig);
        }

        $Param{Element} = $LayoutObject->LinkEncode( $Param{Element} );

        # redirect to the same view
        return $LayoutObject->Redirect(
            OP => "Action=$Self->{Action};Subaction=Edit;Type=$Param{Type};Element=$Param{Element};"
        );
    }

    # ------------------------------------------------------------ #
    # Reset
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Reset' ) {

        if (
            $Param{Type} ne 'DynamicFieldScreen'
            && $Param{Type} ne 'DefaultColumnsScreen'
            )
        {
            return $Self->_ShowOverview();
        }

        $SysConfigObject->ConfigItemReset(
            Name => $Param{Element},
        );

        $Param{Element} = $LayoutObject->LinkEncode( $Param{Element} );

        # redirect to the same view
        return $LayoutObject->Redirect(
            OP => "Action=$Self->{Action};Subaction=Edit;Type=$Param{Type};Element=$Param{Element}"
        );
    }

    # ------------------------------------------------------------ #
    # Error
    # ------------------------------------------------------------ #
    else {
        return $Self->_ShowOverview();
    }
}

sub _ShowOverview {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my %DynamicFields         = %{ $Self->{DynamicFields} };
    my %DynamicFieldScreens   = %{ $Self->{DynamicFieldScreens} };
    my %DefaultColumnsScreens = %{ $Self->{DefaultColumnsScreens} };

    # show output
    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionOverview' );
    $LayoutObject->Block( Name => 'Overview' );

    for my $DynamicFieldScreen ( sort keys %DynamicFieldScreens ) {

        # output row for DynamicFieldScreen
        $LayoutObject->Block(
            Name => 'DynamicFieldScreenOverviewRow',
            Data => {
                DynamicFieldScreen => $DynamicFieldScreen,
                Name               => $DynamicFieldScreens{$DynamicFieldScreen},
                }
        );
    }

    for my $DefaultColumnsScreen ( sort keys %DefaultColumnsScreens ) {

        # output row for DefaultColumns
        $LayoutObject->Block(
            Name => 'DefaultColumnsScreenOverviewRow',
            Data => {
                DefaultColumnsScreen => $DefaultColumnsScreen,
                Name                 => $DefaultColumnsScreens{$DefaultColumnsScreen},
                }
        );
    }

    if ( !%DynamicFields ) {
        $LayoutObject->Block(
            Name => 'NoDataFoundMsg',
        );
    }
    else {

        for my $DynamicField ( sort keys %DynamicFields ) {

            # output row for DynamicField
            $LayoutObject->Block(
                Name => 'DynamicFieldOverviewRow',
                Data => {
                    DynamicField => $DynamicField,
                    Name         => $DynamicFields{$DynamicField},
                    }
            );
        }
    }

    # output header
    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();
    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminDynamicFieldScreen',
    );

    $Output .= $LayoutObject->Footer();

    return $Output;
}

sub _ShowEdit {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $NoAssignedRequiredFieldRow;

    my %Data                  = %{ $Param{Data} || {} };
    my %DynamicFields         = %{ $Self->{DynamicFields} };
    my %DynamicFieldScreens   = %{ $Self->{DynamicFieldScreens} };
    my %DefaultColumnsScreens = %{ $Self->{DefaultColumnsScreens} };

    my %Screens = (
        %{ $Self->{DynamicFieldScreens} },
        %{ $Self->{DefaultColumnsScreens} },
    );

    # localize available fields, dynamic fields screens and default column screens
    my %AvailableElements = %DynamicFields;
    my %OtherElements     = %DefaultColumnsScreens;

    # set default size for template
    $Param{Size}   = 'Size1of4';
    $Param{Header} = 'Dynamic Fields for this Screen';

    if ( $Param{Type} eq 'DynamicField' ) {

        %AvailableElements = %Screens;
        %OtherElements     = %DynamicFields;

        $Param{Header}      = 'Screens for this Dynamic Field';
        $Param{HiddenReset} = 'Hidden';
    }
    elsif ( $Param{Type} eq 'DynamicFieldScreen' ) {

        # remove AssignedRequiredFieldRow off template if screen is AgentTicketZoom oder CustomTicketZoom
        if ( $Param{Element} =~ m{Zoom}msxi ) {

            # AssignedRequired is not needed for Zoom-Views
            $NoAssignedRequiredFieldRow = 1;
            $Param{Size}                = 'Size1of2';
            $Param{HiddenRequired}      = 'Hidden';
        }
        %OtherElements = %DynamicFieldScreens;
    }

    # show button
    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionOverview' );
    $LayoutObject->Block( Name => 'ActionOverviewList' );

    # shows sidebar selection
    for my $Element ( sort keys %OtherElements ) {

        # output row
        $LayoutObject->Block(
            Name => 'ActionOverviewRow',
            Data => {
                Element    => $OtherElements{$Element},
                ElementKey => $Element,
                Type       => $Param{Type},
                }
        );
    }

    # output input page
    $LayoutObject->Block(
        Name => 'Edit',
        Data => {
            %Param,
            %Data,
        },
    );

    # get used fields by the dynamic field group
    if (%Data) {

        ELEMENT:
        for my $Element ( sort keys %Data ) {

            next ELEMENT if !defined $Data{$Element};
            next ELEMENT if !$AvailableElements{$Element};

            # remove all spaces # or :
            my $ID = $Element;
            $ID =~ s/\s//g;
            $ID =~ s/\#*//g;
            $ID =~ s/\:\://g;

            my $BlockName = undef;

            if ( $Data{$Element} eq 0 ) {
                $BlockName = 'DisabledFieldRow';
            }
            elsif ( $Data{$Element} eq 1 ) {
                $BlockName = 'AssignedFieldRow';
            }
            elsif ( $Data{$Element} eq 2 && !$NoAssignedRequiredFieldRow ) {
                $BlockName = 'AssignedRequiredFieldRow';
            }

            next ELEMENT if !$BlockName;

            $LayoutObject->Block(
                Name => $BlockName,
                Data => {
                    Element => $Element,
                    Label   => $AvailableElements{$Element},
                    ID      => $ID,
                },
            );

            # remove used fields from available list
            delete $AvailableElements{$Element};
        }
    }

    # display available fields
    for my $Element (
        sort { $AvailableElements{$a} cmp $AvailableElements{$b} }
        keys %AvailableElements
        )
    {
        # remove all spaces # or :
        my $ID = $Element;
        $ID =~ s/\s//g;
        $ID =~ s/\#*//g;
        $ID =~ s/\:\://g;

        $LayoutObject->Block(
            Name => 'AvailableFieldRow',
            Data => {
                Element => $Element,
                Label   => $AvailableElements{$Element},
                ID      => $ID,
            },
        );
    }

    # output header
    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();
    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminDynamicFieldScreen',
    );

    $Output .= $LayoutObject->Footer();

    return $Output;
}

sub _GetDynamicFieldConfig {
    my ( $Self, %Param ) = @_;

    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    # check needed stuff
    NEEDED:
    for my $Needed (qw(DynamicField)) {

        next NEEDED if defined $Param{$Needed};

        $LogObject->Log(
            Priority => 'error',
            Message  => "Parameter '$Needed' is needed!",
        );
        return;
    }

    # get all possible screens
    my %DynamicFieldScreens   = %{ $Self->{DynamicFieldScreens} };
    my %DefaultColumnsScreens = %{ $Self->{DefaultColumnsScreens} };

    my %Config;

    DYNAMICFIELDSCREEN:
    for my $DynamicFieldScreen ( sort keys %DynamicFieldScreens ) {

        my %DynamicFieldScreenConfig = $Self->_GetDynamicFieldScreenConfig(
            ConfigItem => $DynamicFieldScreen,
        );

        next DYNAMICFIELDSCREEN if !IsStringWithData( $DynamicFieldScreenConfig{ $Param{DynamicField} } );
        $Config{$DynamicFieldScreen} = $DynamicFieldScreenConfig{ $Param{DynamicField} };
    }

    DEFAULTCOLUMNSCREEN:
    for my $DefaultColumnsScreen ( sort keys %DefaultColumnsScreens ) {

        my %DefaultColumnsScreenConfig = $Self->_GetDefaultColumnsScreenConfig(
            ConfigItem => $DefaultColumnsScreen,
        );

        next DEFAULTCOLUMNSCREEN if !IsStringWithData( $DefaultColumnsScreenConfig{ $Param{DynamicField} } );
        $Config{$DefaultColumnsScreen} = $DefaultColumnsScreenConfig{ $Param{DynamicField} };
    }

    return %Config;
}

sub _GetDynamicFieldScreenConfig {
    my ( $Self, %Param ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LogObject    = $Kernel::OM->Get('Kernel::System::Log');

    # check needed stuff
    NEEDED:
    for my $Needed (qw(ConfigItem)) {

        next NEEDED if defined $Param{$Needed};

        $LogObject->Log(
            Priority => 'error',
            Message  => "Parameter '$Needed' is needed!",
        );
        return;
    }

    my @Keys = split '###', $Param{ConfigItem};

    my $Config = $ConfigObject->Get( $Keys[0] );
    INDEX:
    for my $Index ( 1 ... $#Keys ) {
        last INDEX if !IsHashRefWithData($Config);
        $Config = $Config->{ $Keys[$Index] };
    }
    return {} if !$Config;
    return {} if ref $Config ne 'HASH';

    return %{$Config};
}

sub _GetDefaultColumnsScreenConfig {
    my ( $Self, %Param ) = @_;

    my $ConfigObject      = $Kernel::OM->Get('Kernel::Config');
    my $LogObject         = $Kernel::OM->Get('Kernel::System::Log');
    my $ZnunyHelperObject = $Kernel::OM->Get('Kernel::System::ZnunyHelper');

    # check needed stuff
    NEEDED:
    for my $Needed (qw(ConfigItem)) {

        next NEEDED if defined $Param{$Needed};

        $LogObject->Log(
            Priority => 'error',
            Message  => "Parameter '$Needed' is needed!",
        );
        return;
    }

    my @Configs      = ( $Param{ConfigItem} );
    my %ScreenConfig = $ZnunyHelperObject->_DefaultColumnsGet(@Configs);

    my %Config;
    my %CurrentScreenConfig = %{ $ScreenConfig{ $Param{ConfigItem} } };

    ITEM:
    for my $Item ( sort keys %CurrentScreenConfig ) {

        next ITEM if $Item !~ m{DynamicField_}xms;

        my $Value = $CurrentScreenConfig{$Item};
        $Item =~ s/DynamicField_//;
        $Config{$Item} = $Value;
    }

    return %Config;
}

sub _SetDynamicFields {
    my ( $Self, %Param ) = @_;

    my $ZnunyHelperObject = $Kernel::OM->Get('Kernel::System::ZnunyHelper');
    my $LogObject         = $Kernel::OM->Get('Kernel::System::Log');

    # check needed stuff
    NEEDED:
    for my $Needed (qw(DynamicField Config)) {

        next NEEDED if defined $Param{$Needed};

        $LogObject->Log(
            Priority => 'error',
            Message  => "Parameter '$Needed' is needed!",
        );
        return;
    }

    my %Config                = %{ $Param{Config} };
    my %DynamicFieldScreens   = %{ $Self->{DynamicFieldScreens} };
    my %DefaultColumnsScreens = %{ $Self->{DefaultColumnsScreens} };

    my %ScreenConfig;

    DYNAMICFIELDSCREEN:
    for my $DynamicFieldScreen ( sort keys %DynamicFieldScreens ) {
        $ScreenConfig{$DynamicFieldScreen} = {
            $Param{DynamicField} => $Config{$DynamicFieldScreen},
        };
    }

    my $Success = $ZnunyHelperObject->_DynamicFieldsScreenEnable(%ScreenConfig);

    undef %ScreenConfig;

    DEFAULTCOLUMNSCREEN:
    for my $DefaultColumnsScreen ( sort keys %DefaultColumnsScreens ) {
        $ScreenConfig{$DefaultColumnsScreen} = {
            "DynamicField_$Param{DynamicField}" => $Config{$DefaultColumnsScreen},
        };
    }

    return $ZnunyHelperObject->_DefaultColumnsEnable(%ScreenConfig);
}

1;
