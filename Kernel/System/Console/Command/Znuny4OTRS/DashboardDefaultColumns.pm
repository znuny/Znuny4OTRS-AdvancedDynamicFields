# --
# Kernel/System/Console/Command/Znuny4OTRS/DashboardDefaultColumns.pm - Updates the 'DefaultColumns' config of all Dashboard configs accordingly
# Copyright (C) 2012-2016 Znuny GmbH, http://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Znuny4OTRS::DashboardDefaultColumns;

use strict;
use warnings;

use base qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description("Updates the 'DefaultColumns' config of all Dashboard configs accordingly");

    $Self->AddArgument(
        Name        => 'attribute',
        Description => 'Name of the attribute that should get added or updated.',
        Required    => 1,
        HasValue    => 1,
        ValueRegex => qr/.*/smx,
    );

    $Self->AddArgument(
        Name        => 'state',
        Description => 'The attribute state Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.',
        Required    => 1,
        HasValue    => 1,
        ValueRegex => qr/.*/smx,
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    $Self->Print("<yellow>Updating the 'DefaultColumns' config of all Dashboard SysConfigs...</yellow>");

    my $AttributeName  = $Self->GetArgument('attribute');
    my $AttributeState = $Self->GetArgument('state');

    my $DashboardBackendConfigs = $ConfigObject->Get('DashboardBackend');

    BACKEND:
    for my $BackendName ( sort keys %{ $DashboardBackendConfigs } ) {

        my $BackendConfig = $DashboardBackendConfigs->{ $BackendName };

        next BACKEND if ref $BackendConfig->{DefaultColumns} ne 'HASH';

        $BackendConfig->{DefaultColumns}->{ $AttributeName } = $AttributeState;

        $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemUpdate(
            Key   => 'DashboardBackend###'. $BackendName,
            Value => $BackendConfig,
            Valid => 1,
        );
    }

    $Self->Print("<green>Done.</green>\n");

    return $Self->ExitCodeOk();
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
