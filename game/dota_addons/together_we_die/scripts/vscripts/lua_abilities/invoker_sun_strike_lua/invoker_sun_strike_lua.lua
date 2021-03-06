invoker_sun_strike_lua = class({})
LinkLuaModifier("modifier_invoker_sun_strike_lua_thinker", "lua_abilities/invoker_sun_strike_lua/modifier_invoker_sun_strike_lua_thinker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_stunned_lua", "lua_abilities/generic/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function invoker_sun_strike_lua:GetBehavior()
    if self:GetCaster():HasScepter() then
        return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
    end

    return DOTA_ABILITY_BEHAVIOR_DIRECTIONAL + DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end
--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function invoker_sun_strike_lua:GetAOERadius()
    return self:GetSpecialValueFor("area_of_effect")
end

-- Commented out for Cataclysm talent when available
--------------------------------------------------------------------------------
-- function invoker_sun_strike_lua:GetCooldown( level )
-- 	if self:GetCaster():HasScepter() then
-- 		return self:GetSpecialValueFor( "cooldown_scepter" )
-- 	end

-- 	return self.BaseClass.GetCooldown( self, level )
-- end

--------------------------------------------------------------------------------
-- Ability Cast Filter
-- function invoker_sun_strike_lua:CastFilterResultTarget( hTarget )
-- 	if self:GetCaster() == hTarget then
-- 		return UF_FAIL_CUSTOM
-- 	end

-- 	local nResult = UnitFilter(
-- 		hTarget,
-- 		DOTA_UNIT_TARGET_TEAM_BOTH,
-- 		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
-- 		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
-- 		self:GetCaster():GetTeamNumber()
-- 	)
-- 	if nResult ~= UF_SUCCESS then
-- 		return nResult
-- 	end

-- 	return UF_SUCCESS
-- end

-- function invoker_sun_strike_lua:GetCustomCastErrorTarget( hTarget )
-- 	if self:GetCaster() == hTarget then
-- 		return "#dota_hud_error_cant_cast_on_self"
-- 	end

-- 	return ""
-- end

--------------------------------------------------------------------------------
-- Ability Start
function invoker_sun_strike_lua:OnSpellStart()
    -- unit identifier
    local caster = self:GetCaster()
    -- Talent tree
    self.talent_multi_barrage = false
    local special_sun_strike_barrage_lua = caster:FindAbilityByName("special_sun_strike_barrage_lua")
    if (special_sun_strike_barrage_lua and special_sun_strike_barrage_lua:GetLevel() ~= 0) then
        self.talent_multi_barrage = true
    end

    if self:GetCaster():HasScepter() then
        local enemies = FindUnitsInRadius(
                caster:GetTeamNumber(), -- int, your team number
                caster:GetOrigin(), -- point, center point
                nil, -- handle, cacheUnit. (not known)
                FIND_UNITS_EVERYWHERE, -- float, radius. or use FIND_UNITS_EVERYWHERE
                self:GetAbilityTargetTeam(), -- int, team filter
                self:GetAbilityTargetType(), -- int, type filter
                self:GetAbilityTargetFlags(), -- int, flag filter
                FIND_CLOSEST, -- int, order filter
                false    -- bool, can grow cache
        )

        local scepter_max_targets = self:GetSpecialValueFor("scepter_max_targets")
        local count = 0
        for _, enemy in pairs(enemies) do
            self:CreateSunStrike(caster, enemy:GetOrigin(), true)
            count = count + 1

            if count >= scepter_max_targets then
                break
            end
        end
    else
        self:CreateSunStrike(caster, self:GetCursorPosition(), false)
    end

end

function invoker_sun_strike_lua:CreateSunStrike(caster, point, visible)
    -- Talent tree
    if self.talent_multi_barrage then
        local inner = Vector(200, 0, 0)
        for i = 0, 3 do
            local location = RotatePosition(Vector(0, 0, 0), QAngle(0, 90 * i, 0), inner)
            self:SunStrikeLoc(caster, point + location, visible)
        end
    end

    self:SunStrikeLoc(caster, point, visible)
end

function invoker_sun_strike_lua:SunStrikeLoc(caster, point, visible)
    -- get values
    local delay = self:GetSpecialValueFor("delay")
    local vision_distance = self:GetSpecialValueFor("vision_distance")
    local vision_duration = self:GetSpecialValueFor("vision_duration")

    -- create modifier thinker
    CreateModifierThinker(
            caster,
            self,
            "modifier_invoker_sun_strike_lua_thinker",
            {
                duration = delay,
                visible = visible
            },
            point,
            caster:GetTeamNumber(),
            false
    )
    -- create vision
    AddFOWViewer(caster:GetTeamNumber(), point, vision_distance, vision_duration, false)
end