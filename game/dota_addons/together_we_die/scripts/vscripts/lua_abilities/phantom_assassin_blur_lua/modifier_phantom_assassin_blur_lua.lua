modifier_phantom_assassin_blur_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_phantom_assassin_blur_lua:IsHidden()
	-- dynamic
	-- if IsServer() then
		return not (self.blurOn and (not self:GetParent():PassivesDisabled()))
	-- end
end

function modifier_phantom_assassin_blur_lua:IsDebuff()
	return false
end

function modifier_phantom_assassin_blur_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_phantom_assassin_blur_lua:OnCreated( kv )
	-- references
	self.bonus_evasion = self:GetAbility():GetSpecialValueFor( "bonus_evasion" )
	self.agi_multiplier = self:GetAbility():GetSpecialValueFor( "agi_multiplier" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.max_evasion = 100
	self.interval = 0.5

	self.blurOn = true

	-- Start interval
	self:StartIntervalThink( self.interval )
	self:OnIntervalThink()
end

function modifier_phantom_assassin_blur_lua:OnRefresh( kv )
	-- references
	self.bonus_evasion = self:GetAbility():GetSpecialValueFor( "bonus_evasion" )
	self.agi_multiplier = self:GetAbility():GetSpecialValueFor( "agi_multiplier" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
end

function modifier_phantom_assassin_blur_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_phantom_assassin_blur_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EVASION_CONSTANT,
	}

	return funcs
end

function modifier_phantom_assassin_blur_lua:GetModifierEvasion_Constant()
	if not self:GetParent():PassivesDisabled() then
		return math.min(self.bonus_evasion + math.floor(self:GetParent():GetAgility() * self.agi_multiplier), self.max_evasion)
	end
end
--------------------------------------------------------------------------------
-- Status Effects
function modifier_phantom_assassin_blur_lua:CheckState()
	local state = {
		[MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = (self.blurOn and (not self:GetParent():PassivesDisabled())),
	}

	return state
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_phantom_assassin_blur_lua:OnIntervalThink()
	if IsServer() then
		-- Hero search flag based on detecting or undetecting
		local flag = 0
		if self.blurOn then
			flag = DOTA_UNIT_TARGET_FLAG_NO_INVIS
		else
			flag = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE
		end

		-- Find Enemy Heroes in Radius
		local enemies = FindUnitsInRadius(
			self:GetParent():GetTeamNumber(),	-- int, your team number
			self:GetParent():GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO,	-- int, type filter
			flag,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)

		-- Flip if detected
		if (self.blurOn) == (#enemies>0) then
			self.blurOn = (not self.blurOn)
		end
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_phantom_assassin_blur_lua:GetEffectName()
	return "particles/units/heroes/hero_phantom_assassin/phantom_assassin_blur.vpcf"
end

function modifier_phantom_assassin_blur_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
