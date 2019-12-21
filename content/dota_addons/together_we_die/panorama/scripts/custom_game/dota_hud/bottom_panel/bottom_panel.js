"use strict";
/*
    Bottom Panel Panoramanager 0.1.0

    By Almouse

    This bottom panel is intended to be customisable for a
    range of situations. This .js file contains the core logic for
    handling individual components, broken into the following sections:

    - The portrait area contains the unit name and portrait panel
    - The attribute area contains hero and unit stats (str, agi, attack damage...)
    - The buff area contains buff and debuff icons
    - The resources area tracks health, mana, or similar stats
    - The ability area contains the ability tray

    As necessary, individual components will be broken into separate files for
    tracking their behaviour. 

*/

var hud = null;

// ------------- Panels ------------- //
var customTrayPanel = $("#CustomCenterBlock");
var topPart = null;
var bottomPart = null;
var heroStatPanel = null;
var unitStatColumn = null;
var statDivider = null;
var abilityBuffContainer = null;
var unitNameLabel = $("#UnitName");

// Used for debugging to try and prevent some overlaps
// Often doesn't work
var oldContainer = null;

var xpContainer = $("#XPBox");
var abilityBox = null;

var strengthLabel = null;
var agilityLabel = null;
var intLabel = null;
var bonusStrengthLabel = null;
var bonusAgilityLabel = null;
var bonusIntLabel = null;

var damageLabel = null;
var bonusDamageLabel = null;
var damageBox = null;

var armorLabel = null;
var bonusArmorLabel = null;
var armorBox = null;

var movespeedLabel = null;

// ----------- End Panels ----------//

var classNameLog = {};

var heroes = {};
var lastUnit = -1;
var throttlingPanelUpdatesForUnit = null;
var throttlingAbilityTrayUpdatesForUnit = null;

var HEALTH_UPDATE_INTERVAL = 0.03

// Attack/armor names and lookups
// Take a unit and return attack/armor classes;
var ALL_ARMOR_TYPES = [];
var ALL_DAMAGE_TYPES = [];

var DAMAGE_TYPE_LOOKUP = [];
var ARMOR_TYPE_LOOKUP = [];

// ------------------------------------------------------------------ //
// ------------------------ Health and Mana Bars -------------------- //
// ------------------------------------------------------------------ //
/**
 *  Health and mana bars update on a scheduled timer
 *  This is distinct from the updates for the rest of the panel,
 *  since health can change quite rapidly and we want it to look smooth
 *
 */
function ScheduleHealthManaUpdate()
{
    UpdateHealthMana()
    $.Schedule(HEALTH_UPDATE_INTERVAL, ScheduleHealthManaUpdate)
}

function UpdateHealthMana()
{

    var queryUnit = Players.GetLocalPlayerPortraitUnit();

    $("#HealthLabel").text = "" + Entities.GetHealth(queryUnit) + " / " + Entities.GetMaxHealth(queryUnit);
    $("#HealthRegenLabel").text =  ""+ Entities.GetHealthThinkRegen(queryUnit).toFixed(1);
    $("#HealthBarProgress").style.width = ""+Entities.GetHealthPercent(queryUnit).toFixed(1)+"%";

    // Lol, GetManaPercent isn't a function
    var mana =Entities.GetMana(queryUnit);
    var maxMana = Entities.GetMaxMana(queryUnit);
    if (maxMana > 0) {
        $("#ManaContainer").style.visibility = "visible"
        $("#ManaLabel").text = "" + mana + " / " + maxMana;
        $("#ManaRegenLabel").text =  ""+ (Entities.GetManaThinkRegen(queryUnit)).toFixed(1);
        $("#ManaBarProgress").style.width = ""+(100*mana/maxMana).toFixed(1)+"%";
    } else {
        $("#ManaContainer").style.visibility = "collapse";
    }
}

// ------------------------------------------------------------------ //
// ------------------- Buff (and Debuff) Tray ----------------------- //
// ------------------------------------------------------------------ //
// We have to handle two main cases: selecting a new unit
// (in which case we have to fully re-render the tray)
// and when a unit's modifiers change
// (in which case we hopefully only have to delete or create relevant stuff)
var activeModifiers = {}; // Lookup: modifierName: panel

var buffPanels = []; // list of {panel: Panel, isDebuff: bool, active: bool}

