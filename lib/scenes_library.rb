require_relative "scene"

class ScenesLibrary
    def self.all
        {
        forest_intro: Scene.new(
            id: :forest_intro,
            title: "The Forest Edge",
            text: "You stand before a dark forest. The trees sway with an unseen wind.",
            image: "assets/scenes/forest.webp",
            choices: {
            "Enter the forest" => :goblin_encounter,
            "Set up camp" => :campfire_rest
            }
        ),
        goblin_encounter: Scene.new(
            id: :goblin_encounter,
            title: "Ambush!",
            text: "A goblin leaps from the shadows, teeth bared!",
            image: "assets/monsters/goblin.webp",
            triggers: :battle_goblin,
            choices: { "Continue" => :victory_scene }
        ),
        orc_encounter: Scene.new(
            id: :orc_encounter,
            title: "Ambush!",
            text: "An Orc lumbers out, ready to fight!",
            image: "assets/monsters/orc.webp",
            triggers: :battle_orc,
            choices: { "Continue" => :victory_scene }
        ),
        victory_scene: Scene.new(
            id: :victory_scene,
            title: "Victory!",
            text: "You’ve slain the goblin. The forest grows silent once more.",
            image: "assets/scenes/victory.webp",
            choices: {
            "Explore deeper into the woods" => :ancient_ruins,
            "Rest by a campfire" => :campfire_rest
            }
        ),
        campfire_rest: Scene.new(
            id: :campfire_rest,
            title: "Campfire",
            text: "You sit by a crackling fire. Warmth returns to your limbs.",
            image: "assets/scenes/campfire.webp",
            choices: { "Sleep until morning" => :forest_intro }
        ),
        ancient_ruins: Scene.new(
            id: :ancient_ruins,
            title: "Ancient Ruins",
            text: "Crumbled stone walls loom ahead, covered in strange symbols.",
            image: "assets/scenes/ruins.webp",
            choices: {
            "Enter the forest" => :orc_encounter,
            "Set up camp" => :campfire_rest
            }
        )
        }
    end

    def self.get(id)
        all[id]
    end
end
