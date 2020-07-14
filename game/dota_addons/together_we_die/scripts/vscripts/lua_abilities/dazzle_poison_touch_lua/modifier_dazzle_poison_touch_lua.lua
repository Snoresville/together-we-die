-- Created by Elfansoer
--[[
Ability checklist (erase if done/checked):
- Scepter Upgrade
- Break behavior
- Linken/Reflect behavior
- Spell Immune/Invulnerable/Invisible behavior
- Illusion behavior
- Stolen behavior
]]
--------------------------------------------------------------------------------
modifier_dazzle_poison_touch_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_dazzle_poison_touch_lua:IsHidden()
    return false
end

function modifier_dazzle_poison_touch_lua:IsDebuff()
    return true
end

function modifier_dazzle_poison_touch_lua:IsStunDebuff()
    return false
end

function modifier_dazzle_poison_touch_lua:IsPurgable()
    return true
end

function modifier_dazzle_poison_touch_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_dazzle_poison_touch_lua:OnCreated(kv)
    -- references
    local eCaster = self:GetCaster()
    local eAbility = self:GetAbility()
    local damage = eAbility:GetSpecialValueFor("damage") + (eCaster:GetIntellect() * eAbility:GetSpecialValueFor("int_multiplier"))
    self.slow = eAbility:GetSpecialValueFor("slow")
    self.duration = kv.duration

    if not IsServer() then
        return
    end
    self.silenced = false
    -- Talent tree
    local special_poison_touch_silence_lua = eCaster:FindAbilityByName("special_poison_touch_silence_lua")
    if (special_poison_touch_silence_lua and special_poison_touch_silence_lua:GetLevel() ~= 0) then
        self.silenced = true
    end
    -- Talent tree
    self.periodic_stun = 0
    local special_poison_touch_periodic_stun_lua = eCaster:FindAbilityByName("special_poison_touch_periodic_stun_lua")
    if (special_poison_touch_periodic_stun_lua and special_poison_touch_periodic_stun_lua:GetLevel() ~= 0) then
        self.periodic_stun = special_poison_touch_periodic_stun_lua:GetSpecialValueFor("value")
    end
    -- precache damage
    self.damageTable = {
        victim = self:GetParent(),
        attacker = eCaster,
        damage = damage,
        damage_type = eAbility:GetAbilityDamageType(),
        ability = eAbility, --Optional.
    }
    -- ApplyDamage(damageTable)

    -- Start interval
    self:StartIntervalThink(1)
    self:OnIntervalThink()
end

function modifier_dazzle_poison_touch_lua:OnRefresh(kv)
end

function modifier_dazzle_poison_touch_lua:OnRemoved()
end

function modifier_dazzle_poison_touch_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_dazzle_poison_touch_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }

    return funcs
end

function modifier_dazzle_poison_touch_lua:OnAttackLanded(params)
    if not IsServer() then
        return
    end
    if params.target ~= self:GetParent() then
        return
    end

    -- refresh duration
    self:SetDuration(self.duration, true)
end

function modifier_dazzle_poison_touch_lua:GetModifierMoveSpeedBonus_Percentage()
    return self.slow
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_dazzle_poison_touch_lua:OnIntervalThink()
    -- apply damage
    ApplyDamage(self.damageTable)

    -- apply stun if talent tree
    if self.periodic_stun ~= 0 then
        self:GetParent():AddNewModifier(
                self:GetCaster(), -- player source
                self:GetAbility(), -- ability source
                "modifier_generic_stunned_lua", -- modifier name
                { duration = self.periodic_stun } -- kv
        )
    end

    -- Play effects
    local sound_cast = "Hero_Dazzle.Poison_Tick"
    EmitSoundOn(sound_cast, self:GetParent())
end

--------------------------------------------------------------------------------
-- Modifier State
function modifier_dazzle_poison_touch_lua:CheckState()
    local state = {
        [MODIFIER_STATE_SILENCED] = self.silenced,
    }

    return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_dazzle_poison_touch_lua:GetEffectName()
    return "particles/units/heroes/hero_dazzle/dazzle_poison_debuff.vpcf"
end

function modifier_dazzle_poison_touch_lua:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_dazzle_poison_touch_lua:GetStatusEffectName()
    return "particles/status_fx/status_effect_poison_dazzle_copy.vpcf"
end

-- function modifier_dazzle_poison_touch_lua:PlayEffects()
-- 	-- Get Resources
-- 	local particle_cast = "particles/units/heroes/hero_heroname/heroname_ability.vpcf"
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

-- 	-- buff particle
-- 	self:AddParticle(
-- 		effect_cast,
-- 		false, -- bDestroyImmediately
-- 		false, -- bStatusEffect
-- 		-1, -- iPriority
-- 		false, -- bHeroEffect
-- 		false -- bOverheadEffect
-- 	)

-- 	-- Create Sound
-- 	EmitSoundOnLocationWithCaster( vTargetPosition, sound_location, self:GetCaster() )
-- 	EmitSoundOn( sound_target, target )
-- end