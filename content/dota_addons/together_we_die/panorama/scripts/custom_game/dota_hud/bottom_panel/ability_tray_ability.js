"use strict";
/*

    This is the class definition for abilities in the ability bar.
    In general, these abilities are *not* self-sufficient: they must be
    prompted to update periodically by the ability_tray.js file.
    This is ostensibly for performance reasons.

    The file has two main components, although they ultimately serve the same
    purpose:
        - The class definition defines the properties of an ability
        - Amendments to the ability "prototype" add the needed function calls
            - This gives a miniscule performance improvement over defining these
                functions in the class definition

*/

function AbilitySlot(parent, index) {
    // Create Panel
    this.panel = $.CreatePanel("Panel", parent, "Ability"+index);
    this.panel.BLoadLayoutSnippet("action_bar_ability");

    this.abilityButton = this.panel.FindChildTraverse("AbilityButton");
    this.levelUpPanel = this.panel.FindChildTraverse("LevelUpTab");


    // Instantiate Variables
    this.slotIndex = index;
    this.queryUnit = null;
    this.abilityName = null;
    this.abilityIndex = null;
    this.manaCost = 0;
    this.enabled = false;

    // ------- Set up events

    // Level up button
    this.levelUpPanel.SetPanelEvent("onmouseover",
        this.LevelUpMouseOver.bind(this)
    );
    this.levelUpPanel.SetPanelEvent("onmouseout",
        this.LevelUpMouseOut.bind(this)
    );
    this.levelUpPanel.SetPanelEvent("onactivate",
        this.LevelUpActivate.bind(this)
    );

    // Ability button
    this.abilityButton.SetPanelEvent("onactivate",
        this.AbilityButtonActivate.bind(this)
    );
    this.abilityButton.SetPanelEvent("oncontextmenu",
        this.AbilityButtonOnContext.bind(this)
    );
    this.abilityButton.SetPanelEvent("onmouseover",
        this.AbilityButtonMouseOver.bind(this)
    );
    this.abilityButton.SetPanelEvent("onmouseout",
        this.AbilityButtonMouseOut.bind(this)
    );

}

// -------- Core

// Set the ability that is being stored in this slot
AbilitySlot.prototype.SetAbility = function(abilityIndex) {
    this.abilityIndex = abilityIndex;
    this.panel.SetHasClass( "no_ability", ( abilityIndex == -1 ) );
    this.manaCost = Abilities.GetManaCost( this.abilityIndex );
    this.abilityName = Abilities.GetAbilityName( this.abilityIndex );
    this.queryUnit = Players.GetLocalPlayerPortraitUnit();

    var unitMana = Entities.GetMana( this.queryUnit );
    var hotkey = Abilities.GetKeybind( this.abilityIndex, this.queryUnit );

    this.panel.FindChildTraverse("AbilityImage").abilityname = this.abilityName;
    this.panel.FindChildTraverse("AbilityImage").contextEntityIndex = abilityIndex;
    this.panel.SetHasClass( "is_passive", Abilities.IsPassive(this.abilityIndex) );
    this.panel.SetHasClass( "is_active", !Abilities.IsPassive(this.abilityIndex) );
    this.panel.SetHasClass( "no_mana_cost", ( 0 == this.manaCost ) );
    this.panel.SetHasClass( "no_hotkey", (hotkey == "" || !Entities.IsControllableByPlayer(queryUnit, Game.GetLocalPlayerID() ) ))
    this.panel.FindChildTraverse("HotkeyText").text = hotkey;
    this.panel.FindChildTraverse("ManaCost").text = this.manaCost;
    // TODO: Gold costs?
    this.panel.FindChildTraverse("GoldCost").text = "";

    var abilityLabel = this.panel.FindChildTraverse("AbilityNameLabel");
    abilityLabel.text = $.Localize("DOTA_Tooltip_Ability_"+this.abilityName);

    // Run the other update functions to fill in everything else
    if (abilityIndex) {
        this.enabled = true;
    } else {
        this.enabled = false;
    }

    this.SlowUpdate();
    this.FastUpdate();

}


