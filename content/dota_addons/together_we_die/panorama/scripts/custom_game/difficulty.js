function SelectDifficulty( difficultyLevel )
{
    GameEvents.SendCustomGameEventToServer( "select_difficulty", { "difficulty" : difficultyLevel } );
    HideDifficultyDisplay();
}

function ShowDifficultyDisplay()
{
    $( "#DifficultyPanel" ).SetHasClass( "Visible", true );
}

function HideDifficultyDisplay()
{
    $( "#DifficultyPanel" ).SetHasClass( "Visible", false );
}

function ShowDifficultyVoteOutcome( event_data )
{
    HideDifficultyDisplay();
    if( event_data.difficulty_title !== undefined )
    {
        $.Msg("difficulty is "+event_data.difficulty_title);
        $( "#DifficultyVoteOutcomePanel" ).FindChildInLayoutFile( "DifficultyVoteOutcomeDescriptionLabel" ).text = $.Localize( event_data.difficulty_title );
        $( "#DifficultyVoteOutcomePanel" ).SetHasClass( "Visible", true );
        var difficultyVoteOutcomeDisplayDuration = 8.0;
        $.Schedule( difficultyVoteOutcomeDisplayDuration, HideDifficultyVoteOutcome );
    }
}

function HideDifficultyVoteOutcome()
{
    $( "#DifficultyVoteOutcomePanel" ).SetHasClass( "Visible", false );
}

GameEvents.Subscribe( "show_difficulty_vote", ShowDifficultyDisplay );
GameEvents.Subscribe( "show_difficulty_vote_outcome", ShowDifficultyVoteOutcome );