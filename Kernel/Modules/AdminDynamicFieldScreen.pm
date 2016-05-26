# --
# Copyright (C) 2012-2015 Znuny GmbH, http://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminDynamicFieldScreen;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Output::HTML::Layout',
    'Kernel::System::DynamicField',
    'Kernel::System::Web::Request',
);


use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {%Param};
    bless( $Self, $Type );

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');

    my $DynamicFieldList = $DynamicFieldObject->DynamicFieldListGet(
        ObjectType => 'Ticket',
        ResultType => 'HASH',
    );

    DYNAMICFIELD:
    for my $DynamicField ( @{$DynamicFieldList} ) {

        next DYNAMICFIELD if !IsHashRefWithData($DynamicField);

        # do not show internal fields for process management
        next DYNAMICFIELD if $DynamicField->{Name} eq 'ProcessManagementProcessID';
        next DYNAMICFIELD if $DynamicField->{Name} eq 'ProcessManagementActivityID';

        $Self->{AvailableFields}->{ $DynamicField->{Name} } = $DynamicField->{Label};
    }

    $Self->{DynamicFieldScreens} = $ConfigObject->Get('Znuny4OTRSAdvancedDynamicFields::DynamicFieldScreens');
    $Self->{DefaultColumns}      = $ConfigObject->Get('Znuny4OTRSAdvancedDynamicFields::DefaultColumns');

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;


    # get objects
    my $LayoutObject      = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject       = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $ConfigObject      = $Kernel::OM->Get('Kernel::Config');
    my $ZnunyHelperObject = $Kernel::OM->Get('Kernel::System::ZnunyHelper');
    my $SysConfigObject   = $Kernel::OM->Get('Kernel::System::SysConfig');

    $Self->{Subaction}      = $ParamObject->GetParam( Param => 'Subaction' ) || '';
    my %DynamicFieldScreens = %{ $Self->{DynamicFieldScreens} };

    # ------------------------------------------------------------ #
    # Edit
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Edit' ) {

        $Param{DynamicFieldScreen} = $ParamObject->GetParam( Param => 'DynamicFieldScreen' );

        # check for DynamicFieldScreen
        if ( !$Param{DynamicFieldScreen} ) {
            return $LayoutObject->ErrorScreen(
                Message => "Need parameter 'DynamicFieldScreen'!",
            );
        }

        my $ScreenConfigs      = $ConfigObject->Get('Ticket::Frontend::' . $Param{DynamicFieldScreen} );
        my $DynamicFieldConfig = $ScreenConfigs->{DynamicField};

        return $Self->_ShowEdit(
            %Param,
            Data   => $DynamicFieldConfig,
        );
    }

    # ------------------------------------------------------------ #
    # ActvityDialogEditAction
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'EditAction' ) {

        # # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $DynamicFieldScreen = $ParamObject->GetParam( Param => 'DynamicFieldScreen' );

        # check for DynamicFieldScreen
        if ( !$DynamicFieldScreen ) {
            return $LayoutObject->ErrorScreen(
                Message => "Need parameter 'DynamicFieldScreen'!",
            );
        }

        # check required parameters
        my @AvailableFields        = $ParamObject->GetArray( Param => 'AvailableFields' );
        my @AssignedFields         = $ParamObject->GetArray( Param => 'AssignedFields' );
        my @AssignedRequiredFields = $ParamObject->GetArray( Param => 'AssignedRequiredFields' );

        # get all fields
        my %AvailableFields         = map { $_ => '0' } @AvailableFields;
        my %AssignedFields          = map { $_ => '1' } @AssignedFields;
        my %AssignedRequiredFields  = map { $_ => '2' } @AssignedRequiredFields;

        # build config hash
        my %DynamicFieldConfig = (
            %AvailableFields,
            %AssignedFields,
            %AssignedRequiredFields,
        );

        my %Screens;
        $Screens{$DynamicFieldScreen} ||= {};

        DYNAMICFIELD:
        for my $DynamicField (sort keys %DynamicFieldConfig) {
            $Screens{$DynamicFieldScreen}->{$DynamicField} = $DynamicFieldConfig{$DynamicField};
        }

        # update all dynamic fields
        my $Success = $ZnunyHelperObject->_DynamicFieldsScreenEnable(%Screens);

        # redirect to overview
        return $LayoutObject->Redirect( OP => "Action=$Self->{Action};Subaction=Edit;DynamicFieldScreen=$DynamicFieldScreen" );
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

    my %DynamicFieldScreens = %{ $Self->{DynamicFieldScreens} };

    # show button
    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionOverview' );

    # output overview result
    $LayoutObject->Block(
        Name => 'Overview',
    );

    for my $DynamicFieldScreen (sort keys %DynamicFieldScreens ) {

        # output row
        $LayoutObject->Block(
            Name => 'OverviewRow',
            Data => {
                DynamicFieldScreen => $DynamicFieldScreen,
            }
        );
    }

    if ( !IsHashRefWithData(\%DynamicFieldScreens) ) {
        $LayoutObject->Block(
            Name => 'NoDataFoundMsg',
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

sub _ShowEdit {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # localize available fields and dynamic fields screens
    my %AvailableFields     = %{ $Self->{AvailableFields} };
    my %DynamicFieldScreens = %{ $Self->{DynamicFieldScreens} };

    # get dynamic field screen information
    my $Data               = $Param{Data} || {};
    my $DynamicFieldScreen = $Param{DynamicFieldScreen};

    # show button
    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionOverview' );

    # output input page
    $LayoutObject->Block(
        Name => 'Edit',
        Data => {
            SysConfigSubGroup => $DynamicFieldScreens{$DynamicFieldScreen},
            %Param,
            %{$Data},
        },
    );

    # get used fields by the dynamic field group
    if ( IsHashRefWithData( \%{$Data} ) ) {

        FIELD:
        for my $Field ( sort keys %{ $Data } ) {


            next FIELD if !$AvailableFields{$Field};
            next FIELD if $Data->{$Field} ne 1;

            $LayoutObject->Block(
                Name => 'AssignedFieldRow',
                Data => {
                    Field => $Field,
                    Label => $AvailableFields{$Field},
                },
            );

            # remove used fields from available list
            delete $AvailableFields{$Field};
        }
    }
    # get used fields by the dynamic field group
    if ( IsHashRefWithData( \%{$Data} ) ) {

        FIELD:
        for my $Field ( sort keys %{ $Data } ) {

            next FIELD if !$AvailableFields{$Field};
            next FIELD if $Data->{$Field} ne 2;

            $LayoutObject->Block(
                Name => 'AssignedRequiredFieldRow',
                Data => {
                    Field => $Field,
                    Label => $AvailableFields{$Field},
                },
            );

            # remove used fields from available list
            delete $AvailableFields{$Field};
        }
    }


    # display available fields
    for my $Field (
        sort { $AvailableFields{$a} cmp $AvailableFields{$b} }
        keys %AvailableFields
        )
    {
        $LayoutObject->Block(
            Name => 'AvailableFieldRow',
            Data => {
                Field => $Field,
                Label => $AvailableFields{$Field},
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

1;
