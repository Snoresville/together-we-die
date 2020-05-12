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
            "name_id": "npc_dota_hero_arc_warden",
        },
        {
            "name_id": "npc_dota_hero_drow_ranger",
        },
        {
            "name_id": "npc_dota_hero_juggernaut",
        },
        {
            "name_id": "npc_dota_hero_luna",
        },
        {
            "name_id": "npc_dota_hero_medusa",
        },
        {
            "name_id": "npc_dota_hero_phantom_assassin",
        },
        {
            "name_id": "npc_dota_hero_phantom_lancer",
        },
        {
            "name_id": "npc_dota_hero_riki",
        },
        {
            "name_id": "npc_dota_hero_slark",
        },
        {
            "name_id": "npc_dota_hero_sniper",
        },
        {
            "name_id": "npc_dota_hero_spectre",
        },
        {
            "name_id": "npc_dota_hero_ursa",
        },
        {
            "name_id": "npc_dota_hero_vengefulspirit",
        },
        {
            "name_id": "npc_dota_hero_viper",
        },
    ],
    [
        {
            "name_id": "npc_dota_hero_bane",
        },
        {
            "name_id": "npc_dota_hero_crystal_maiden",
        },
        {
            "name_id": "npc_dota_hero_dark_willow",
        },
        {
            "name_id": "npc_dota_hero_dazzle",
        },
        {
            "name_id": "npc_dota_hero_enchantress",
        },
        {
            "name_id": "npc_dota_hero_leshrac",
        },
        {
            "name_id": "npc_dota_hero_lina",
        },
        {
            "name_id": "npc_dota_hero_lion",
        },
        {
            "name_id": "npc_dota_hero_furion",
        },
        {
            "name_id": "npc_dota_hero_ogre_magi",
        },
        {
            "name_id": "npc_dota_hero_obsidian_destroyer",
        },
        {
            "name_id": "npc_dota_hero_puck",
        },
        {
            "name_id": "npc_dota_hero_queenofpain",
        },
        {
            "name_id": "npc_dota_hero_silencer",
        },
        {
            "name_id": "npc_dota_hero_skywrath_mage",
        },
        {
            "name_id": "npc_dota_hero_tinker",
        },
        {
            "name_id": "npc_dota_hero_windrunner",
        },
    ],
];

