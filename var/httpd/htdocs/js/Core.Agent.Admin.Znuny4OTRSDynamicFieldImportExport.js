// --
// Copyright (C) 2012-2017 Znuny GmbH, http://znuny.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core         = Core             || {};
Core.Agent       = Core.Agent       || {};
Core.Agent.Admin = Core.Agent.Admin || {};

/**
 * @namespace
 * @exports TargetNS as Core.Agent.Admin.Znuny4OTRSDynamicFieldImportExport
 * @description
 *      This namespace contains the special module functions for the Dynamic Field Screen module.
 */
Core.Agent.Admin.Znuny4OTRSDynamicFieldImportExport = (function (TargetNS) {

    TargetNS.Init = function () {

        $.each(['DynamicFields', 'DynamicFieldScreens'], function (Index, Elements) {

            $('input[type="checkbox"][name="SelectAll'+Elements+'"]').bind('click', function () {

                Core.Form.SelectAllCheckboxes($(this), $('[name="'+Elements+'"]'));

            });
        });
    };

    return TargetNS;

}(Core.Agent.Admin.Znuny4OTRSDynamicFieldImportExport || {}));
