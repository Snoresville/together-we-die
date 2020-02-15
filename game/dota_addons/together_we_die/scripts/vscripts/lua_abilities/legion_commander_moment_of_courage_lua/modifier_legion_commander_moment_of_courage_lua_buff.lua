
--------------------------------------------------------------------------------
modifier_legion_commander_moment_of_courage_lua_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_legion_commander_moment_of_courage_lua_buff:IsHidden()
    return false
end

function modifier_legion_commander_moment_of_courage_lua_buff:IsDebuff()
    return false
end

function modifier_legion_commander_moment_of_courage_lua_buff:IsStunDebuff()
    return false
end

function modifier_legion_commander_moment_of_courage_lua_buff:IsPurgable()
    return false
end

function modifier_legion_commander_moment_of_courage_lua_buff:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_legion_commander_moment_of_courage_lua_buff:OnCreated(kv)
    -- references
    self.str_multiplier = self:GetAbility():GetSpecialValueFor("str_multiplier")
    self.hp_leech_percent = self:GetAbility():GetSpecialValueFor("hp_leech_percent")
    self.bat = 0.1
end

function modifier_legion_commander_moment_of_courage_lua_buff:OnRefresh(kv)
    -- references
    self.str_multiplier = self:GetAbility():GetSpecialValueFor("str_multiplier")
    self.hp_leech_percent = self:GetAbility():GetSpecialValueFor("hp_leech_percent")
    self.bat = 0.1
end

function modifier_legion_commander_moment_of_courage_lua_buff:OnRemoved()
end

function modifier_legion_commander_moment_of_courage_lua_buff:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_legion_commander_moment_of_courage_lua_buff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
        MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
        MODIFIER_EVENT_ON_TAKEDAMAGE,
    }

    return funcs
end

function modifier_legion_commander_moment_of_courage_lua_buff:GetModifierBaseAttackTimeConstant()
    return self.bat
end

function modifier_legion_commander_moment_of_courage_lua_buff:GetModifierProcAttack_Feedback( params )
    if IsServer() then
        -- filter
        local pass = false
        if params.target:GetTeamNumber()~=self:GetParent():GetTeamNumber() then
            if (not params.target:IsBuilding()) and (not params.target:IsOther()) then
                pass = true
            end
        end

        -- logic
        if pass then
            -- save attack record
            self.attack_record = params.record
        end
    end
end

function modifier_legion_commander_moment_of_courage_lua_buff:OnTakeDamage( params )
    if IsServer() then
        -- filter
        local pass = false
        if self.attack_record and params.record == self.attack_record then
            pass = true
            self.attack_record = nil
        end

        -- logic
        if pass then
            -- get heal value
            local heal = params.damage * (self.hp_leech_percent + math.floor(self:GetParent():GetStrength() * self.str_multiplier))/100
            self:GetParent():Heal( heal, self:GetAbility() )
            self:PlayEffects()
            -- Remove after activating
            self:Destroy()
        end
    end
end
function modifier_legion_commander_moment_of_courage_lua_buff:PlayEffects()
    -- Get Resources
    local particle_cast = "particles/units/heroes/hero_legion_commander/legion_commander_courage_hit.vpcf"
    local sound_cast = "Hero_LegionCommander.Courage"

    -- Create Particle
    local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())

    -- buff particle
    self:AddParticle(
            effect_cast,
            false, -- bDestroyImmediately
            false, -- bStatusEffect
            -1, -- iPriority
            false, -- bHeroEffect
            false -- bOverheadEffect
    )

    -- Create Sound
    EmitSoundOn(sound_cast, self:GetParent())
end