// One-time function. Creates placeholder panels for buffs.
// It is (presumably) cheaper to create them at initialization time
// and show/hide them as desired, rather than create/delete them during runtime
function CreateBuffPanels() {

    var buffContainer = customTrayPanel.FindChildTraverse("BuffDebuffContainer");
    var buffPanel;
    for (var i=0; i<10; i++) {
        buffPanel = $.CreatePanel("Panel", buffContainer, "buffPanel"+i)
        buffPanel.BLoadLayoutSnippet( "buff" );
        buffPanels.push({"panel": buffPanel, "active": false, "isDebuff": i>4});
    }

}

// Run when the query unit's status updates
function PartialBuffUpdate()
{
    var unitIndex = Players.GetLocalPlayerPortraitUnit();
    if (!Entities.IsAlive(unitIndex)) {
        return false
    }

    var foundModifiers = [] 

    // Loop over all modifiers the unit has
    for (var i = 0; i < Entities.GetNumBuffs(unitIndex); i++)
    {
        var buff = Entities.GetBuff(unitIndex, i)
        if (!Buffs.IsHidden(unitIndex, buff)) {
            var buffName = Buffs.GetName(unitIndex, buff);
            if (buffName !== "") { // You know what, don't ask
                if (!activeModifiers[buffName]) {
                    CreateBuffIcon(unitIndex, buff);
                }

                UpdateBuffIcon(unitIndex, buff);
                foundModifiers.push(buffName);
            }
        }
    }

    // Check for elements of activeModifiers that are not in foundModifiers
    // These correspond to expired modifiers, and need to be cleaned up
    for (var key in activeModifiers) {
            //$.Msg("bottom_panel.js PartialBuffUpdate | Searching for panel for: "+key);
        if (foundModifiers.indexOf(key) === -1) {
            //$.Msg("bottom_panel.js PartialBuffUpdate | Removing a buff icon for "+key);
            RemoveBuffIcon(unitIndex, key);
        }
    }

}

// "creates" a buff icon (unhide, set styles and images)
function CreateBuffIcon(unitIndex, buff)
{
    var isDebuff = Buffs.IsDebuff(unitIndex, buff );
    var chosenPanel;
    // Find an available buffPanel
    for (var i=0; i<buffPanels.length; i++) {
        if (!buffPanels[i].active && (buffPanels[i].isDebuff === isDebuff)) {
            chosenPanel = buffPanels[i].panel;
            buffPanels[i].active = true;
            break;
        }
    }

    var buffName = Buffs.GetName(unitIndex, buff);

    //$.Msg("bottom_panel.js CreateBuffIcon | Creating a new buff icon for: "+buffName);

    activeModifiers[buffName] = chosenPanel;
    chosenPanel.visible = true;

    // Handle actual icon stuff
    var buffIconPanel = chosenPanel.FindChildTraverse("BuffIcon");
    var itemImage = chosenPanel.FindChildInLayoutFile( "ItemImage" );
    var abilityImage = chosenPanel.FindChildInLayoutFile( "AbilityImage" );
    var buffTexture =  Buffs.GetTexture(unitIndex, buff);
    var itemIdx = buffTexture.indexOf( "item_" );
    if ( itemIdx === -1 )
    {
        if ( itemImage ) itemImage.itemname = "";
        if ( abilityImage ) abilityImage.abilityname = buffTexture;
        chosenPanel.SetHasClass( "item_buff", false );
        chosenPanel.SetHasClass( "ability_buff", true );
    }
    else
    {
        if ( itemImage ) itemImage.itemname = buffTexture;
        if ( abilityImage ) abilityImage.abilityname = "";
        chosenPanel.SetHasClass( "item_buff", true );
        chosenPanel.SetHasClass( "ability_buff", false );
    }

    chosenPanel.SetHasClass("debuff", isDebuff)

    // Hover events
    chosenPanel.SetPanelEvent("onmouseover", function(){   $.DispatchEvent( "DOTAShowBuffTooltip",
        chosenPanel, unitIndex, buff, isDebuff);
    });
    chosenPanel.SetPanelEvent("onmouseout", function(){   $.DispatchEvent( "DOTAHideBuffTooltip",
        chosenPanel);
    });

}

