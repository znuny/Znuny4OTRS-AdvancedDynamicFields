// --
// Copyright (C) 2012-2022 Znuny GmbH, http://znuny.com/
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

        // Initialize Allocation List
        Core.UI.AllocationList.Init("#AvailableElements, #DisabledElements, #AssignedElements, #AssignedRequiredElements", ".AllocationList", UpdateFields);

        // Initialize list filter
        Core.UI.Table.InitTableFilter($('#FilterElements'), $('#Elements'));
        Core.UI.Table.InitTableFilter($('#FilterAvailableElements'), $('#AvailableElements'));
        Core.UI.Table.InitTableFilter($('#FilterDisabledElements'), $('#DisabledElements'));
        Core.UI.Table.InitTableFilter($('#FilterAssignedElements'), $('#AssignedElements'));
        Core.UI.Table.InitTableFilter($('#FilterAssignedRequiredElements'), $('#AssignedRequiredElements'));

        $.each(['SelectAllAvailableElements', 'SelectAllDisabledElements',  'SelectAllAssignedElements', 'SelectAllAssignedRequiredElements'], function (Index, Elements) {

            $('input[type="checkbox"][name="'+Elements+'"]').bind('click', function () {
                Core.Form.SelectAllCheckboxes($(this), $('#' + Elements));
            });
        });

        // register all bindings
        $.each(['AvailableElements', 'DisabledElements', 'AssignedElements', 'AssignedRequiredElements'], function (Index, ParameterName) {

            var Element;
            $('#AllSelected'+ ParameterName).bind('click', function () {

                // move all li to another ul list.
                $("input:checkbox:checked").each(function(){
                    Element = $(this).val();

                    if(Element){
                        $('li#'+Element).appendTo('#'+ ParameterName);
                        $('li#'+Element).find('input[type="hidden"]').attr('name', ParameterName);
                        $('#'+Element).find('input[type="checkbox"]').attr('name', 'SelectAll'+ ParameterName);

                        // Regardless of filters: Show the elements that have been moved
                        // so the user knows what is happening.
                        $('li#' + Element).show();
                    }
                });

                // removed all checked
                $("input:checkbox").prop('checked', $(this).prop("checked")).removeAttr('checked');
            });
        });

        $('#Submit').bind('click', function() {
            $('#Form').submit();
            return false;
        });
    };

    function UpdateFields(Event, UI) {

        var Target = $(UI.item).parent().attr('id');

        // if the element was removed from the AssignedElement list, rename it to DF name
        if (Target === 'AvailableElements') {
            $(UI.item).find('input[type="hidden"]').attr('name', 'AvailableElements');
            $(UI.item).find('input[type="checkbox"]').attr('name', 'SelectAllAvailableElements');
            $(UI.item).find('input[type="checkbox"]').removeAttr('checked');
        }

        // rename it to DisabledElements
        else if (Target === 'DisabledElements') {
            $(UI.item).find('input[type="hidden"]').attr('name', 'DisabledElements');
            $(UI.item).find('input[type="checkbox"]').attr('name', 'SelectAllDisabledElements');
            $(UI.item).find('input[type="checkbox"]').removeAttr('checked');
        }

        // rename it to AssignedElements
        else if (Target === 'AssignedElements') {
            $(UI.item).find('input[type="hidden"]').attr('name', 'AssignedElements');
            $(UI.item).find('input[type="checkbox"]').attr('name', 'SelectAllAssignedElements');
            $(UI.item).find('input[type="checkbox"]').removeAttr('checked');
        }

        // rename it to AssignedRequiredElements
        else if (Target === 'AssignedRequiredElements') {
            $(UI.item).find('input[type="hidden"]').attr('name', 'AssignedRequiredElements');
            $(UI.item).find('input[type="checkbox"]').attr('name', 'SelectAllAssignedRequiredElements');
            $(UI.item).find('input[type="checkbox"]').removeAttr('checked');
        }
    }

    return TargetNS;
}(Core.Agent.Admin.Znuny4OTRSDynamicFieldScreen || {}));

Core.Agent.Admin.Znuny4OTRSDynamicFieldScreen.Init();
