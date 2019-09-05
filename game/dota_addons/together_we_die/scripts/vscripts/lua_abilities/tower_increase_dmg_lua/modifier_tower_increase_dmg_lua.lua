modifier_tower_increase_dmg_lua = class({})

--------------------------------------------------------------------------------

function modifier_tower_increase_dmg_lua:IsHidden()
	return true
end

function modifier_tower_increase_dmg_lua:IsDebuff()
	return false
end

function modifier_tower_increase_dmg_lua:IsPurgable()
	return false
end
--------------------------------------------------------------------------------

function modifier_tower_increase_dmg_lua:OnCreated( kv )
	if IsServer() then
		-- get reference
		self.damage_per_stack = self:GetAbility():GetSpecialValueFor("damage_per_stack")
		self.bonus_reset_time = self:GetAbility():GetSpecialValueFor("bonus_reset_time")
	end
end

function modifier_tower_increase_dmg_lua:OnRefresh( kv )
	if IsServer() then
		-- get reference
		self.damage_per_stack = self:GetAbility():GetSpecialValueFor("damage_per_stack")
		self.bonus_reset_time = self:GetAbility():GetSpecialValueFor("bonus_reset_time")
	end
end
--------------------------------------------------------------------------------

function modifier_tower_increase_dmg_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_tower_increase_dmg_lua:GetModifierProcAttack_BonusDamage_Pure( params )
	if IsServer() then
		-- get target
		local target = params.target if target==nil then target = params.unit end
		if target:GetTeamNumber()==self:GetParent():GetTeamNumber() then
			return 0
		end

		-- get modifier stack
		local stack = 0
		local modifier = target:FindModifierByNameAndCaster("modifier_tower_increase_dmg_debuff_lua", self:GetAbility():GetCaster())

		-- add stack if not
		if modifier==nil then
			-- if does not have break
			if not self:GetParent():PassivesDisabled() then
				-- determine duration if roshan/not
				local _duration = self.bonus_reset_time

				-- add modifier
				target:AddNewModifier(
					self:GetAbility():GetCaster(),
					self:GetAbility(),
					"modifier_tower_increase_dmg_debuff_lua",
					{ duration = _duration }
				)

				-- get stack number
				stack = 1
			end
		else
			-- increase stack
			modifier:IncrementStackCount()
			modifier:ForceRefresh()

			-- get stack number
			stack = modifier:GetStackCount()
		end

		-- return damage bonus
		return stack * self.damage_per_stack
	end
end
