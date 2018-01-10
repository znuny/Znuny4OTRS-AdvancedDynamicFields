# --
# Copyright (C) 2012-2018 Znuny GmbH, http://znuny.com/
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
        ObjectType => [ 'Ticket', 'Article' ],    #'Ticket',
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

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