// "updates" a buff icon (set stacks and remaining duration)
function UpdateBuffIcon(unitIndex, buff)
{
    var buffName = Buffs.GetName(unitIndex, buff);
    var buffPanel = activeModifiers[buffName];

    var buffStackLabel = buffPanel.FindChildTraverse("BuffStacks");
    var buffBorderPanel = buffPanel.FindChildTraverse("BuffBorder");

    var stacks = Buffs.GetStackCount(unitIndex, buff)
    buffStackLabel.text = (stacks !== 0) ? stacks : "";

    // Random guess that these are the correct 2 of 5 functions
    var totalDuration = Buffs.GetDuration(unitIndex, buff);
    var remainingDuration = Buffs.GetRemainingTime(unitIndex, buff);

    // Strategy: we want to use CSS transitions to automate the buff expiring
    // we're going to set the current height, and one frame from now set it to 0

    buffBorderPanel.style.transition = "height 0s linear 0s";
    
    /*  Radial clip version */
    var progress = 360-Math.max(0, 360*remainingDuration/totalDuration);
    buffBorderPanel.style.clip = "radial(50% 50%, "+progress+"deg, "+(360-progress)+"deg)";
    $.Schedule(0.01, function() {
        buffBorderPanel.style.transition = "clip "+Math.max(0,remainingDuration)+"s linear 0s";
        buffBorderPanel.style.clip = "radial(50% 50%, 360deg, 0deg)";
    });


    /* Height version
    buffBorderPanel.style.height = ""+(100-100*remainingDuration/totalDuration)+"%";
    $.Msg("Setting height to: "+(100-100*remainingDuration/totalDuration));
    $.Schedule(0.01, function() {
        buffBorderPanel.style.transition = "height "+Math.max(0,remainingDuration)+"s linear 0s";
        buffBorderPanel.style.height = "100%";
    });
    */

}

// "remove" a buff icon (hide and dereference)
function RemoveBuffIcon(unitIndex, modifierName)
{
    var buffPanel = activeModifiers[modifierName];
    activeModifiers[modifierName] = null;
    buffPanel.visible = false;

    for (var i=0; i<buffPanels.length; i++) {
        if (buffPanels[i].panel === buffPanel) {
            buffPanels[i].active = false;
            break;
        }
    }

}

// Run when the query unit changes (i.e. something else is selected)
function FullBuffUpdate()
{
    //$.Msg("bottom_panel.js FullBuffUpdate | Runs!");
    var unitIndex = Players.GetLocalPlayerPortraitUnit();
    if (!Entities.IsAlive(unitIndex)) {
        return false
    }

    // Hide all modifier panels
    activeModifiers = {}
    for (var i=0; i<buffPanels.length; i++) {
        buffPanels[i].active = false;
        buffPanels[i]["panel"].visible = false
    }

    PartialBuffUpdate();

}



// Updates the buff tray for a unit.
// The ability to spend skillpoints is stored in a sibling, so we have to dig for it
function UpdateBuffTray()
{
    var buffContainer = customTrayPanel.FindChildTraverse("BuffDebuffContainer")
    var debuffDrawer = hud.FindChildTraverse("debuffs");
    FullBuffUpdate();

}



// ------------------------------------------------------------------ //
// ------------- Update Panel and related sub-functions ------------- //
// ------------------------------------------------------------------ //

/**
 * Called every time basically anything changes: query unit, stats, abilities...etc
 * Any event that can update the bottom bar will generally call this function
 *
 * This function will recompute the stats, hero stats, and ability tray for the query
 * unit. Additionally, because the dota events are sometimes a bit premature, it will
 * queue up an additional update to be performed after a brief period of time, hopefully after
 * the stats of the query unit are actually updated so we can update the bar.
 *
 * Finally, there is performance improvement tied into this. Dota likes to spam a lot of events sometimes
 * when many things happen at once. For example, leveling up can trigger 4+ UpdatePanel() calls from
 * the various events being triggered. To help reducing the total number of update panels being called,
 * this function will ignore all UpdatePanel() calls that occur during the schedule for the secondary update.
 * *Unless* the query unit that was originally used changes over that period of time.
 *
 * Ex:
       T=0: UpdatePanel() - Updates the bottom panel. Queues another update in 333ms
       T=10ms: UpdatePanel() - Ignored.
       T=20ms: UpdatePanel() - Ignored.
       ...
       T=333ms: The T=0 UpdatePanel() call's schedule triggers. Updating the panel again.
       ...
       T=1000ms: UpdatePanel() - Updates the bottom panel. Queues another update in 333ms
       T=1100ms: UpdatePanel() - [New Query Unit] - Updates the bottom panel. Queues a new update in 333ms.
                                 Previous queue'd action will now be ignored.
       T=1433ms: The T=1100 UpdatePanel() call's schedule triggers. Updating the panel again.
 *
 */
