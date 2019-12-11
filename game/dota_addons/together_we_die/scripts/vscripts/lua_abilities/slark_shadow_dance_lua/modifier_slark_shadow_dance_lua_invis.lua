modifier_slark_shadow_dance_lua_invis = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_slark_shadow_dance_lua_invis:IsHidden()
    return false
end

function modifier_slark_shadow_dance_lua_invis:IsDebuff()
    return false
end

function modifier_slark_shadow_dance_lua_invis:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_slark_shadow_dance_lua_invis:OnCreated(kv)
    if IsServer() then
        local sound_cast = "Hero_Slark.ShadowDance"
        EmitSoundOn( sound_cast, self:GetParent() )
    end
end

function modifier_slark_shadow_dance_lua_invis:OnRefresh(kv)
end

function modifier_slark_shadow_dance_lua_invis:OnDestroy(kv)
    if IsServer() then
        local sound_cast = "Hero_Slark.ShadowDance"
        StopSoundOn( sound_cast, self:GetParent() )
    end
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_slark_shadow_dance_lua_invis:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
    }

    return funcs
end

function modifier_slark_shadow_dance_lua_invis:GetModifierInvisibilityLevel()
    return 2
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_slark_shadow_dance_lua_invis:CheckState()
    local state = {
        [MODIFIER_STATE_INVISIBLE] = true,
        [MODIFIER_STATE_TRUESIGHT_IMMUNE] = true,
    }

    return state
end