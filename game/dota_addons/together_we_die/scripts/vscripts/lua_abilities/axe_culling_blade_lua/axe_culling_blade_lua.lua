axe_culling_blade_lua = class({})
LinkLuaModifier("modifier_axe_culling_blade_lua", "lua_abilities/axe_culling_blade_lua/modifier_axe_culling_blade_lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function axe_culling_blade_lua:GetAOERadius()
    if self:GetCaster():HasScepter() then
        return self:GetSpecialValueFor( "scepter_aoe" )
    end
    return 0
end
--------------------------------------------------------------------------------
-- Ability Start
function axe_culling_blade_lua:OnSpellStart()
    -- unit identifier
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()

    -- load data
    local damage = self:GetSpecialValueFor("damage") + (self:GetCaster():GetStrength() * self:GetSpecialValueFor("str_multiplier"))
    local threshold = self:GetSpecialValueFor("kill_threshold") + (self:GetCaster():GetStrength() * self:GetSpecialValueFor("str_multiplier"))
    local radius = self:GetSpecialValueFor("speed_aoe")
    local damage_radius = self:GetSpecialValueFor("scepter_aoe")
    local duration = self:GetSpecialValueFor("speed_duration")

    -- Check success / not
    local success = false
    if target:GetHealth() <= threshold then
        success = true
    end

    -- effects
    self:PlayEffects(target, success)

    if success then
        -- Success:
        -- Damage as HPLoss
        local damageTable = {
            victim = target,
            attacker = caster,
            damage = threshold,
            damage_type = DAMAGE_TYPE_PURE,
            ability = self, --Optional.
            damage_flags = DOTA_DAMAGE_FLAG_HPLOSS, --Optional.
        }

		if caster:HasScepter() then
			local enemies = FindUnitsInRadius(
					caster:GetTeamNumber(), -- int, your team number
					target:GetOrigin(), -- point, center point
					nil, -- handle, cacheUnit. (not known)
					damage_radius, -- float, radius. or use FIND_UNITS_EVERYWHERE
					self:GetAbilityTargetTeam(), -- int, team filter
					self:GetAbilityTargetType(), -- int, type filter
					self:GetAbilityTargetFlags(), -- int, flag filter
					0, -- int, order filter
					false    -- bool, can grow cache
			)

			for _, enemy in pairs(enemies) do
				damageTable.victim = enemy
				ApplyDamage(damageTable)
			end
		else
			ApplyDamage(damageTable)
		end

        -- Resets cooldown
        self:EndCooldown()

        -- Apply modifier
        local allies = FindUnitsInRadius(
                caster:GetTeamNumber(), -- int, your team number
                caster:GetOrigin(), -- point, center point
                nil, -- handle, cacheUnit. (not known)
                radius, -- float, radius. or use FIND_UNITS_EVERYWHERE
                DOTA_UNIT_TARGET_TEAM_FRIENDLY, -- int, team filter
                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, -- int, type filter
                0, -- int, flag filter
                0, -- int, order filter
                false    -- bool, can grow cache
        )
        for _, ally in pairs(allies) do
            ally:AddNewModifier(
                    caster, -- player source
                    self, -- ability source
                    "modifier_axe_culling_blade_lua", -- modifier name
                    { duration = duration } -- kv
            )
        end
    else
        -- Failed
        -- Magical damage
        local damageTable = {
            victim = target,
            attacker = caster,
            damage = damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self, --Optional.
        }
		if caster:HasScepter() then
			local enemies = FindUnitsInRadius(
					caster:GetTeamNumber(), -- int, your team number
					target:GetOrigin(), -- point, center point
					nil, -- handle, cacheUnit. (not known)
					damage_radius, -- float, radius. or use FIND_UNITS_EVERYWHERE
                    self:GetAbilityTargetTeam(), -- int, team filter
                    self:GetAbilityTargetType(), -- int, type filter
                    self:GetAbilityTargetFlags(), -- int, flag filter
					0, -- int, order filter
					false    -- bool, can grow cache
			)

			for _, enemy in pairs(enemies) do
				damageTable.victim = enemy
				ApplyDamage(damageTable)
			end
		else
			ApplyDamage(damageTable)
		end
    end
end

--------------------------------------------------------------------------------
function axe_culling_blade_lua:PlayEffects(target, success)
    -- Get Resources
    local particle_cast = ""
    local sound_cast = ""
    if success then
        particle_cast = "particles/units/heroes/hero_axe/axe_culling_blade_kill.vpcf"
        sound_cast = "Hero_Axe.Culling_Blade_Success"
    else
        particle_cast = "particles/units/heroes/hero_axe/axe_culling_blade.vpcf"
        sound_cast = "Hero_Axe.Culling_Blade_Fail"
    end

    -- load data
    local direction = (target:GetOrigin() - self:GetCaster():GetOrigin()):Normalized()

    -- Create Particle
    local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:SetParticleControl(effect_cast, 4, target:GetOrigin())
    ParticleManager:SetParticleControlForward(effect_cast, 3, direction)
    ParticleManager:SetParticleControlForward(effect_cast, 4, direction)
    -- assert(loadfile("lua_abilities/rubick_spell_steal_lua/rubick_spell_steal_lua_color"))(self,effect_target)
    ParticleManager:ReleaseParticleIndex(effect_cast)

    -- Create Sound
    EmitSoundOn(sound_cast, target)
end