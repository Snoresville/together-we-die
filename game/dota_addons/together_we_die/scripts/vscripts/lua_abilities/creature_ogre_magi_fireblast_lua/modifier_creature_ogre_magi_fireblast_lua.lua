modifier_creature_ogre_magi_fireblast_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_creature_ogre_magi_fireblast_lua:IsHidden()
	return false
end

function modifier_creature_ogre_magi_fireblast_lua:IsDebuff()
	return true
end

function modifier_creature_ogre_magi_fireblast_lua:IsPurgable()
	return false
end

function modifier_creature_ogre_magi_fireblast_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_creature_ogre_magi_fireblast_lua:OnCreated( kv )
	-- references
	self.mana_loss = self:GetAbility():GetSpecialValueFor( "mana_loss" )
end

function modifier_creature_ogre_magi_fireblast_lua:OnRefresh( kv )
	-- references
	self.mana_loss = self:GetAbility():GetSpecialValueFor( "mana_loss" )
end

function modifier_creature_ogre_magi_fireblast_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_creature_ogre_magi_fireblast_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}

	return funcs
end
function modifier_creature_ogre_magi_fireblast_lua:GetModifierConstantManaRegen()
	return self.mana_loss
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_creature_ogre_magi_fireblast_lua:GetEffectName()
	return "particles/units/heroes/hero_keeper_of_the_light/keeper_mana_leak.vpcf"
end

function modifier_creature_ogre_magi_fireblast_lua:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