function UpdatePanel(abilityLayoutChanged)
{
    // $.Msg("UpdatePanel()");
    var queryUnit = Players.GetLocalPlayerPortraitUnit();
    var newUnitSelected =  lastUnit != queryUnit;


    if (newUnitSelected) {
        $.GetContextPanel().SetHasClass(Entities.GetUnitName(lastUnit), false)
        $.GetContextPanel().SetHasClass(Entities.GetUnitName(queryUnit), true)
        lastUnit = queryUnit;
        GameEvents.SendCustomGameEventToServer("request_stats", {queryUnit:queryUnit});
    }

    if (
        (newUnitSelected || abilityLayoutChanged)
        && (throttlingAbilityTrayUpdatesForUnit == null || throttlingAbilityTrayUpdatesForUnit != queryUnit)
    ) {
        throttlingAbilityTrayUpdatesForUnit = queryUnit;
        $.Schedule(0.05, function() {
            throttlingAbilityTrayUpdatesForUnit = null;
            UpdateAbilityTray( queryUnit );
        });
    }

    if (
        throttlingPanelUpdatesForUnit != null
        && queryUnit == throttlingPanelUpdatesForUnit
    ) {
         //$.Msg("Ignoring update (Throttling)");
    } else {
        // $.Msg("Performing Update");
        PerformUpdateForQueryUnit(queryUnit);
        throttlingPanelUpdatesForUnit = queryUnit;

        // This fix is dirty but i don't understand it
        $.Schedule(0.33, function() {
            if (throttlingPanelUpdatesForUnit == queryUnit) {
                throttlingPanelUpdatesForUnit = null;
                PerformUpdateForQueryUnit(queryUnit);

                if (newUnitSelected || abilityLayoutChanged) {
                    UpdateAbilityTray( queryUnit );
                }
            } else {
                // $.Msg("Ignoring Delayed Update - Query Changed");
            }
        });
    }

}

// Actually updates the panels using the query unit provided
function PerformUpdateForQueryUnit(queryUnit) {
    UpdateStatsPanel( queryUnit );
    UpdateHeroStatsPanel( queryUnit );
    UpdateBuffTray();

    unitNameLabel.text = "Bottom Panel";
}

function UpdateAbilityTray( queryUnit )
{
    abilityBox.UpdateAbilityList()
}

// Returns a string of the tooltip
function BuildDamageTooltipForUnit(queryUnit, hero)
{

    // Damage
    var damageMin = Entities.GetDamageMin(queryUnit);
    var damageMax = Entities.GetDamageMax(queryUnit);
    var damageBonus = Entities.GetDamageBonus(queryUnit);

    var damageTooltip = vsprintf($.Localize("bottom_panel_attack_damage_tooltip"),
         [damageMin, damageMax])
    if (damageBonus > 0) {
        damageTooltip +=
             " <font color='#1eb980'>+"+
             damageBonus+
             "</font>";
    } else if (damageBonus < 0) {
        damageTooltip +=
             " <font color='#FF00'>"+
             damageBonus+
             "</font>";
    }

    // Attack range
    var attackRange = Entities.GetAttackRange( queryUnit );
    if (attackRange < 130) {attackRange = "-"}
    damageTooltip += vsprintf($.Localize("bottom_panel_attack_range_tooltip"), [attackRange]);

    // Attack Speed
    var attacksPerSecond = Entities.GetAttacksPerSecond(queryUnit);
    if (hero) {
        var panoramaBaseAttackTime = Entities.GetBaseAttackTime(queryUnit);
        attacksPerSecond = (1 / attacksPerSecond / (panoramaBaseAttackTime / hero.baseAttackTime)).toFixed(2);
    } else {
        if (attacksPerSecond > 0){ attacksPerSecond = (1/attacksPerSecond).toFixed(2) }
   }

    var attackBoost = (Math.min(400, Entities.GetIncreasedAttackSpeed(queryUnit)*100)).toFixed(0);

    damageTooltip += vsprintf($.Localize("bottom_panel_attack_speed_tooltip"),
        [ attacksPerSecond ]  )+"s";


    if (attackBoost > 0) {
        damageTooltip +=
             " <font color='#1eb980'>(+"+
             attackBoost+
             "%)</font>";
    } else if (damageBonus < 0) {
        damageTooltip +=
             " (<font color='#FF00'>("+
             attackBoost+
             "%)</font>";
    }

    // Damage type
    var damageType = null;
    if (hero) {
        damageType = hero.attackType;
    } else {
        damageType = DAMAGE_TYPE_LOOKUP[Entities.GetUnitName(queryUnit)];
    }
    if (!damageType) { damageType = "melee1" };
    damageTooltip += $.Localize("bottom_panel_attack_type_"+damageType);


    return damageTooltip
}

