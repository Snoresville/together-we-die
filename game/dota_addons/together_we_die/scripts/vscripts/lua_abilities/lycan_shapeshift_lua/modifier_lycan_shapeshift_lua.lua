modifier_lycan_shapeshift_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_lycan_shapeshift_lua:IsHidden()
	return false
end

function modifier_lycan_shapeshift_lua:IsDebuff()
	return false
end

function modifier_lycan_shapeshift_lua:IsPurgable()
	return false
end

function modifier_lycan_shapeshift_lua:RemoveOnDeath()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_lycan_shapeshift_lua:OnCreated( kv )
	
end

--------------------------------------------------------------------------------
-- Aura

function modifier_lycan_shapeshift_lua:IsAura()
	return true
end

function modifier_lycan_shapeshift_lua:GetModifierAura()
	return "modifier_lycan_shapeshift_lua_speed_aura"
end

function modifier_lycan_shapeshift_lua:GetAuraRadius()
	return FIND_UNITS_EVERYWHERE
end

function modifier_lycan_shapeshift_lua:GetAuraSearchTeam()
	return self:GetAbility():GetAbilityTargetTeam()
end

function modifier_lycan_shapeshift_lua:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end

function modifier_lycan_shapeshift_lua:GetAuraSearchFlags()
	return self:GetAbility():GetAbilityTargetFlags()
end

function modifier_lycan_shapeshift_lua:GetAuraEntityReject( hEntity )
    if not IsServer() then return false end

    -- reject if it's not under Lycan's control
    if hEntity:GetPlayerOwnerID() ~= self:GetCaster():GetPlayerOwnerID() then
        return true
    end

    return false
end
--]]
--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_lycan_shapeshift_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		
	}

	return funcs
end

function modifier_lycan_shapeshift_lua:GetModifierModelChange()
	return "models/heroes/lycan/lycan_wolf.vmdl"
end

--------------------------------------------------------------------------------
-- Revert back to human
function modifier_lycan_shapeshift_lua:OnDestroy()
	-- Get Resources
    local particle_cast = "particles/units/heroes/hero_lycan/lycan_shapeshift_revert.vpcf"
	
	-- Create Particle
    -- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetCaster() )
    local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
    ParticleManager:ReleaseParticleIndex(effect_cast)
end


