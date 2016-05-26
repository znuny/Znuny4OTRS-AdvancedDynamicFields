// --
// Core.Agent.Admin.Znuny4OTRSDynamicFieldScreen.js - provides the special module functions for the Dynamic Field Screen.
// Copyright (C) 2012-2015 Znuny GmbH, http://znuny.com/
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

        function UpdateFields(Event, UI) {

            var Target = $(UI.item).parent().attr('id');

            // if the element was removed from the AssignedFields list, rename it to DF name
            if (Target === 'AvailableFields') {
                $(UI.item).find('input').attr('name', 'AvailableFields');
            }

            // rename it to AssignedFields
            else if (Target === 'AssignedFields') {
                $(UI.item).find('input').attr('name', 'AssignedFields');
            }

            // rename it to AssignedRequiredFields
            else if (Target === 'AssignedRequiredFields') {
                $(UI.item).find('input').attr('name', 'AssignedRequiredFields');
            }
        }
        // Initialize Allocation List
        Core.UI.AllocationList.Init("#AvailableFields, #AssignedFields, #AssignedRequiredFields", ".AllocationList", UpdateFields);

        // Initialize list filter
        Core.UI.Table.InitTableFilter($('#FilterAvailableFields'), $('#AvailableFields'));
        Core.UI.Table.InitTableFilter($('#FilterAssignedFields'), $('#AssignedFields'));
        Core.UI.Table.InitTableFilter($('#FilterAssignedRequiredFields'), $('#AssignedRequiredFields'));
        Core.UI.Table.InitTableFilter($('#FilterDynamicFieldScreen'), $('#DynamicFieldScreen'));

        // TODO:
        $('#Submit').bind('click', function() {
            $('#Form').submit();
            return false;
        });
    };

    return TargetNS;
}(Core.Agent.Admin.Znuny4OTRSDynamicFieldScreen || {}));
