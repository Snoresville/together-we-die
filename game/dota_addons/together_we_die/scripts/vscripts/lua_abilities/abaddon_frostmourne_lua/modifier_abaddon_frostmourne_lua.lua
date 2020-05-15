modifier_abaddon_frostmourne_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_abaddon_frostmourne_lua:IsHidden()
    return true
end

function modifier_abaddon_frostmourne_lua:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_abaddon_frostmourne_lua:OnCreated(kv)
    -- references
    self.slow_duration = self:GetAbility():GetSpecialValueFor("slow_duration")
    self.hit_count = self:GetAbility():GetSpecialValueFor("hit_count")
    self.curse_duration = self:GetAbility():GetSpecialValueFor("curse_duration")
end

function modifier_abaddon_frostmourne_lua:OnRefresh(kv)
    -- references
    self.slow_duration = self:GetAbility():GetSpecialValueFor("slow_duration")
    self.hit_count = self:GetAbility():GetSpecialValueFor("hit_count")
    self.curse_duration = self:GetAbility():GetSpecialValueFor("curse_duration")
end

function modifier_abaddon_frostmourne_lua:OnDestroy(kv)

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_abaddon_frostmourne_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }

    return funcs
end

function modifier_abaddon_frostmourne_lua:OnAttackLanded(params)
    if not IsServer() then
        return
    end
    if params.attacker ~= self:GetParent() then
        return
    end

    -- cancel if break
    if self:GetParent():PassivesDisabled() then
        return
    end

    -- Don't allow stacks if already debuffed
    if params.target:HasModifier("modifier_abaddon_frostmourne_lua_debuff") then
        return
    end

    local modifierStack
    if params.target:HasModifier("modifier_abaddon_frostmourne_lua_stack") then
        modifierStack = params.target:FindModifierByName("modifier_abaddon_frostmourne_lua_stack")
        modifierStack:IncrementStackCount()
        modifierStack:ForceRefresh()
    else
        -- add stack modifier
        modifierStack = params.target:AddNewModifier(
                self:GetParent(), -- player source
                self:GetAbility(), -- ability source
                "modifier_abaddon_frostmourne_lua_stack", -- modifier name
                { duration = self.slow_duration } -- kv
        )
    end

    local stack_count = modifierStack:GetStackCount() or 0
    if stack_count >= self.hit_count then
        params.target:AddNewModifier(
                self:GetParent(),
                self:GetAbility(),
                "modifier_abaddon_frostmourne_lua_debuff",
                { duration = self.curse_duration }
        )

        -- Effects
        EmitSoundOn("Hero_Abaddon.Curse.Proc", params.target)
        modifierStack:Destroy()
    end
end
--------------------------------------------------------------------------------
-- Graphics & Animations