function BuildDamageLabelForUnit( queryUnit, hero )
{

    // Damage
    var damageMin = Entities.GetDamageMin(queryUnit);
    var damageMax = Entities.GetDamageMax(queryUnit);
    var damageBonus = Entities.GetDamageBonus(queryUnit);

    damageLabel.text = (((damageMin + damageMax) / 2)).toFixed(0);
    if(damageBonus > 0) {
        bonusDamageLabel.text = "+" + damageBonus;
    } else if (damageBonus < 0) {
        bonusDamageLabel.text = damageBonus
    } else {
        bonusDamageLabel.text = "";
    }

    damageLabel.SetHasClass("Negative", damageBonus < 0);
    // damageLabel.SetHasClass("FullBox", Math.abs(damageBonus < 1 ) );

    damageBox.SetHasClass("Ranged", Entities.GetAttackRange(queryUnit) > 128);
    var noAttack = !Entities.HasAttackCapability(queryUnit)
    damageBox.SetHasClass("NoAttack", noAttack );

    // Redo damage numbers if unit has 'none' damage type
    if (noAttack)
    {
        damageLabel.text = "-";
        bonusDamageLabel.text = "";

        damageBox.SetPanelEvent("onmouseover", function Nothing() {});
        damageBox.SetPanelEvent("onmouseout", function Nothing() {})
    } else {

        damageBox.SetPanelEvent("onmouseover", function ShowToolTip() {
            $.DispatchEvent( "DOTAShowTextTooltip", damageBox, BuildDamageTooltipForUnit(queryUnit, hero));
        });

        damageBox.SetPanelEvent("onmouseout", function HideToolTip() {
            $.DispatchEvent( "DOTAHideTextTooltip", damageBox );
        });
    }
}

function BuildArmorTooltipForUnit(queryUnit, hero)
{

    var armor = Entities.GetPhysicalArmorValue(queryUnit);
    var bonusArmor = Entities.GetBonusPhysicalArmor(queryUnit);

    // Tooltip

    // Damage reduction
    if(armor >= 0) {
        // Positive armor - damage reduction
        var reduction = (0.05 * armor) / (1 + (0.05 * armor)) * 100;
        if(reduction >= 1) {
            reduction = "<font color='#1eb980'>"+reduction.toFixed(0)+"%</font>"; // lol typecasting
        } else {
            reduction = "0%";
        }
    } else {
        // Negative armor - damage amplification
        var reduction = (1-(Math.pow(0.94, -armor)))*100;
        if(reduction >= 1) {
            reduction = "<font color='#ff6859'>-" + reduction.toFixed(0) + "%</font>";
        } else {
            reduction = "0%";
        }
    }

    var armorTooltip = vsprintf($.Localize("bottom_panel_armor_reduction_tooltip"), [ reduction ] );

    // Damage type
    var armorType = null;
    if (hero) {
        armorType = hero.armorType;
    } else {
        armorType = ARMOR_TYPE_LOOKUP[Entities.GetUnitName(queryUnit)];
    }
    if (!armorType) { armorType = "unarmored" };


    armorTooltip += $.Localize("bottom_panel_armor_type_"+armorType);

    return armorTooltip

}

