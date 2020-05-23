lycan_howl_lua = class({})
LinkLuaModifier("modifier_lycan_howl_lua", "lua_abilities/lycan_howl_lua/modifier_lycan_howl_lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
-- Ability Start
function lycan_howl_lua:OnSpellStart()
    -- unit identifier
    caster = self:GetCaster()
	
	-- load data
    local radius = self:GetSpecialValueFor("radius")
    local damage_reduction = self:GetSpecialValueFor("attack_damage_reduction")
    local armor_reduction = self:GetSpecialValueFor("armor") + caster:GetStrength() * self:GetSpecialValueFor("armor_decrease_per_strength")
    local howl_duration = self:GetSpecialValueFor("howl_duration") + caster:GetStrength() * self:GetSpecialValueFor("howl_duration_increase_per_strength")
	
	-- Find Units in Radius
    local enemies = FindUnitsInRadius(
            self:GetCaster():GetTeamNumber(), -- int, your team number
            caster:GetOrigin(), -- point, center point
            nil, -- handle, cacheUnit. (not known)
            radius, -- float, radius. or use FIND_UNITS_EVERYWHERE
            DOTA_UNIT_TARGET_TEAM_ENEMY, -- int, team filter
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, -- int, type filter
            0, -- int, flag filter
            0, -- int, order filter
            false    -- bool, can grow cache
    )
	
	for _, enemy in pairs(enemies) do
		local modifier = enemy:FindModifierByNameAndCaster("modifier_lycan_howl_lua", caster)
        if modifier ~= nil then
            modifier:ForceRefresh()
        else
			enemy:AddNewModifier(
                    caster, -- player source
                    self, -- ability source
                    "modifier_lycan_howl_lua", -- modifier name
                    { duration = howl_duration } -- kv
            )
		end
    end
	
	-- Effects
	self:PlayHowlEffect()
end

--------------------------------------------------------------------------------
-- Effects
function lycan_howl_lua:PlayHowlEffect()
    -- Get Resources
    local particle_cast = "particles/units/heroes/hero_lycan/lycan_howl_cast.vpcf"
    local sound_cast = "Hero_Lycan.Howl"

    -- Create Particle
    -- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetCaster() )
    local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN, self:GetCaster())
    ParticleManager:ReleaseParticleIndex(effect_cast)

    -- Create Sound
    EmitSoundOn(sound_cast, self:GetCaster())
end