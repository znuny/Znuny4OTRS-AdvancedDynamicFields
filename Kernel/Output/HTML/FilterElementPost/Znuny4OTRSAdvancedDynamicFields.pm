# --
# Copyright (C) 2012-2017 Znuny GmbH, http://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::FilterElementPost::Znuny4OTRSAdvancedDynamicFields;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Language',
    'Kernel::Output::HTML::Layout',
);

use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    return if !defined $Param{Data};

    my $LanguageObject = $Kernel::OM->Get('Kernel::Language');
    my $LayoutObject   = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $ImportExportHTML = "<div class='WidgetSimple'>
            <div class='Header'>
                <h2>" . $LanguageObject->Translate('Import / Export') . "</h2>
            </div>
            <div class='Content'>
                <p class='FieldExplanation'>
                    "
        . $LanguageObject->Translate(
        'Here you can upload a configuration file to import dynamic fields to your system. The file needs to be in .yml format as exported by dynamic field management module.'
        )
        . "
                </p>
                <ul class='ActionList SpacingTop'>
                    <li>
                        <form action='$LayoutObject->{CGIHandle}' method='post' enctype='multipart/form-data' class='Validate PreventMultipleSubmits'>
                            <input type='hidden' name='ChallengeToken' value='$LayoutObject->{UserChallengeToken}'>
                            <input type='hidden' name='Action' value='AdminDynamicFieldImportExport'/>
                            <input type='hidden' name='Subaction' value='Import'/>
                            <input name='FileUpload' id='FileUpload' type='file' size='18' class='Fixed W100pc Validate_Required [% Data.FileUploadInvalid | html %]'/>
                            <div id='FileUploadError' class='TooltipErrorMessage'><p>"
        . $LanguageObject->Translate('This field is required.')
        . "</p></div>
                            <div id='FileUploadServerError' class='TooltipErrorMessage'><p>"
        . $LanguageObject->Translate('This field is required.')
        . "</p></div>
                            <fieldset class='SpacingTop'>
                                <input type='checkbox' id='OverwriteExistingEntitiesExample' name='OverwriteExistingEntities' value='1'/>
                                <label for='OverwriteExistingEntitiesExample'>"
        . $LanguageObject->Translate('Overwrite existing entities')
        . "</label>
                            </fieldset>
                            <button class='CallForAction Fullsize Center SpacingTop' type='submit'>
                                <span><i class='fa fa-upload'></i>"
        . $LanguageObject->Translate('DynamicFields Import')
        . "</span>
                            </button>
                        </form>

                    </li>
                    <li>
                        <a href='$LayoutObject->{Baselink}Action=AdminDynamicFieldImportExport;Subaction=Export' class='CallForAction Fullsize Center'><span><i class='fa fa-download'></i>"
        . $LanguageObject->Translate('DynamicFields Export')
        . "</span></a>
                    </li>
                </ul>
            </div>
        </div>";

    my $ScreensHTML = "<div class='WidgetSimple'>
            <div class='Header'>
                <h2>" . $LanguageObject->Translate('Dynamic Fields Screens') . "</h2>
            </div>
            <div class='Content'>
                <p class='FieldExplanation'>
                    "
        . $LanguageObject->Translate('Here you can manage the dynamic fields in the respective screens.') . "
                </p>
                <ul class='ActionList SpacingTop'>
                    <li>
                        <a href='$LayoutObject->{Baselink}Action=AdminDynamicFieldScreen' class='CallForAction Fullsize Center'><span><i class='fa fa-plus-square'></i>"
        . $LanguageObject->Translate('Dynamic Fields Screens')
        . "</span></a>
                    </li>
                </ul>
            </div>
        </div>";

    # manipulate HTML content
    ${ $Param{Data} } =~ s{
        (\s*<div [^>]+ WidgetSimple [^>]+ >)$
    }{$ImportExportHTML$ScreensHTML$1}msix;

    return 1;
}

1;
