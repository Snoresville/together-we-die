Stats = Stats or {}

Stats.host = "https://twd.giantcrabby.com/api/v1/"
Stats.keyVersion = "v1"

function Stats.SubmitMatch(version, winner, callback)
    local data = {}
    data.version = version
    data.players = {}
    data.map = GetMapName()
    data.gameLength = math.ceil(GameRules:GetGameTime())
    data.winnerTeam = winner

    for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
        if PlayerResource:HasSelectedHero(nPlayerID) then
            local playerData = {}
            playerData.steamId64 = tostring(PlayerResource:GetSteamID(nPlayerID))
            playerData.team = tostring(PlayerResource:GetTeam(nPlayerID))

            table.insert(data.players, playerData)
        end
    end

    Stats.SendData(string.format("matches/%s", GameRules:GetMatchID()), data, callback, 30)
end

function Stats.RequestData(url, callback, rep)
    local req = CreateHTTPRequestScriptVM("GET", Stats.host .. url)
    req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", GetDedicatedServerKey(Stats.keyVersion))
    req:Send(function(res)
        if res.StatusCode ~= 200 then
            print("Server connection failure")

            if rep ~= nil and rep > 0 then
                print("Repeating in 3 seconds")

                Timers:CreateTimer(3, function()
                    Stats.SendData(url, callback, rep - 1)
                end)
            end

            return
        end

        if callback then
            print("[STATS] Received", res.Body)
            local obj, pos, err = json.decode(res.Body)
            callback(obj)
        end
    end)
end

function Stats.SendData(url, data, callback, rep)
    local req = CreateHTTPRequestScriptVM("POST", Stats.host .. url)
    local encoded = json.encode(data)
    print("[STATS] URL", url, "payload:", encoded)
    req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", GetDedicatedServerKey(Stats.keyVersion))
    req:SetHTTPRequestGetOrPostParameter('data', encoded)
    req:Send(function(res)
        if res.StatusCode ~= 201 then
            print("[STATS] Server connection failure, code", res.StatusCode)

            if rep ~= nil and rep > 0 then
                print("[STATS] Repeating in 3 seconds")

                Timers:CreateTimer(3, function()
                    Stats.SendData(url, data, callback, rep - 1)
                end)
            end

            return
        end

        if callback then
            print("[STATS] Received", res.Body)
            local obj, pos, err = json.decode(res.Body)
            callback(obj)
        end
    end)
end