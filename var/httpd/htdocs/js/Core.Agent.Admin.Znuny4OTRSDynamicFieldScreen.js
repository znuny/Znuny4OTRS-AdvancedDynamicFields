// --
// Copyright (C) 2012-2016 Znuny GmbH, http://znuny.com/
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
 * @exports TargetNS as Core.Agent.Admin.Znuny4OTRSDynamicFieldScreen
 * @description
 *      This namespace contains the special module functions for the Dynamic Field Screen module.
 */
Core.Agent.Admin.Znuny4OTRSDynamicFieldScreen = (function (TargetNS) {

    TargetNS.Init = function () {

        function UpdateFields(UI) {

            var Target = $(UI.item).parent().attr('id');

            // if the element was removed from the AssignedElement list, rename it to DF name
            if (Target === 'AvailableElements') {
                $(UI.item).find('input').attr('name', 'AvailableElements');
            }

            // rename it to AssignedElements
            else if (Target === 'AssignedElements') {
                $(UI.item).find('input').attr('name', 'AssignedElements');
            }

            // rename it to AssignedRequiredElements
            else if (Target === 'AssignedRequiredElements') {
                $(UI.item).find('input').attr('name', 'AssignedRequiredElements');
            }
        }
        // Initialize Allocation List
        Core.UI.AllocationList.Init("#AvailableElements, #AssignedElements, #AssignedRequiredElements", ".AllocationList", UpdateFields);

        // Initialize list filter
        Core.UI.Table.InitTableFilter($('#FilterAvailableElements'), $('#AvailableElements'));
        Core.UI.Table.InitTableFilter($('#FilterAssignedElements'), $('#AssignedElements'));
        Core.UI.Table.InitTableFilter($('#FilterAssignedRequiredElements'), $('#AssignedRequiredElements'));
        Core.UI.Table.InitTableFilter($('#FilterElements'), $('#Elements'));

        // TODO:
        $('#Submit').bind('click', function() {
            $('#Form').submit();
            return false;
        });
    };

    return TargetNS;
}(Core.Agent.Admin.Znuny4OTRSDynamicFieldScreen || {}));