// "Slow" update, for things that rarely change
AbilitySlot.prototype.SlowUpdate = function() {
    if (!this.enabled)
    {
        return false
    }

    // --- Mana cost (some abilities might grant a discount)
    this.manaCost = Abilities.GetManaCost( this.abilityIndex );
    this.panel.FindChildTraverse("ManaCost").text = this.manaCost;

    // --- Level up tabs
    this.panel.SetHasClass( "can_level",
        (Abilities.CanAbilityBeUpgraded(this.abilityIndex) == AbilityLearnResult_t.ABILITY_CAN_BE_UPGRADED) &&
        (Entities.GetAbilityPoints(this.queryUnit) > 0)
    );
    var noLevel =( 0 == Abilities.GetLevel( this.abilityIndex ) );
    var isCastable = !Abilities.IsPassive( this.abilityIndex ) && !noLevel;
    this.panel.SetHasClass( "no_level", noLevel );
    this.abilityButton.enabled = ( isCastable );

    // --- Enable or disable cooldown indicator
    if ( Abilities.IsCooldownReady( this.abilityIndex ) )
    {
        this.panel.SetHasClass( "cooldown_ready", true );
        this.panel.SetHasClass( "in_cooldown", false );
    }
    else
    {
        // If the panel was previously not in cooldown, then it recently entered cooldown!
        // In this case, we have to jiggle the cooldown timer a little
        if (this.panel.BHasClass("in_cooldown")) {
            this.panel.FindChildTraverse("CooldownOverlay").style.transition =  "width 0s linear 0s";
            $.Schedule(0.06, function() {
                this.panel.FindChildTraverse("CooldownOverlay").style.transition =  "width 0.5s linear 0s";
            }.bind(this))
        }
        this.panel.SetHasClass( "cooldown_ready", false );
        this.panel.SetHasClass( "in_cooldown", true );
        var cooldownLength = Abilities.GetCooldownLength( this.abilityIndex );
        var cooldownRemaining = Abilities.GetCooldownTimeRemaining( this.abilityIndex );
        var cooldownPercent = Math.ceil( 100 * cooldownRemaining / cooldownLength );
        this.panel.FindChildTraverse("CooldownTimer").text = Math.ceil( cooldownRemaining );
        this.panel.FindChildTraverse("CooldownOverlay" ).style.width = cooldownPercent+"%";
    }

}

// "Fast" update, for things that often change
AbilitySlot.prototype.FastUpdate = function() {
    if (!this.enabled)
    {
        return false
    }

    var unitMana = Entities.GetMana( this.queryUnit );

    this.panel.SetHasClass( "insufficient_mana", ( this.manaCost > unitMana ) );
    this.panel.SetHasClass( "auto_cast_enabled", Abilities.GetAutoCastState(this.abilityIndex) );
    this.panel.SetHasClass( "toggle_enabled", Abilities.GetToggleState(this.abilityIndex) );
    this.panel.SetHasClass( "is_active", ( this.abilityIndex == Abilities.GetLocalPlayerActiveAbility() ) );
    
}


// -------- Ability events
AbilitySlot.prototype.AbilityButtonActivate = function() {
    Abilities.ExecuteAbility( this.abilityIndex, this.queryUnit, false );
}

AbilitySlot.prototype.AbilityButtonOnContext = function() {
    if ( Abilities.IsAutocast( this.abilityIndex ) )
    {
        Game.PrepareUnitOrders( {
            OrderType: dotaunitorder_t.DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO,
            AbilityIndex: this.abilityIndex
        } );
    }
}

AbilitySlot.prototype.AbilityButtonMouseOver = function() {
    $.DispatchEvent( "DOTAShowAbilityTooltipForEntityIndex",
        this.abilityButton, this.abilityName, this.queryUnit
    );
}

AbilitySlot.prototype.AbilityButtonMouseOut = function() {
    $.DispatchEvent( "DOTAHideAbilityTooltip",
        this.abilityButton
    );
}

// -------- Level up button events
AbilitySlot.prototype.LevelUpMouseOver = function() {
    $.DispatchEvent( "DOTAShowAbilityTooltipForEntityIndex",
        this.levelUpPanel, this.abilityName, this.queryUnit 
    )
}

AbilitySlot.prototype.LevelUpMouseOut = function() {
    $.DispatchEvent( "DOTAHideAbilityTooltip",
        this.levelUpPanel);
}

AbilitySlot.prototype.LevelUpActivate = function() {
    Abilities.AttemptToUpgrade(this.abilityIndex);
}
