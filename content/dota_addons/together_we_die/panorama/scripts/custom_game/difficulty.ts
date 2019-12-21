class Difficulty {
    private readonly votePanel: Panel = $("#DifficultyPanel");
    private readonly displayPanel: Panel = $("#DifficultyVoteOutcomePanel");
    private readonly VOTE_OUTCOME_DISPLAY_DURATION = 8.0;

    constructor() {
    }

    voteDifficulty(difficultyLevel: number) {
        const difficultyVote: DifficultyVoteInterface = {"difficulty": difficultyLevel};
        GameEvents.SendCustomGameEventToServer("select_difficulty", difficultyVote);
        this.hideVoteDisplay();
    }

    showVoteDisplay() {
        this.votePanel.SetHasClass("Visible", true);
    }

    hideVoteDisplay() {
        this.votePanel.SetHasClass("Visible", false);
    }

    submitVoteData(event_data: DifficultyVoteDataInterface) {
        this.hideVoteDisplay();
        if (event_data.difficulty_title !== undefined) {
            const difficultyDisplayLabel = this.displayPanel.FindChildInLayoutFile("DifficultyVoteOutcomeDescriptionLabel");
            if (difficultyDisplayLabel) {
                difficultyDisplayLabel.SetAttributeString("text", $.Localize(event_data.difficulty_title));
            }
            this.showDifficulty();

            $.Schedule(this.VOTE_OUTCOME_DISPLAY_DURATION, this.hideDifficulty);
        }
    }

    showDifficulty() {
        this.displayPanel.SetHasClass("Visible", true);
    }

    hideDifficulty() {
        this.displayPanel.SetHasClass("Visible", false);
    }

    registerEvents() {
        GameEvents.Subscribe("show_difficulty_vote", this.showVoteDisplay);
        GameEvents.Subscribe("show_difficulty_vote_outcome", this.submitVoteData);

        $("#EasyButton").SetPanelEvent("onmouseactivate", () => this.voteDifficulty(1));
        $("#NormalButton").SetPanelEvent("onmouseactivate", () => this.voteDifficulty(2));
        $("#HardButton").SetPanelEvent("onmouseactivate", () => this.voteDifficulty(3));
        $("#ImpossibleButton").SetPanelEvent("onmouseactivate", () => this.voteDifficulty(4));
    }
}
