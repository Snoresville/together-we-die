invoker_wex_lua = class({})
LinkLuaModifier("modifier_invoker_wex_lua", "lua_abilities/invoker_wex_lua/modifier_invoker_wex_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invoker_wex_cdr_lua", "lua_abilities/invoker_wex_lua/modifier_invoker_wex_cdr_lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
-- Passive Modifier
function invoker_wex_lua:GetIntrinsicModifierName()
    return "modifier_invoker_wex_cdr_lua"
end
--------------------------------------------------------------------------------
-- Ability Start
function invoker_wex_lua:OnSpellStart()
    -- unit identifier
    local caster = self:GetCaster()

    -- add modifier
    local modifier = caster:AddNewModifier(
            caster, -- player source
            self, -- ability source
            "modifier_invoker_wex_lua", -- modifier name
            {  } -- kv
    )

    -- register to invoke ability
    self.invoke:AddOrb(modifier)
end

--------------------------------------------------------------------------------
-- Ability Events
function invoker_wex_lua:OnHeroCalculateStatBonus()
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
        self.invoke:UpdateOrb("modifier_invoker_wex_lua", self:GetLevel())
    end
end