function BuildArmorLabelForUnit(queryUnit, hero)
{

    if(Entities.IsInvulnerable(queryUnit)) {
        armorLabel.text = "-";
        bonusArmorLabel.text = "";
        bonusArmorLabel.SetHasClass("Negative", false);
        armorBox.SetPanelEvent("onmouseover", function ShowToolTip() {
            $.DispatchEvent( "DOTAShowTextTooltip", armorBox, $.Localize("bottom_panel_armor_type_invulnerable"));
        });
        armorBox.SetPanelEvent("onmouseout", function HideToolTip() {
            $.DispatchEvent( "DOTAHideTextTooltip", armorBox );
        });
        for (var type of ALL_ARMOR_TYPES) {
            armorBox.SetHasClass(type, type == "contraption");
        }
    } else {
        // Armor
        var armor = Entities.GetPhysicalArmorValue(queryUnit);
        var bonusArmor = Entities.GetBonusPhysicalArmor(queryUnit);
        armorLabel.text = (armor - bonusArmor).toFixed(0);
        if(bonusArmor == 0) {
            bonusArmorLabel.text = "";
        } else {
            // Don't show .0 unless necessary
            var fixedCount = 1;
            if(Math.floor(bonusArmor) == bonusArmor) {
                fixedCount = 0;
            }

            if(bonusArmor > 0) {
                bonusArmorLabel.text = "+ " + bonusArmor.toFixed(fixedCount);
            } else if (bonusArmor < 0) {
                bonusArmorLabel.text = bonusArmor.toFixed(fixedCount);
            }
        }

        bonusArmorLabel.SetHasClass("Negative", (bonusArmor < 0));

        // Damage type
        var armorType = null;
        if (hero) {
            armorType = hero.armorType;
        } else {
            armorType = ARMOR_TYPE_LOOKUP[Entities.GetUnitName(queryUnit)];
        }
        if (!armorType) { armorType = "unarmored" };

        for (var type of ALL_ARMOR_TYPES)
        {
            armorBox.SetHasClass(type, type == armorType);
        }

        armorBox.SetPanelEvent("onmouseover", function ShowToolTip() {
            $.DispatchEvent( "DOTAShowTextTooltip", armorBox, BuildArmorTooltipForUnit(queryUnit, hero));
        });

        armorBox.SetPanelEvent("onmouseout", function HideToolTip() {
            $.DispatchEvent( "DOTAHideTextTooltip", armorBox );
        });
    }
}
function UpdateStatsPanel( queryUnit )
{
    var hero = heroes[queryUnit];

    BuildDamageLabelForUnit(queryUnit, hero);

    BuildArmorLabelForUnit(queryUnit, hero);

    // Move Speed
    if (Entities.HasMovementCapability(queryUnit)) {
        var moveSpeed = Entities.GetBaseMoveSpeed(queryUnit);
        var moveSpeedModifier = Entities.GetMoveSpeedModifier(queryUnit, moveSpeed);
        var msModifier = FindModifierIndexByName(queryUnit, "modifier_common_movespeed")
        var realMS = moveSpeedModifier
        if (msModifier) {
            var stacks = Buffs.GetStackCount(queryUnit, msModifier)
            if (stacks > 0) { realMS = stacks }
        }
        movespeedLabel.text = realMS.toFixed(0);
        movespeedLabel.SetHasClass("Debuff", (realMS < moveSpeed));
        movespeedLabel.SetHasClass("Buff", (realMS > moveSpeed));
    } else {
        movespeedLabel.text = "-";
    }
}

// Look up table of a modifier name --> "attribute" name
// This will be used in the stat panel to populate attributes
var SPECIAL_BUFF_NAMES = {
    "modifier_intelligence_lua": "intelligence",
    "modifier_agility_lua": "agility",
    "modifier_strength_lua": "strength"
}


function UpdateHeroStatsPanel( queryUnit )
{
    //$.Msg("bottom_panel.js UpdateHeroStatsPanel | Runs!");
    // Separate Code for Hero Units
    if(!Entities.IsHero(queryUnit)) {
        // Hide the hero stat panel but don't shift everything over
        heroStatPanel.style.height = "0%";
        statDivider.style.height = "0%";
        xpContainer.visible = false;
    } else {
        //$.Msg("Showing hero stats panel!");
        heroStatPanel.style.height = "80%";
        statDivider.style.height = "80%";
        xpContainer.visible = true;

        // We're going to loop over all buffs to find stacks of hidden modifiers corresponding to stats
        var stats = {}

        // Loop over all modifiers the unit has
        for (var i = 0; i < Entities.GetNumBuffs(queryUnit); i++)
        {
            var buff = Entities.GetBuff(queryUnit, i)
            if (Buffs.IsHidden(queryUnit, buff)) {
                var buffName = Buffs.GetName(queryUnit, buff);
                //$.Msg("Found modifier: "+buffName);
                if (SPECIAL_BUFF_NAMES[buffName]) {
                    stats[SPECIAL_BUFF_NAMES[buffName]] = Buffs.GetStackCount(queryUnit, buff);
                }
            }
        }

        var baseStrength = (stats.strength || 0) - (stats.bonusStrength || 0);
        var baseAgility = (stats.agility || 0) - (stats.bonusAgility || 0);
        var baseIntelligence = (stats.intelligence || 0) - (stats.bonusIntelligence || 0);

        /*
        $.Msg("bottom_panel.js UpdateHeroStatsPanel | Found Stats:")
        for (var k in stats) {
            $.Msg("Key: "+k+", Value: "+stats[k]);
        }
        */

        // Strength
        strengthLabel.text = baseStrength.toFixed(0);
        if(stats.bonusStrength > 0) {
            bonusStrengthLabel.text = "+" + stats.bonusStrength.toFixed(0);
            strengthLabel.SetHasClass("FullBox", false);
        } else {
            bonusStrengthLabel.text = "";
            strengthLabel.SetHasClass("FullBox", true);
        }

        // Agility
        agilityLabel.text = baseAgility.toFixed(0);
        if(stats.bonusAgility > 0) {
            bonusAgilityLabel.text = "+" + stats.bonusAgility.toFixed(0);
            agilityLabel.SetHasClass("FullBox", false);
        } else {
            bonusAgilityLabel.text = "";
            agilityLabel.SetHasClass("FullBox", true);
        }

        // Intelligence
        intLabel.text = baseIntelligence.toFixed(0);
        if(stats.bonusIntelligence > 0) {
            bonusIntLabel.text = "+" + stats.bonusIntelligence.toFixed(0);
            intLabel.SetHasClass("FullBox", false);
        } else {
            bonusIntLabel.text = "";
            intLabel.SetHasClass("FullBox", true);
        }

        // Experience
        var xpTooltip = vsprintf($.Localize("bottom_panel_xp_tooltip"), [Entities.GetAbilityPoints(queryUnit)] );

        xpContainer.SetPanelEvent("onmouseover", function ShowToolTip() {
            $.DispatchEvent( "DOTAShowTextTooltip", xpContainer, xpTooltip);
        });

        xpContainer.SetPanelEvent("onmouseout", function HideToolTip() {
            $.DispatchEvent( "DOTAHideTextTooltip", xpContainer );
        });

    }


}

