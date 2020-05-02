var customSpellsMenuPanel = $("#SpellsMenuContents");
var openSpellsMenu = $("#SpellsMenuOpen");

var heroes = [
    [
        {
            "name_id": "npc_dota_hero_abaddon"
        },
        {
            "name_id": "npc_dota_hero_alchemist"
        },
        {
            "name_id": "npc_dota_hero_axe"
        },
        {
            "name_id": "npc_dota_hero_bristleback"
        },
        {
            "name_id": "npc_dota_hero_centaur"
        },
        {
            "name_id": "npc_dota_hero_doom_bringer"
        },
        {
            "name_id": "npc_dota_hero_dragon_knight"
        },
        {
            "name_id": "npc_dota_hero_earthshaker"
        },
        {
            "name_id": "npc_dota_hero_huskar"
        },
        {
            "name_id": "npc_dota_hero_legion_commander"
        },
        {
            "name_id": "npc_dota_hero_life_stealer"
        },
        {
            "name_id": "npc_dota_hero_mars"
        },
        {
            "name_id": "npc_dota_hero_omniknight"
        },
        {
            "name_id": "npc_dota_hero_pudge"
        },
        {
            "name_id": "npc_dota_hero_sand_king"
        },
        {
            "name_id": "npc_dota_hero_slardar"
        },
        {
            "name_id": "npc_dota_hero_snapfire"
        },
        {
            "name_id": "npc_dota_hero_sven"
        },
        {
            "name_id": "npc_dota_hero_shredder"
        },
        {
            "name_id": "npc_dota_hero_skeleton_king"
        },
    ],
    [
        {
            "name_id": "npc_dota_hero_antimage",
        },
        {
            "name_id": "npc_dota_hero_riki",
        },
    ],
    [],
];