var specials = [
    {
        "name_id": "strength",
        "name": "Strength",
        "image": "strength.png"
    },
    {
        "name_id": "agility",
        "name": "Agility",
        "image": "agility.png"
    },
    {
        "name_id": "intellect",
        "name": "Intelligence",
        "image": "intellect.png"
    },
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
            "spell_id": "mars_bulwark_lua",
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
    "npc_dota_hero_arc_warden": [
        {
            "spell_id": "arc_warden_flux_lua",
            "cost": 1
        },
        {
            "spell_id": "arc_warden_spark_wraith_lua",
            "cost": 1
        },
        {
            "spell_id": "arc_warden_tempest_double_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_drow_ranger": [
        {
            "spell_id": "drow_ranger_frost_arrows_lua",
            "cost": 1
        },
        {
            "spell_id": "drow_ranger_multishot_lua",
            "cost": 1
        },
        {
            "spell_id": "drow_ranger_mind_break_lua",
            "cost": 1
        },
        {
            "spell_id": "drow_ranger_agility_strike_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_juggernaut": [
        {
            "spell_id": "juggernaut_blade_fury_lua",
            "cost": 1
        },
        {
            "spell_id": "juggernaut_blade_dance_lua",
            "cost": 1
        },
    ],
    "npc_dota_hero_luna": [
        {
            "spell_id": "luna_lucent_beam_lua",
            "cost": 1
        },
        {
            "spell_id": "luna_moon_glaive_lua",
            "cost": 1
        },
        {
            "spell_id": "luna_lunar_blessing_lua",
            "cost": 1
        },
        {
            "spell_id": "luna_eclipse_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_medusa": [
        {
            "spell_id": "medusa_mystic_snake_lua",
            "cost": 1
        },
        {
            "spell_id": "medusa_mana_shield_lua",
            "cost": 1
        },
        {
            "spell_id": "medusa_split_shot_lua",
            "cost": 1
        },
        {
            "spell_id": "medusa_split_shot_uses_modifiers_lua",
            "cost": 3
        },
        {
            "spell_id": "medusa_stone_gaze_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_phantom_assassin": [
        {
            "spell_id": "phantom_assassin_stifling_dagger_lua",
            "cost": 1
        },
        {
            "spell_id": "phantom_assassin_phantom_strike_lua",
            "cost": 1
        },
        {
            "spell_id": "phantom_assassin_blur_lua",
            "cost": 1
        },
        {
            "spell_id": "phantom_assassin_coup_de_grace_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_phantom_lancer": [
        {
            "spell_id": "phantom_lancer_spirit_lance_lua",
            "cost": 1
        },
        {
            "spell_id": "phantom_lancer_juxtapose_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_riki": [
        {
            "spell_id": "riki_permanent_invisibility_lua",
            "cost": 1
        },
        {
            "spell_id": "riki_backstab_lua",
            "cost": 1
        },
    ],
    "npc_dota_hero_slark": [
        {
            "spell_id": "slark_dark_pact_lua",
            "cost": 1
        },
        {
            "spell_id": "slark_essence_shift_lua",
            "cost": 1
        },
        {
            "spell_id": "slark_shadow_dance_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_sniper": [
        {
            "spell_id": "sniper_shrapnel_lua",
            "cost": 1
        },
        {
            "spell_id": "sniper_take_aim_lua",
            "cost": 1
        },
        {
            "spell_id": "sniper_headshot_lua",
            "cost": 1
        },
        {
            "spell_id": "sniper_assassinate_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_spectre": [
        {
            "spell_id": "spectre_desolate_lua",
            "cost": 1
        },
        {
            "spell_id": "spectre_dispersion_lua",
            "cost": 1
        },
        {
            "spell_id": "spectre_einherjar_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_ursa": [
        {
            "spell_id": "ursa_earthshock_lua",
            "cost": 1
        },
        {
            "spell_id": "ursa_overpower_lua",
            "cost": 1
        },
        {
            "spell_id": "ursa_fury_swipes_lua",
            "cost": 1
        },
        {
            "spell_id": "ursa_enrage_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_vengefulspirit": [
        {
            "spell_id": "vengefulspirit_magic_missile_lua",
            "cost": 1
        },
        {
            "spell_id": "vengefulspirit_wave_of_terror_lua",
            "cost": 1
        },
        {
            "spell_id": "vengefulspirit_command_aura_lua",
            "cost": 1
        },
        {
            "spell_id": "vengefulspirit_nether_swap_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_viper": [
        {
            "spell_id": "viper_poison_attack_lua",
            "cost": 1
        },
        {
            "spell_id": "viper_nethertoxin_lua",
            "cost": 1
        },
        {
            "spell_id": "viper_corrosive_skin_lua",
            "cost": 1
        },
        {
            "spell_id": "viper_viper_strike_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_bane": [
        {
            "spell_id": "bane_enfeeble_lua",
            "cost": 1
        },
        {
            "spell_id": "bane_brain_sap_lua",
            "cost": 1
        },
        {
            "spell_id": "bane_nightmare_lua",
            "cost": 1
        },
        {
            "spell_id": "bane_fiends_grip_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_crystal_maiden": [
        {
            "spell_id": "crystal_maiden_frostbite_lua",
            "cost": 1
        },
        {
            "spell_id": "crystal_maiden_crystal_nova_lua",
            "cost": 1
        },
        {
            "spell_id": "crystal_maiden_arcane_aura_lua",
            "cost": 1
        },
        {
            "spell_id": "crystal_maiden_freezing_field_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_dark_willow": [
        {
            "spell_id": "dark_willow_bramble_maze_lua",
            "cost": 1
        },
        {
            "spell_id": "dark_willow_shadow_realm_lua",
            "cost": 1
        },
        {
            "spell_id": "dark_willow_cursed_crown_lua",
            "cost": 1
        },
        {
            "spell_id": "dark_willow_bedlam_lua",
            "cost": 2
        },
        {
            "spell_id": "dark_willow_terrorize_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_dazzle": [
        {
            "spell_id": "dazzle_poison_touch_lua",
            "cost": 1
        },
        {
            "spell_id": "dazzle_shallow_grave_lua",
            "cost": 1
        },
        {
            "spell_id": "dazzle_shadow_wave_lua",
            "cost": 1
        },
        {
            "spell_id": "dazzle_bad_juju_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_enchantress": [
        {
            "spell_id": "enchantress_untouchable_lua",
            "cost": 1
        },
        {
            "spell_id": "enchantress_enchant_lua",
            "cost": 1
        },
        {
            "spell_id": "enchantress_natures_attendants_lua",
            "cost": 1
        },
        {
            "spell_id": "enchantress_impetus_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_leshrac": [
        {
            "spell_id": "leshrac_split_earth_lua",
            "cost": 1
        },
        {
            "spell_id": "leshrac_diabolic_edict_lua",
            "cost": 1
        },
        {
            "spell_id": "leshrac_lightning_storm_lua",
            "cost": 1
        },
        {
            "spell_id": "leshrac_pulse_nova_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_lina": [
        {
            "spell_id": "lina_dragon_slave_lua",
            "cost": 1
        },
        {
            "spell_id": "lina_light_strike_array_lua",
            "cost": 1
        },
        {
            "spell_id": "lina_fiery_soul_lua",
            "cost": 1
        },
        {
            "spell_id": "lina_laguna_blade_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_lion": [
        {
            "spell_id": "lion_earth_spike_lua",
            "cost": 1
        },
        {
            "spell_id": "lion_hex_lua",
            "cost": 1
        },
        {
            "spell_id": "lion_mana_drain_lua",
            "cost": 1
        },
        {
            "spell_id": "lion_finger_of_death_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_furion": [
        {
            "spell_id": "furion_sprout_lua",
            "cost": 1
        },
        {
            "spell_id": "furion_teleportation_lua",
            "cost": 1
        },
        {
            "spell_id": "furion_force_of_nature_lua",
            "cost": 1
        },
        {
            "spell_id": "furion_wrath_of_nature_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_ogre_magi": [
        {
            "spell_id": "ogre_magi_fireblast_lua",
            "cost": 1
        },
        {
            "spell_id": "ogre_magi_ignite_lua",
            "cost": 1
        },
        {
            "spell_id": "ogre_magi_bloodlust_lua",
            "cost": 1
        },
        {
            "spell_id": "ogre_magi_multicast_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_obsidian_destroyer": [
        {
            "spell_id": "outworld_devourer_arcane_orb_lua",
            "cost": 1
        },
        {
            "spell_id": "outworld_devourer_astral_imprisonment_lua",
            "cost": 1
        },
        {
            "spell_id": "outworld_devourer_equilibrium_lua",
            "cost": 1
        },
        {
            "spell_id": "outworld_devourer_sanitys_eclipse_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_puck": [
        {
            "spell_id": "puck_illusory_orb_lua",
            "cost": 1
        },
        {
            "spell_id": "puck_waning_rift_lua",
            "cost": 1
        },
        {
            "spell_id": "puck_phase_shift_lua",
            "cost": 1
        },
        {
            "spell_id": "puck_dream_coil_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_queenofpain": [
        {
            "spell_id": "queen_of_pain_shadow_strike_lua",
            "cost": 1
        },
        {
            "spell_id": "queen_of_pain_blink_lua",
            "cost": 1
        },
        {
            "spell_id": "queen_of_pain_scream_of_pain_lua",
            "cost": 1
        },
        {
            "spell_id": "queen_of_pain_sonic_wave_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_silencer": [
        {
            "spell_id": "silencer_arcane_curse_lua",
            "cost": 1
        },
        {
            "spell_id": "silencer_glaives_of_wisdom_lua",
            "cost": 1
        },
        {
            "spell_id": "silencer_last_word_lua",
            "cost": 1
        },
        {
            "spell_id": "silencer_global_silence_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_skywrath_mage": [
        {
            "spell_id": "skywrath_mage_arcane_bolt_lua",
            "cost": 1
        },
        {
            "spell_id": "skywrath_mage_concussive_shot_lua",
            "cost": 1
        },
        {
            "spell_id": "skywrath_mage_ancient_seal_lua",
            "cost": 1
        },
        {
            "spell_id": "skywrath_mage_mystic_flare_lua",
            "cost": 2
        },
    ],
    "npc_dota_hero_tinker": [
        {
            "spell_id": "tinker_laser_lua",
            "cost": 1
        },
        {
            "spell_id": "tinker_heat_seeking_missile_lua",
            "cost": 1
        },
        {
            "spell_id": "tinker_march_of_the_machines_lua",
            "cost": 1
        },
        {
            "spell_id": "tinker_rearm",
            "cost": 2
        },
    ],
    "npc_dota_hero_windrunner": [
        {
            "spell_id": "windranger_shackleshot_lua",
            "cost": 1
        },
        {
            "spell_id": "windranger_powershot_lua",
            "cost": 1
        },
        {
            "spell_id": "windranger_windrun_lua",
            "cost": 1
        },
        {
            "spell_id": "windranger_focus_fire_lua",
            "cost": 2
        },
    ],
    "strength": [],
    "agility": [
        {
            "spell_id": "pure_strike_lua",
            "cost": 4
        },
    ],
    "intellect": [
        {
            "spell_id": "intelligence_magic_scale_lua",
            "cost": 4
        },
        {
            "spell_id": "summoning_stone_lua",
            "cost": 4
        },
        {
            "spell_id": "auto_laguna_blade_lua",
            "cost": 4
        },
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

    var specialsContainer = customSpellsMenuPanel.FindChildTraverse("SpellsMenuSpecialsBlock");
    for (var specialCategory = 0; specialCategory < specials.length; specialCategory++) {
        var specialPanel = $.CreatePanel("Panel", specialsContainer, "specialPanel" + specialCategory);
        CreateSpecialsListing(specialPanel, specials[specialCategory]);
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

function CreateSpecialsListing(specialsPanel, special) {
    specialsPanel.BLoadLayoutSnippet("special");

    // Set the picture to display
    var image = specialsPanel.FindChildInLayoutFile("SpecialPictureImage");
    image.SetImage("file://{images}/spells_menu/" + special.image);
    // Set the onactivate
    var specialButton = specialsPanel.FindChildInLayoutFile("SpecialPanelButton");
    specialButton.SetPanelEvent("onactivate", Function("OpenSpellsListForHero(\"" + special.name_id + "\")"));
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