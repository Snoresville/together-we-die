--------------------------------------------------------------------------------
modifier_abaddon_borrow_time_lua_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_abaddon_borrow_time_lua_buff:IsHidden()
    return false
end

function modifier_abaddon_borrow_time_lua_buff:IsDebuff()
    return false
end

function modifier_abaddon_borrow_time_lua_buff:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_abaddon_borrow_time_lua_buff:OnCreated(kv)
    self.str_multiplier = self:GetAbility():GetSpecialValueFor("str_multiplier")
end

function modifier_abaddon_borrow_time_lua_buff:OnRefresh(kv)
    self.str_multiplier = self:GetAbility():GetSpecialValueFor("str_multiplier")
end

function modifier_abaddon_borrow_time_lua_buff:OnRemoved()
end

function modifier_abaddon_borrow_time_lua_buff:OnDestroy()

end

function modifier_abaddon_borrow_time_lua_buff:GetPriority()
    return MODIFIER_PRIORITY_HIGH
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_abaddon_borrow_time_lua_buff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }

    return funcs
end

function modifier_abaddon_borrow_time_lua_buff:GetModifierIncomingDamage_Percentage(params)
    if IsServer() then
        local reduction = 100
        local caster = self:GetCaster()
        local damageTaken = params.original_damage

        local heal_amount = math.floor(damageTaken + math.floor(caster:GetStrength() * self.str_multiplier))
        self:GetParent():Heal(heal_amount, caster)

        return -reduction
    end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_abaddon_borrow_time_lua_buff:GetEffectName()
    return "particles/units/heroes/hero_abaddon/abaddon_borrowed_time.vpcf"
end

function modifier_abaddon_borrow_time_lua_buff:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end