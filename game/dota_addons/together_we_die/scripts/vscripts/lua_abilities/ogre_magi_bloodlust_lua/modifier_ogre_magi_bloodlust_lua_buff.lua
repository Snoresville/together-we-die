-- Created by Elfansoer
--[[
Ability checklist (erase if done/checked):
- Scepter Upgrade
- Break behavior
- Linken/Reflect behavior
- Spell Immune/Invulnerable/Invisible behavior
- Illusion behavior
- Stolen behavior
]]
--------------------------------------------------------------------------------
modifier_ogre_magi_bloodlust_lua_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ogre_magi_bloodlust_lua_buff:IsHidden()
	return false
end

function modifier_ogre_magi_bloodlust_lua_buff:IsDebuff()
	return false
end

function modifier_ogre_magi_bloodlust_lua_buff:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_ogre_magi_bloodlust_lua_buff:OnCreated( kv )
	-- references
	self.model_scale = self:GetAbility():GetSpecialValueFor( "modelscale" )
	self.ms_bonus = self:GetAbility():GetSpecialValueFor( "bonus_movement_speed" )
	self.as_bonus = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )
	self.int_multiplier = self:GetAbility():GetSpecialValueFor( "int_multiplier" )
	self.damage_bonus = self:GetCaster():GetIntellect() * self.int_multiplier
	self.as_self = self:GetAbility():GetSpecialValueFor( "self_bonus" )

	if self:GetParent()==self:GetCaster() then
		self.as_bonus = self.as_self
	end

	if not IsServer() then return end

	-- play effects
	local sound_cast = "Hero_OgreMagi.Bloodlust.Target"
	EmitSoundOn( sound_cast, self:GetParent() )

	local sound_player = "Hero_OgreMagi.Bloodlust.Target.FP"
	EmitSoundOnClient( sound_player, self:GetParent():GetPlayerOwner() )
end

function modifier_ogre_magi_bloodlust_lua_buff:OnRefresh( kv )
	-- do what oncreated do
	self:OnCreated( kv )
end

function modifier_ogre_magi_bloodlust_lua_buff:OnRemoved()
end

function modifier_ogre_magi_bloodlust_lua_buff:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_ogre_magi_bloodlust_lua_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}

	return funcs
end

function modifier_ogre_magi_bloodlust_lua_buff:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_bonus
end
function modifier_ogre_magi_bloodlust_lua_buff:GetModifierAttackSpeedBonus_Constant()
	return self.as_bonus
end

function modifier_ogre_magi_bloodlust_lua_buff:GetModifierModelScale()
	return self.model_scale
end

function modifier_ogre_magi_bloodlust_lua_buff:GetModifierPreAttack_BonusDamage( params )
	return self.damage_bonus
end


--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_ogre_magi_bloodlust_lua_buff:GetEffectName()
	return "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf"
end

function modifier_ogre_magi_bloodlust_lua_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end