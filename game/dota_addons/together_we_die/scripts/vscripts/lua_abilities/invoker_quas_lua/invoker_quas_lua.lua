invoker_quas_lua = class({})
LinkLuaModifier("modifier_invoker_quas_lua", "lua_abilities/invoker_quas_lua/modifier_invoker_quas_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invoker_quas_hp_lua", "lua_abilities/invoker_quas_lua/modifier_invoker_quas_hp_lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
-- Passive Modifier
function invoker_quas_lua:GetIntrinsicModifierName()
    return "modifier_invoker_quas_hp_lua"
end
--------------------------------------------------------------------------------
-- Ability Start
function invoker_quas_lua:OnSpellStart()
    -- unit identifier
    local caster = self:GetCaster()

    -- add modifier
    local modifier = caster:AddNewModifier(
            caster, -- player source
            self, -- ability source
            "modifier_invoker_quas_lua", -- modifier name
            {  } -- kv
    )

    -- register to invoke ability
    self.invoke:AddOrb(modifier)
end

--------------------------------------------------------------------------------
-- Ability Events
function invoker_quas_lua:OnUpgrade()
    if not self.invoke then
        -- if first time, upgrade and init Invoke
        local invoke = self:GetCaster():FindAbilityByName("invoker_invoke_lua")
        if invoke then
            if invoke:GetLevel() < 1 then
                invoke:UpgradeAbility(true)
            end
            self.invoke = invoke
        end
    else
        -- update status
        self.invoke:UpdateOrb("modifier_invoker_quas_lua", self:GetLevel())
    end
end