var spells = {
    "npc_dota_hero_abaddon": [
        {
            "spell_id": "abaddon_mist_coil_lua",
            "cost": 1
        },
        {
            "spell_id": "abaddon_aphotic_shield_lua",
            "cost": 1
        },
        {
            "spell_id": "abaddon_borrow_time_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_alchemist": [
        {
            "spell_id": "alchemist_acid_spray_lua",
            "cost": 1
        },
        {
            "spell_id": "alchemist_unstable_concoction_lua",
            "cost": 1
        },
        {
            "spell_id": "alchemist_greevils_greed_lua",
            "cost": 1
        },
        {
            "spell_id": "alchemist_chemical_rage_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_axe": [
        {
            "spell_id": "axe_berserkers_call_lua",
            "cost": 1
        },
        {
            "spell_id": "axe_counter_helix_lua",
            "cost": 1
        },
        {
            "spell_id": "axe_culling_blade_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_bristleback": [
        {
            "spell_id": "bristleback_viscous_nasal_goo_lua",
            "cost": 1
        },
        {
            "spell_id": "bristleback_quill_spray_lua",
            "cost": 1
        },
        {
            "spell_id": "bristleback_bristleback_lua",
            "cost": 1
        },
        {
            "spell_id": "bristleback_warpath_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_centaur": [
        {
            "spell_id": "centaur_warrunner_hoof_stomp_lua",
            "cost": 1
        },
        {
            "spell_id": "centaur_warrunner_double_edge_lua",
            "cost": 1
        },
        {
            "spell_id": "centaur_warrunner_return_lua",
            "cost": 1
        },
        {
            "spell_id": "centaur_warrunner_stampede_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_doom_bringer": [
        {
            "spell_id": "doom_devour_lua",
            "cost": 1
        },
        {
            "spell_id": "doom_infernal_blade_lua",
            "cost": 1
        },
        {
            "spell_id": "doom_scorched_earth_lua",
            "cost": 1
        },
        {
            "spell_id": "doom_doom_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_dragon_knight": [
        {
            "spell_id": "dragon_knight_breathe_fire_lua",
            "cost": 1
        },
        {
            "spell_id": "dragon_knight_dragon_tail_lua",
            "cost": 1
        },
        {
            "spell_id": "dragon_knight_dragon_blood_lua",
            "cost": 1
        },
        {
            "spell_id": "dragon_knight_elder_dragon_form_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_earthshaker": [
        {
            "spell_id": "earthshaker_fissure_lua",
            "cost": 1
        },
        {
            "spell_id": "earthshaker_aftershock_lua",
            "cost": 1
        },
        {
            "spell_id": "earthshaker_echo_slam_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_huskar": [
        {
            "spell_id": "huskar_inner_vitality_lua",
            "cost": 1
        },
        {
            "spell_id": "huskar_burning_spear_lua",
            "cost": 1
        },
        {
            "spell_id": "huskar_berserkers_blood_lua",
            "cost": 1
        },
        {
            "spell_id": "huskar_life_break_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_legion_commander": [
        {
            "spell_id": "legion_commander_overwhelming_odds_lua",
            "cost": 1
        },
        {
            "spell_id": "legion_commander_press_the_attack_lua",
            "cost": 1
        },
        {
            "spell_id": "legion_commander_moment_of_courage_lua",
            "cost": 1
        },
        {
            "spell_id": "legion_commander_duel_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_life_stealer": [
        {
            "spell_id": "lifestealer_rage_lua",
            "cost": 1
        },
        {
            "spell_id": "lifestealer_feast_lua",
            "cost": 1
        },
        {
            "spell_id": "lifestealer_open_wounds_lua",
            "cost": 1
        },
    ],
    "npc_dota_hero_mars": [
        {
            "spell_id": "mars_spear_of_mars_lua",
            "cost": 1
        },
        {
            "spell_id": "mars_gods_rebuke_lua",
            "cost": 1
        },
        {
            "spell_id": "mars_arena_of_blood_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_omniknight": [
        {
            "spell_id": "omniknight_purification_lua",
            "cost": 1
        },
        {
            "spell_id": "omniknight_repel_lua",
            "cost": 1
        },
        {
            "spell_id": "omniknight_degen_aura_lua",
            "cost": 1
        },
        {
            "spell_id": "omniknight_guardian_angel_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_pudge": [
        {
            "spell_id": "pudge_meat_hook_lua",
            "cost": 1
        },
        {
            "spell_id": "pudge_rot_lua",
            "cost": 1
        },
        {
            "spell_id": "pudge_flesh_heap_lua",
            "cost": 1
        },
        {
            "spell_id": "pudge_dismember_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_sand_king": [
        {
            "spell_id": "sand_king_burrowstrike_lua",
            "cost": 1
        },
        {
            "spell_id": "sand_king_sand_storm_lua",
            "cost": 1
        },
        {
            "spell_id": "sand_king_caustic_finale_lua",
            "cost": 1
        },
        {
            "spell_id": "sand_king_epicenter_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_slardar": [
        {
            "spell_id": "slardar_guardian_sprint_lua",
            "cost": 1
        },
        {
            "spell_id": "slardar_slithereen_crush_lua",
            "cost": 1
        },
        {
            "spell_id": "slardar_bash_of_the_deep_lua",
            "cost": 1
        },
        {
            "spell_id": "slardar_corrosive_haze_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_snapfire": [
        {
            "spell_id": "snapfire_scatterblast_lua",
            "cost": 1
        },
        {
            "spell_id": "snapfire_firesnap_cookie_lua",
            "cost": 1
        },
        {
            "spell_id": "snapfire_lil_shredder_lua",
            "cost": 1
        },
        {
            "spell_id": "snapfire_mortimer_kisses_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_sven": [
        {
            "spell_id": "sven_storm_bolt_lua",
            "cost": 1
        },
        {
            "spell_id": "sven_great_cleave_lua",
            "cost": 1
        },
        {
            "spell_id": "sven_warcry_lua",
            "cost": 1
        },
        {
            "spell_id": "sven_gods_strength_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_shredder": [
        {
            "spell_id": "timbersaw_whirling_death_lua",
            "cost": 1
        },
        {
            "spell_id": "timbersaw_timber_chain_lua",
            "cost": 1
        },
        {
            "spell_id": "timbersaw_reactive_armor_lua",
            "cost": 1
        },
        {
            "spell_id": "timbersaw_chakram_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_skeleton_king": [
        {
            "spell_id": "wraith_king_wraithfire_blast_lua",
            "cost": 1
        },
        {
            "spell_id": "wraith_king_vampiric_aura_lua",
            "cost": 1
        },
        {
            "spell_id": "wraith_king_mortal_strike_lua",
            "cost": 1
        },
        {
            "spell_id": "wraith_king_reincarnation_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_antimage": [
        {
            "spell_id": "antimage_mana_break_lua",
            "cost": 1
        },
        {
            "spell_id": "antimage_blink_lua",
            "cost": 1
        },
        {
            "spell_id": "antimage_spell_shield_lua",
            "cost": 1
        },
        {
            "spell_id": "antimage_mana_void_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_riki": [
        {
            "spell_id": "riki_permanent_invisibility_lua",
            "cost": 1
        }
    ],
};


function CreateHeroesListingForAll() {
    var heroesContainer;

    // Divide them into categories of Strength, Agility and Intelligence
    var heroPanel;
    for (var category = 0; category < heroes.length; category++) {
        if (category === 0) {
            // Strength
            heroesContainer = customSpellsMenuPanel.FindChildTraverse("SpellsMenuHeroesStrengthBlock");
        } else if (category === 1) {
            // Agility
            heroesContainer = customSpellsMenuPanel.FindChildTraverse("SpellsMenuHeroesAgilityBlock");
        } else if (category === 2) {
            // Intelligence
            heroesContainer = customSpellsMenuPanel.FindChildTraverse("SpellsMenuHeroesIntelligenceBlock");
        }

        for (var i = 0; i < heroes[category].length; i++) {
            heroPanel = $.CreatePanel("Panel", heroesContainer, "heroPanel" + i);
            CreateHeroesListing(heroPanel, heroes[category][i]);
        }
    }
}

function CreateHeroesListing(heroPanel, hero) {
    heroPanel.BLoadLayoutSnippet("hero");

    // Set the picture to display
    var heroData = hero.name_id;
    var image = heroPanel.FindChildInLayoutFile("HeroPictureImage");
    image.heroname = heroData;
    // Set the onactivate
    var heroButton = heroPanel.FindChildInLayoutFile("HeroPanelButton");
    heroButton.SetPanelEvent("onactivate", Function("OpenSpellsListForHero(\"" + heroData + "\")"));
}

function CreateSpellsListingForHero(heroID) {
    var spellsContainer = customSpellsMenuPanel.FindChildTraverse("SpellsMenuSpellsBlock");
    // Clear children
    CloseSpellsListingForHero();

    var heroSpells = spells[heroID];
    var spellPanel;
    for (var i = 0; i < heroSpells.length; i++) {
        var individualHeroSpell = heroSpells[i];
        spellPanel = $.CreatePanel("Panel", spellsContainer, "spellPanel" + i);
        spellPanel.BLoadLayoutSnippet("spell");

        var image = spellPanel.FindChildInLayoutFile("SingleSpellPictureImage");
        image.abilityname = individualHeroSpell.spell_id;
        var spellCost = spellPanel.FindChildInLayoutFile("SpellCost");
        spellCost.text = individualHeroSpell.cost;
        var spellButton = spellPanel.FindChildInLayoutFile("SingleSpellPanelButton");
        var spellStringified = JSON.stringify(individualHeroSpell);
        spellButton.SetPanelEvent("onactivate", Function("BuySpell(\'" + spellStringified + "\')"));
        // Hover events
        spellButton.SetPanelEvent("onmouseover", Function("$.DispatchEvent( \"DOTAShowAbilityTooltip\", \"" + individualHeroSpell.spell_id + "\")"));
        spellButton.SetPanelEvent("onmouseout", function () {
            $.DispatchEvent("DOTAHideAbilityTooltip")
        });
    }
}

function OpenSpellsMenu() {
    customSpellsMenuPanel.SetHasClass("Visible", true);
    openSpellsMenu.SetHasClass("Visible", false);
}

function CloseSpellsMenu() {
    customSpellsMenuPanel.SetHasClass("Visible", false);
    openSpellsMenu.SetHasClass("Visible", true);

    CloseSpellsListingForHero();
}

function OpenSpellsListForHero(heroID) {
    CreateSpellsListingForHero(heroID);
}

function CloseSpellsListingForHero() {
    var spellsContainer = customSpellsMenuPanel.FindChildTraverse("SpellsMenuSpellsBlock");
    // Clear children
    spellsContainer.RemoveAndDeleteChildren();
}

function BuySpell(spellJson) {
    var spellObj = JSON.parse(spellJson);
    spellObj.player_id = Game.GetLocalPlayerID();
    GameEvents.SendCustomGameEventToServer("spells_menu_buy_spell", spellObj);
}

function BuySpellFeedback(event_data) {
    CloseSpellsMenu();
}

(function () {
    CreateHeroesListingForAll();

    GameEvents.Subscribe("spells_menu_buy_spell_feedback", BuySpellFeedback);
})();