// ------------------------------------------------------------------ //
// ----------------- Core DotA hud manipulation --------------------- //
// ------------------------------------------------------------------ //

function CustomiseDotAHud()
{

    var strContainer = $("#StrContainer");
    strContainer.SetPanelEvent("onmouseover", function ShowToolTip() {
        var strTooltip = $.Localize("bottom_panel_str_tooltip");
        var hero = heroes[lastUnit];
        if(hero != null) {
            var bonusHps = hero.strength / 100.0
            strTooltip += vsprintf($.Localize("bottom_panel_str_bonus_tooltip"), [bonusHps]);
        }

        $.DispatchEvent( "DOTAShowTextTooltip", strContainer, strTooltip );
    });
    strContainer.SetPanelEvent("onmouseout", function HideToolTip() {
            $.DispatchEvent("DOTAHideTextTooltip", strContainer)
    });

    var agiContainer = $("#AgiContainer");
    agiContainer.SetPanelEvent("onmouseover", function ShowToolTip() {
        var agiTooltip = $.Localize("bottom_panel_agi_tooltip");
        var hero = heroes[lastUnit];
        if(hero != null) {
            var bonusAtkSpd = hero.agility
            agiTooltip += vsprintf($.Localize("bottom_panel_agi_bonus_tooltip"), [bonusAtkSpd]);
        }

        $.DispatchEvent( "DOTAShowTextTooltip", agiContainer, agiTooltip );
    });
    agiContainer.SetPanelEvent("onmouseout", function HideToolTip() {
            $.DispatchEvent("DOTAHideTextTooltip", agiContainer)
    });

    var intContainer = $("#IntContainer");

    // --------------------------------------------------------------------//
    // ------------ Assign our panel names (hopefully correctly) --------- //
    // --------------------------------------------------------------------//

    // (Re)assign children of the custom tray - this is necessary after moving into the dota hud
    // $ references will no longer work
    topPart = customTrayPanel.FindChildTraverse("TopPart");
    bottomPart = customTrayPanel.FindChildTraverse("BottomPart");
    heroStatPanel = customTrayPanel.FindChildTraverse("HeroStatColumn");
    unitStatColumn = customTrayPanel.FindChildTraverse("UnitStatColumn");
    statDivider = customTrayPanel.FindChildTraverse("StatDivider");
    abilityBuffContainer = customTrayPanel.FindChildTraverse("AbilityBuffContainer");

    strengthLabel = customTrayPanel.FindChildTraverse("StrLabel");
    agilityLabel = customTrayPanel.FindChildTraverse("AgiLabel");
    intLabel = customTrayPanel.FindChildTraverse("IntLabel");
    bonusStrengthLabel = customTrayPanel.FindChildTraverse("StrSecondaryLabel");
    bonusAgilityLabel = customTrayPanel.FindChildTraverse("AgiSecondaryLabel");
    bonusIntLabel = customTrayPanel.FindChildTraverse("IntSecondaryLabel");

    damageLabel = customTrayPanel.FindChildTraverse("AttackLabel");
    bonusDamageLabel = customTrayPanel.FindChildTraverse("AttackSecondaryLabel");
    damageBox = customTrayPanel.FindChildTraverse("AttackContainer");
    armorLabel = customTrayPanel.FindChildTraverse("ArmorLabel");
    armorBox = customTrayPanel.FindChildTraverse("ArmorContainer");
    bonusArmorLabel = customTrayPanel.FindChildTraverse("ArmorSecondaryLabel");
    movespeedLabel = customTrayPanel.FindChildTraverse("MoveLabel");

    // -------------------- Jiggle XP Border ------------ //
    $("#XPShadow").SetParent(xpContainer);

    // --------------------------------------------------------------------//
    // ------------------------ Load Ability Tray ------------------------ //
    // --------------------------------------------------------------------//

    abilityBox = customTrayPanel.FindChildTraverse("abilityBox");
    if (!abilityBox) {
        abilityBox = $.CreatePanel("Panel", customTrayPanel, "abilityBox")
        abilityBox.BLoadLayout("file://{resources}/layout/custom_game/dota_hud/bottom_panel/ability_tray.xml", false, false)
        abilityBox.SetParent(abilityBuffContainer);
    }
}

