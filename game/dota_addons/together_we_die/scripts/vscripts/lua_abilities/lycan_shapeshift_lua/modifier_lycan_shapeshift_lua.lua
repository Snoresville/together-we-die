modifier_lycan_shapeshift_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_lycan_shapeshift_lua:IsHidden()
	return true
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
	return 99999
end

function modifier_lycan_shapeshift_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_lycan_shapeshift_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_lycan_shapeshift_lua:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
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
    local particle_cast = "particles/units/heroes/hero_lycan/lycan_shapeshift_cast.vpcf"
	
	-- Create Particle
    -- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetCaster() )
    local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
    ParticleManager:ReleaseParticleIndex(effect_cast)
end


