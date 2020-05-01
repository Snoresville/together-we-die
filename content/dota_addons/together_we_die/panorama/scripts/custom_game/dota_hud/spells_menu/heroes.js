var customSpellsMenuPanel = $("#SpellsMenuContents");
var openSpellsMenu = $("#SpellsMenuOpen");

var heroes = [
    {
        "name_id": "npc_dota_hero_riki",
    },
    {
        "name_id": "npc_dota_hero_legion_commander"
    }
];

var spells = {
    "npc_dota_hero_riki": [
        {
            "spell_id": "riki_permanent_invisibility_lua",
            "cost": 1
        }
    ],
    "npc_dota_hero_legion_commander": []
};


function CreateHeroesListing() {
    var heroesContainer = customSpellsMenuPanel.FindChildTraverse("SpellsMenuHeroesBlock");

    var heroPanel;
    for (var i = 0; i < heroes.length; i++) {
        heroPanel = $.CreatePanel("Panel", heroesContainer, "heroPanel" + i);
        heroPanel.BLoadLayoutSnippet("hero");

        // Set the picture to display
        var heroData = heroes[i].name_id;
        var image = heroPanel.FindChildInLayoutFile("HeroPictureImage");
        image.heroname = heroData;
        // Set the onactivate
        var heroButton = heroPanel.FindChildInLayoutFile("HeroPanelButton");
        heroButton.SetPanelEvent("onactivate", Function("OpenSpellsListForHero(\"" + heroData + "\")"));
    }
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
        spellButton.SetPanelEvent("onactivate", Function("BuySpell(\"" + individualHeroSpell.spell_id + "\")"));
        // Hover events
        spellButton.SetPanelEvent("onmouseover", Function("$.DispatchEvent( \"DOTAShowAbilityTooltip\", \"" + individualHeroSpell.spell_id + "\")"));
        spellButton.SetPanelEvent("onmouseout", function() { $.DispatchEvent("DOTAHideAbilityTooltip")});
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

function BuySpell(spellID) {
    $.Msg("buy spell");
    GameEvents.SendCustomGameEventToServer("spells_menu_buy_spell", {"spell_id": spellID});
}

function BuySpellFeedback(event_data) {

}

(function () {
    CreateHeroesListing();

    GameEvents.Subscribe("spells_menu_buy_spell_feedback", BuySpellFeedback);
})();