// ------------------------------------------------------------------ //
// ------------------------ Utility functions ----------------------- //
// ------------------------------------------------------------------ //

// I don't know why this isn't a builtin
// returns false if the unit does not exist or has no buff of name name
// else returns the buffIndex, a handle to the index
function FindModifierIndexByName(unitIndex, name)
{
    //$.Msg("progress_bars FindModifierIndexByName || Searching for: "+name)
    // Check the unit exists
    if (!Entities.IsAlive(unitIndex)) {
        return false
    }

    for (var i = 0; i < Entities.GetNumBuffs(unitIndex); i++)
    {
        var buffName = Buffs.GetName(unitIndex, Entities.GetBuff(unitIndex, i))

        if (buffName == name)
        {
            //$.Msg("I'm returning true!");
            return Entities.GetBuff(unitIndex, i)
        }
    }

    return false

}

// Util, check if an object is empty
function isEmpty(obj){
    for (var key in obj)
    {
        if(obj.hasOwnProperty(key))
        {
            return false
        }
    }
    return true
}

// Try to find a panel, and if it doesn't exist, then create it
// Dota gets angry when we recompile things using CreatePanel, so
// this helps us out a little
function CreateOrReferencePanel(panelType, parent, panelId)
{
    var hud = $.GetContextPanel().GetParent();
    for(var i = 0; i < 100; i++) {
        if(hud.id != "Hud") {
            hud = hud.GetParent();
        } else {
            break;
        }
    }

    var testPanel = hud.FindChildTraverse(panelId);
    if (testPanel) return testPanel
    else return $.CreatePanel(panelType, parent, panelId)


}

function HookIntoDotAHud()
{
    $.Msg("Bottom Panel | Configuring default dota HUD");
    hud = $.GetContextPanel().GetParent();
    for(var i = 0; i < 100; i++) {
        if(hud.id != "Hud") {
            hud = hud.GetParent();
        } else {
            break;
        }
    }

    oldContainer = hud.FindChildTraverse("CustomCenterBlock");
}

// ------------------------------------------------------------------ //
// ---------------------------- DotA Events ------------------------- //
// ------------------------------------------------------------------ //


// Called when the portrait unit's modifiers change (usually updates speed or armor or something)
function UnitModifiersChanged() {
    // $.Msg("UnitModifiersChanged()");
    var queryUnit = Players.GetLocalPlayerPortraitUnit();
    if(queryUnit == lastUnit) {
        UpdatePanel();
    }
}

function OnQueryUnitStatsUpdated() {
    var queryUnit = Players.GetLocalPlayerPortraitUnit();
    if(queryUnit == lastUnit) {
        UpdatePanel();
    }
}

// ------------------------------------------------------------------ //
// ------------------------ Onetime functions  ---------------------- //
// ------------------------------------------------------------------ //

(function()
{
    //$.RegisterForUnhandledEvent( "DOTAAbility_LearnModeToggled", OnAbilityLearnModeToggled);

    HookIntoDotAHud();
    CustomiseDotAHud();

    GameEvents.Subscribe( "dota_portrait_ability_layout_changed", function() {
        // Ability Layout change events are special: we will force the ability
        // layout update code (which normally only executes if the query unit changes)
        UpdatePanel(true);
    });
    GameEvents.Subscribe( "dota_player_update_selected_unit", UpdatePanel );
    GameEvents.Subscribe( "dota_player_update_query_unit", UpdatePanel );
    GameEvents.Subscribe( "dota_portrait_unit_modifiers_changed", UpdateBuffTray );
    GameEvents.Subscribe( "dota_ability_changed", UpdatePanel );
    GameEvents.Subscribe( "dota_portrait_unit_stats_changed", UpdatePanel );

    $.Schedule(1, function(){ UpdatePanel() });

    ScheduleHealthManaUpdate();
    CreateBuffPanels();


})();

