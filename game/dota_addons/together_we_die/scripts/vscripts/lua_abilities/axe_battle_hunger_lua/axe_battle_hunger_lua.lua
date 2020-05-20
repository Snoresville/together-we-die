axe_battle_hunger_lua = class({})
LinkLuaModifier("modifier_axe_battle_hunger_lua", "lua_abilities/axe_battle_hunger_lua/modifier_axe_battle_hunger_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_axe_battle_hunger_lua_debuff", "lua_abilities/axe_battle_hunger_lua/modifier_axe_battle_hunger_lua_debuff", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
-- AOE Radius
function axe_battle_hunger_lua:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end
--------------------------------------------------------------------------------
-- Ability Start
function axe_battle_hunger_lua:OnSpellStart()
    -- unit identifier
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()

    -- load data
    local duration = self:GetSpecialValueFor("duration")
    local radius = self:GetSpecialValueFor("radius")

    -- Find Units in Radius
    local enemies = FindUnitsInRadius(
            caster:GetTeamNumber(), -- int, your team number
            point, -- point, center point
            nil, -- handle, cacheUnit. (not known)
            radius, -- float, radius. or use FIND_UNITS_EVERYWHERE
            self:GetAbilityTargetTeam(), -- int, team filter
            self:GetAbilityTargetType(), -- int, type filter
            self:GetAbilityTargetFlags(), -- int, flag filter
            0, -- int, order filter
            false    -- bool, can grow cache
    )


    -- effects
    local sound_cast = "Hero_Axe.Battle_Hunger"
    -- add modifier
    for _, enemy in pairs(enemies) do
        -- cancel if linken
        if not enemy:TriggerSpellAbsorb(self) then
            -- add debuff modifier
            enemy:AddNewModifier(
                    caster, -- player source
                    self, -- ability source
                    "modifier_axe_battle_hunger_lua_debuff", -- modifier name
                    { duration = duration } -- kv
            )

            caster:AddNewModifier(
                    caster, -- player source
                    self, -- ability source
                    "modifier_axe_battle_hunger_lua", -- modifier name
                    { duration = duration } -- kv
            )

            EmitSoundOn(sound_cast, enemy)
        end
    end
end

--------------------------------------------------------------------------------
-- function axe_battle_hunger_lua:PlayEffects()
-- 	-- Get Resources
-- 	local particle_cast = "string"
-- 	local sound_cast = "string"

-- 	-- Get Data

-- 	-- Create Particle
-- 	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_NAME, hOwner )
-- 	ParticleManager:SetParticleControl( effect_cast, iControlPoint, vControlVector )
-- 	ParticleManager:SetParticleControlEnt(
-- 		effect_cast,
-- 		iControlPoint,
-- 		hTarget,
-- 		PATTACH_NAME,
-- 		"attach_name",
-- 		vOrigin, -- unknown
-- 		bool -- unknown, true
-- 	)
-- 	ParticleManager:SetParticleControlForward( effect_cast, iControlPoint, vForward )
-- 	SetParticleControlOrientation( effect_cast, iControlPoint, vForward, vRight, vUp )
-- 	ParticleManager:ReleaseParticleIndex( effect_cast )

-- 	-- Create Sound
-- 	EmitSoundOnLocationWithCaster( vTargetPosition, sound_location, self:GetCaster() )
-- end