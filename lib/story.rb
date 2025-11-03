# class Story
#     attr_reader :chapters, :current_index

#     def initialize
#         @chapters = [
#         { title: "Prologue", text: "You awaken in a dark forest. The wind howls through the trees..." },
#         { title: "The Goblin Attack", text: "A goblin emerges from the shadows, snarling at you!" },
#         { title: "The Orc Fortress", text: "You reach the fortress gates, guarded by fierce orcs..." },
#         { title: "The Dragon's Lair", text: "A rumble shakes the cave. The dragon has awakened." }
#         ]
#         @current_index = 0
#     end

#     def current_chapter
#         @chapters[@current_index]
#     end

#     def next_chapter
#         @current_index += 1 if @current_index < @chapters.size - 1
#     end

#     def reset
#         @current_index = 0
#     end

#     def finished?
#         @current_index >= @chapters.size - 1
#     end
# end


require_relative "scenes_library"

class Story
    attr_reader :scenes, :current_scene

    def initialize(start_scene = :forest_intro)
        @scenes = ScenesLibrary.all
        @current_scene = @scenes[start_scene]
    end

    def go_to(scene_id)
        @current_scene = @scenes[scene_id] if @scenes.key?(scene_id)
    end

    def next_scene(choice_text)
        next_id = @current_scene.choices[choice_text]
        go_to(next_id) if next_id
    end

    def has_trigger?
        !!@current_scene.triggers
    end

    def trigger
        @current_scene.triggers
    end
end
