function StatsGetTopPlayersStatsFeedback(event_data) {
    var topPlayers = event_data.data;

    var topPlayersListContainer = $("#TopPlayersInfo").FindChildTraverse("TopPlayersList");
    var playerPanel;
    for (var key in topPlayers) {
        if (topPlayers.hasOwnProperty(key)) {
            var topPlayer = topPlayers[key];
            var topPlayerSteamId = topPlayer.id;
            var playerWinCount = topPlayer.wins;

            playerPanel = $.CreatePanel("Panel", topPlayersListContainer, "playerPanel" + key);
            playerPanel.BLoadLayoutSnippet("player");

            var image = playerPanel.FindChildInLayoutFile("PlayerSteamUserAvatar");
            image.steamid = topPlayerSteamId;
            var userName = playerPanel.FindChildInLayoutFile("PlayerSteamUserName");
            userName.steamid = topPlayerSteamId;
            var winsPanel = playerPanel.FindChildInLayoutFile("PlayerWins");
            winsPanel.text = playerWinCount;
        }
    }
}

(function () {
    GameEvents.Subscribe("stats_get_top_players_stats_feedback", StatsGetTopPlayersStatsFeedback);
})();