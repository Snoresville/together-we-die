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