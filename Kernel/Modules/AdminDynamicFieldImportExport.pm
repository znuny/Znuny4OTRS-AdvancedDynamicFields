# --
# Copyright (C) 2012-2017 Znuny GmbH, http://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminDynamicFieldImportExport;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::DynamicField',
    'Kernel::System::Log',
    'Kernel::System::Time',
    'Kernel::System::Web::Request',
    'Kernel::System::YAML',
    'Kernel::System::ZnunyHelper',
);

use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get objects
    my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $LogObject          = $Kernel::OM->Get('Kernel::System::Log');
    my $LayoutObject       = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject        = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $TimeObject         = $Kernel::OM->Get('Kernel::System::Time');
    my $YAMLObject         = $Kernel::OM->Get('Kernel::System::YAML');
    my $ZnunyHelperObject  = $Kernel::OM->Get('Kernel::System::ZnunyHelper');

    $Self->{Subaction} = $ParamObject->GetParam( Param => 'Subaction' ) || '';

    # ------------------------------------------------------------ #
    # ProcessImport
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Import' ) {

        my $Success;

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my %UploadStuff = $ParamObject->GetUploadAll(
            Param => 'FileUpload',
        );

        my $YAMLString = $UploadStuff{Content};

        my $OverwriteExistingEntities = $ParamObject->GetParam( Param => 'OverwriteExistingEntities' );

        my $PerlStructure = $YAMLObject->Load(
            Data => $YAMLString,
        );

        my $FieldTypeConfig = $ConfigObject->Get('DynamicFields::Driver');
        if ( IsHashRefWithData( $PerlStructure->{DynamicFields} ) ) {

            my @DynamicFields;
            DYNAMICFIELD:
            for my $DynamicField ( %{ $PerlStructure->{DynamicFields} } ) {
                next DYNAMICFIELD if !IsHashRefWithData( $PerlStructure->{DynamicFields}->{$DynamicField} );

                my $FieldType = $PerlStructure->{DynamicFields}->{$DynamicField}->{FieldType};

                if ( !IsHashRefWithData( $FieldTypeConfig->{$FieldType} ) ) {

                    $LogObject->Log(
                        'Priority' => 'error',
                        'Message' =>
                            "Could not import dynamic field '$PerlStructure->{DynamicFields}->{$DynamicField}->{Name}' - Dynamic field backend for FieldType '$PerlStructure->{DynamicFields}->{$DynamicField}->{FieldType}' does not exists!",
                    );
                    next DYNAMICFIELD;
                }

                push @DynamicFields, $PerlStructure->{DynamicFields}->{$DynamicField};
            }

            if ($OverwriteExistingEntities) {
                $Success = $ZnunyHelperObject->_DynamicFieldsCreate(@DynamicFields);
            }
            else {

                $Success = $ZnunyHelperObject->_DynamicFieldsCreateIfNotExists(@DynamicFields);
            }
        }

        # redirect to ActivityDialog
        my $HTML = $LayoutObject->Redirect(
            OP => "Action=AdminDynamicField"
        );

        return $HTML;
    }

    # ------------------------------------------------------------ #
    # ProcessExport
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Export' ) {

        #         # check for DynamicFieldID
        #         my $DynamicFieldID = $ParamObject->GetParam( Param => 'ID' ) || '';

        my $DynamicFieldList = $DynamicFieldObject->DynamicFieldListGet();

        my %Data;
        my %DynamicFieldData;

        for my $DynamicField ( @{$DynamicFieldList} ) {

            for my $Attribute (qw(ID CreateTime ChangeTime FieldOrder)) {
                delete $DynamicField->{$Attribute};
            }
            $DynamicFieldData{ $DynamicField->{Name} } = $DynamicField;
        }

        $Data{DynamicFields} = \%DynamicFieldData;

        # convert the dynamicfielddata hash to string
        my $DynamicFieldDataYAML = $YAMLObject->Dump( Data => \%Data );

        my $TimeStamp = $TimeObject->CurrentTimestamp();

        # send the result to the browser
        return $LayoutObject->Attachment(
            ContentType => 'text/html; charset=' . $LayoutObject->{Charset},
            Content     => $DynamicFieldDataYAML,
            Type        => 'attachment',
            Filename    => "Export_DynamicFields_$TimeStamp.yml",
            NoCache     => 1,
        );
    }

    # ------------------------------------------------------------ #
    # Error / no Subaction
    # ------------------------------------------------------------ #
    else {

        # redirect to ActivityDialog
        my $HTML = $LayoutObject->Redirect(
            OP => "Action=AdminDynamicField"
        );

        return $HTML;
    }
}

1;
