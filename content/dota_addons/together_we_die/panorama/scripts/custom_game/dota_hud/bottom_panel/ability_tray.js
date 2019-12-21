"use strict";
/*
    Ability Tray Panoramanager 0.0.1

    This panel contains the logic for the ability tray.
    The "ability" class is instantiated in the ability_tray_ability.js file.
    This panel handles calling these abilities to update under certain
    situations - when new units are selected, or over time as needed.

*/

// List of index --> {panel, abilityName, abilityIndex}
var AbilityPanels = [];  

// Information about select unit
var queryUnit;
var unitMana;

// Throttle for "slow" updates to ability panels
var slowThrottle = 0;

var MAX_ABILITIES_DISPLAY = 26;

// ------------------------------------------------------------- //
// --------------------- Meta-Panel Actions -------------------- //
// ------------------------------------------------------------- //

/*
    This runs when a new query unit is selected,
    or the existing query unit has a major change (e.g. spends skillpoints)
    
    This is a surprisingly complicated function!
    This is because Dota abilities can be hidden or "null", even if they are not in the last slot
*/
function UpdateAbilityList()
{
    //$.Msg("ability_tray.js UpdateAbilityList | Runs!")

    queryUnit = Players.GetLocalPlayerPortraitUnit();

	// see if we can level up
	var nRemainingPoints = Entities.GetAbilityPoints( queryUnit );
	var bPointsToSpend = ( nRemainingPoints > 0 );
	var bControlsUnit = Entities.IsControllableByPlayer( queryUnit, Game.GetLocalPlayerID() );
	$.GetContextPanel().SetHasClass( "could_level_up", ( bControlsUnit && bPointsToSpend ) );

    var abilityContainer = null;
    var abilityBottom = null;

    var nUsedPanels = 0;

    var abilityCount = 0;
    var hiddenAbilityCount = 0;

    for (var abilityNumber = 0; abilityNumber < Entities.GetAbilityCount( queryUnit ) ; abilityNumber +=1 ) {

        var ability = Entities.GetAbility( queryUnit, abilityNumber );
        var hidden = Abilities.IsHidden( ability );
        var abilityName = Abilities.GetAbilityName( ability );

        // $.Msg("Checking slot: "+abilityNumber+", found ability: "+abilityName);

        if (hidden) {
            // There is nothing left to process on hidden abilities
            // They do not get a panel in the ability.
            hiddenAbilityCount += 1;
        } else if(abilityName == null || abilityName === "") {
            // Some ability slots are just empty. The HUD will not make ability slots for them
            // So, increment the hiddenAbilityCount so the HUD stays in sync
            hiddenAbilityCount += 1;
            //$.Msg("Found ability with no name in abilityNumber=" + abilityNumber + ". Treating as hidden");
        } else {

            // The AbilityContainer name for this ability does not necessarily match the ability number on the entity
            // Hidden abilities are not added to the bar, so later abilities have their indices shifted down
            var abilityContainerIndex = (abilityNumber-hiddenAbilityCount);

            abilityContainer = AbilityPanels[abilityContainerIndex];
            //$.Msg(
            //    "Ability index: " + abilityNumber +
            //    " | Ability name: " + abilityName +
            //    " | Hidden count: " + hiddenAbilityCount +
            //    " | AbilityContainer=\"Ability" + (abilityNumber - hiddenAbilityCount) + "\""
            //);

            if (abilityContainer == null) {
                // Once we're out of containers it's not worth continuing
                nUsedPanels = 100; // Nothing to delete
                break
            } else {

                abilityContainer.panel.visible = true;

                if (abilityContainer.abilityIndex !== ability) { 
                    //$.Msg("Setting the ability in slot:"+abilityContainerIndex+" to ability: "+ability);
                    abilityContainer.SetAbility(ability);
                }
				nUsedPanels++;

            }
        }
    }

	// clear any remaining panels
	for ( var i = nUsedPanels; i < MAX_ABILITIES_DISPLAY; ++i )
	{
		//$.Msg("action_bar.js UpdateAbilityList | Attempting to hide a panel")
        var panelToHide = AbilityPanels[i].panel;
        panelToHide.visible = false;
	}
}

// ------------------------------------------------------------- //
// ------------- Updates for Individual Abilities -------------- //
// ------------------------------------------------------------- //

function UpdateAbilityPanels(doSlowUpdate) {
    // Fetch some common data about the unit
    queryUnit = Players.GetLocalPlayerPortraitUnit();
    unitMana = Entities.GetMana( queryUnit );

    for (var i=0; i< MAX_ABILITIES_DISPLAY; i++) {
        if (doSlowUpdate){
            AbilityPanels[i].SlowUpdate();
        }
        AbilityPanels[i].FastUpdate();
    }
};


// ------------------------------------------------------------- //
// ---------------------- One-offs and IIFE -------------------- //
// ------------------------------------------------------------- //

function PeriodicAbilityPanelUpdate() {
    slowThrottle = (slowThrottle + 1) % 20
    UpdateAbilityPanels(slowThrottle === 0);

    $.Schedule(0.03, PeriodicAbilityPanelUpdate );
}

// First time load: create some empty ability panels
function CreateAbilityPanels()
{
    $.GetContextPanel().RemoveAndDeleteChildren();
    for (var i=0; i<MAX_ABILITIES_DISPLAY; i++)
    {
        var newPanel = new AbilitySlot($.GetContextPanel(), i);
        AbilityPanels.push(newPanel);
    }
}

(function()
{	
	$.Msg("Loading action bar");

	CreateAbilityPanels();
	$.GetContextPanel().UpdateAbilityList = UpdateAbilityList

	UpdateAbilityList(); // initial update

    PeriodicAbilityPanelUpdate(); // Update the status of each ability panel
})();

