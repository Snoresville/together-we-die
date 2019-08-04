"use strict";

function OnRoundDataUpdated( table_name, key, data )
{
	UpdateRoundUI();
}

CustomNetTables.SubscribeNetTableListener( "round_data", OnRoundDataUpdated )


function UpdateRoundUI()
{
	var key = 0;
	var roundData = CustomNetTables.GetTableValue( "round_data", key.toString() );
	if ( roundData !== null )
	{
		$( "#RoundNumber" ).text = roundData.round_number;
		
		var bRoundInProgress = roundData.prep_time_left === 0;
		$( "#HoldoutState" ).SetHasClass( "RoundInProgress", bRoundInProgress );
	}
}

function OnRoundStarted( roundStartData )
{
	var flTitleDuration = 5.0;
	if ( roundStartData !== null )
	{
		$( "#RoundStartPanel" ).FindChildInLayoutFile( "RoundNameLabel" ).text = $.Localize( roundStartData.round_name );
		$.Msg("round description is "+roundStartData.round_description);
		$( "#RoundStartPanel" ).SetHasClass( "HasDescription" , false );  
		if( roundStartData.round_description !== undefined )
		{
			$( "#RoundStartPanel" ).SetHasClass( "HasDescription" , true );  
			$( "#RoundStartPanel" ).FindChildInLayoutFile( "RoundDescriptionLabel" ).text = $.Localize( roundStartData.round_description );
			flTitleDuration = 8.0;
		}
		$( "#RoundStartPanel" ).SetHasClass( "Round" + ( roundStartData.round_number - 1), false );  
		$( "#RoundStartPanel" ).SetHasClass( "Round" + roundStartData.round_number, true );
	}

	$( "#RoundStartPanel" ).SetHasClass( "Visible", true );
	Game.EmitSound( "RoundStart" );
	$.Schedule( flTitleDuration, HideRoundStart );
	$.DispatchEvent( "DOTAHUDHideScoreboard" )
}

function HideRoundStart()
{
	$( "#RoundStartPanel" ).SetHasClass( "Visible", false );
}

GameEvents.Subscribe( "round_started", OnRoundStarted );

// Returns a reference to the dota hud panel
function GetHud(){
    var panel = $.GetContextPanel().GetParent();
    for(var i = 0; i < 100; i++) {
        if(panel.id != "Hud") {
            panel = panel.GetParent();
        } else {
            break;
        }
    };
    return panel
}

(function()
{
	var hudRoot = GetHud();
	var customHudContents = $("#CustomHudContents");
	var inventory = hudRoot.FindChildTraverse("inventory");
	var inventoryTpScroll = hudRoot.FindChildTraverse("inventory_tpscroll_container");
	inventory.SetParent(customHudContents);
	inventory.style.horizontalAlign = "left";
	inventory.style.verticalAlign = "center";
	inventory.style.zIndex = "20";
	inventoryTpScroll.SetParent(customHudContents);
	inventoryTpScroll.style.horizontalAlign = "left";
	inventoryTpScroll.style.verticalAlign = "center";
	inventoryTpScroll.style.marginTop = "200px";

	var rightFlare = hudRoot.FindChildTraverse("right_flare");
	if (rightFlare) {
		rightFlare.RemoveAndDeleteChildren();
	}
})();