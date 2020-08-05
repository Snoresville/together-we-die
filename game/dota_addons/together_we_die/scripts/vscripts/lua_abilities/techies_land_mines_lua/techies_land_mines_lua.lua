techies_land_mines_lua = class({})
LinkLuaModifier("modifier_techies_land_mines_lua", "lua_abilities/techies_land_mines_lua/modifier_techies_land_mines_lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
techies_land_mines_lua.techies_mines = {}

--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function techies_land_mines_lua:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

--------------------------------------------------------------------------------
-- Ability Start
function techies_land_mines_lua:OnSpellStart()
    -- unit identifier
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()

    local max_mines = self:GetSpecialValueFor("max_mines")

    if #self.techies_mines >= max_mines then
        for _, mine in pairs(self.techies_mines) do
            if mine ~= nil and IsValidEntity(mine) then
                mine:ForceKill(false)
                break
            end
        end
    end

    local land_mine = CreateUnitByName("npc_dota_techies_land_mine", point, true, self:GetCaster(), self:GetCaster():GetPlayerOwner(), self:GetCaster():GetTeamNumber())
    if land_mine ~= nil then
        land_mine:SetControllableByPlayer(caster:GetPlayerID(), false)
        land_mine:SetOwner(caster)
        land_mine:AddNewModifier(self:GetCaster(), self, "modifier_techies_land_mines_lua", {})

        -- Add to mines list
        self:AddMine(land_mine)
    end

    -- Create Sound
    local sound_cast = "Hero_Techies.LandMine.Plant"
    EmitSoundOn(sound_cast, self:GetCaster())
end

function techies_land_mines_lua:AddMine(land_mine)
    table.insert(self.techies_mines, land_mine)
end

function techies_land_mines_lua:RemoveMine(land_mine)
    for key, mine in pairs(self.techies_mines) do
        if mine == land_mine then
            table.remove(self.techies_mines, key)
            break
        end
    end
end