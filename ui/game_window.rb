# require 'ruby2d'
# require_relative '../lib/battle'

# class GameWindow
#     def initialize(player, monsters, story)
#         @player = player
#         @monsters = monsters
#         @story = story
#         @monster_image = nil
#         @menu_texts = []
#         @state = :menu
#         @selected_monster = nil
#         @current_battle = nil
#         @intro_texts = nil
#     end

#     def start
#         Window.set(title: "Adventure!", width: 800, height: 600, resizable: true)
#         show_menu

#         Window.on :key_down do |event|
#         case @state
#             when :menu
#                 handle_menu_input(event)
#             when :battle
#                 handle_battle_input(event)
#             when :defeat
#                 handle_defeat_input(event)
#             end
#         end

#         Window.update do
#         case @state
#         when :battle
#             update_battle
#         end
#         end

#         Window.show
#     end

#     def show_menu
#         @state = :menu
#         @menu_texts.each(&:remove)
#         @menu_texts.clear

#         title = Text.new("Choose a monster:", x: 300, y: 100, size: 30, color: 'white')
#         @menu_texts << title  

#         @monsters.each_with_index do |m, i|
#             t = Text.new("#{i + 1}. #{m.name}", x: 330, y: 150 + (i * 40), size: 25, color: 'green')
#             @menu_texts << t
#         end
#     end

#     def handle_menu_input(event)
#         key = event.key

#         begin
#             if key =~ /^[1-9]$/ && key.to_i.between?(1, @monsters.length)
#             index = key.to_i - 1
#             monster = @monsters[index]
#             puts "[DEBUG] Monster selected: #{monster.name}"
#             start_battle(monster)
#             else
#             puts "[DEBUG] Invalid key: #{key.inspect}"
#             end
#         rescue => e
#             puts "⚠️ Error in handle_menu_input: #{e.class} - #{e.message}"
#             puts e.backtrace
#         end
#     end

#     def handle_defeat_input(event)
#         case event.key
#         when "y"
#             clear_defeat_screen
#             reset_game
#         when "n"
#             exit
#         end
#     end


#     def start_battle(monster)
#         @state = :battle
#         # @menu_texts&.remove
        
#         chapter = @story.current_chapter
#         Text.new("#{chapter[:title]}", x: 200, y: 20, size: 30, color: 'yellow')
#         Text.new("#{chapter[:text]}", x: 100, y: 60, size: 20, color: 'white')
#         @story.next_chapter

#         @menu_texts.each(&:remove)
#         @selected_monster = monster

#         @current_battle = Battle.new(@player, monster)
        
#         @monster_image = Image.new(File.join(__dir__, '..', monster.image_path))
#         center_image(@monster_image)

#         @intro_texts = Text.new("A wild #{monster.name} appears!", x: 250, y: 50, size: 30, color: 'red')
#         rescue => e
#             puts "⚠️ Could not start battle: #{e.class} - #{e.message}"
#             puts e.backtrace
#     end


#     def handle_battle_input(event)
#         return unless @current_battle

#         case event.key
#         when "a"
#             result = @current_battle.player_action(:attack)
#             update_battle_message(result)
#         when "r"
#             result = @current_battle.player_action(:run)
#             update_battle_message(result)
#             @state = :menu if result.include?("runs away")
#         end
#     end

#     def wrap_text(text, max_length = 50)
#         text.scan(/.{1,#{max_length}}(?:\s+|$)/).join("\n")
#     end

#     def update_battle
#         return unless @current_battle

#         if !@current_battle.monster.alive?
#             @state = :victory
#             show_victory_screen
#         elsif !@player.alive?
#             @state = :defeat
#             show_defeat_screen
#         end
#     end

#     def show_scene(scene)
#         clear_all

#         @scene_image = Image.new(File.join(__dir__, '..', scene.image)) if scene.image
#         center_image(@scene_image) if @scene_image

#         title = Text.new(scene.title, x: 300, y: 50, size: 32, color: 'yellow')
#         body  = Text.new(wrap_text(scene.text, 70), x: 100, y: 150, size: 24, color: 'white')

#         @menu_texts = [title, body]

#         # Display choices (numbered)
#         scene.choices.each_with_index do |(choice_text, _), i|
#             choice_text_obj = Text.new("#{i + 1}. #{choice_text}", x: 120, y: 400 + (i * 40), size: 24, color: 'cyan')
#             @menu_texts << choice_text_obj
#         end

#         # Handle input
#         Window.on :key_down do |event|
#             if event.key =~ /^[1-9]$/
#             choice_index = event.key.to_i - 1
#             choice_text = scene.choices.keys[choice_index]
#             if choice_text
#                 @story.next_scene(choice_text)
#                 show_scene(@story.current_scene)
#             end
#             end
#         end
#     end


#     def update_battle_message(message)
#         @battle_text.remove if @battle_text
#         wrapped = wrap_text(message, 800) # adjust 60 to fit your window width
#         @battle_text = Text.new(wrapped, x: 50, y: 500, size: 25, color: 'white')
#     end

#     def show_victory_screen
#         clear_battle
#         Text.new("You won!", x: 350, y: 300, size: 40, color: 'yellow')
#     end

#     def show_defeat_screen
#         clear_battle
#         clear_texts

#         @state = :defeat
#         @defeat_elements = []

#         defeated_text = Text.new("You were defeated...", x: 0, y: 100, size: 40, color: 'red')
#         center_text(defeated_text)
#         @defeat_elements << defeated_text

#         skull_path = File.join(__dir__, '..', 'assets/other/skull.webp')
#         if File.exist?(skull_path)
#             game_over_image = Image.new(skull_path)
#             center_image(game_over_image)
#             @defeat_elements << game_over_image
#         else
#             puts "⚠️ Missing image: #{skull_path}"
#         end

#         try_again_text = Text.new("Try again? (Y)es (N)o", x: 0, y: 500, size: 30, color: 'orange')
#         center_text(try_again_text)
#         @defeat_elements << try_again_text
#     end


#     def clear_battle
#         @monster_image&.remove
#         @battle_text&.remove
#     end

#     private

#     def center_image(image)
#         image.x = (Window.width - image.width) / 2
#         image.y = (Window.height - image.height) / 2
#     end

#     def center_text(text)
#         text.x = (Window.width - text.width) / 2
#     end

#     def clear_texts
#         @menu_texts&.each(&:remove)
#         @menu_texts&.clear
#         @battle_text&.remove
#         @intro_texts&.remove
#         @intro_texts = nil
#     end

#     def clear_defeat_screen
#         @defeat_elements&.each(&:remove)
#         @defeat_elements&.clear
#     end

#     def reset_game
#         @player.hp = @player.max_hp if @player.respond_to?(:max_hp)
#         show_menu
#     end


# end


require 'ruby2d'
require_relative '../lib/battle'

class GameWindow
    def initialize(player, monsters, story)
        @player = player
        @monsters = monsters
        @story = story
        @monster_image = nil
        @menu_texts = []
        @state = :story
        @current_battle = nil
        @scene_elements = []
        @defeat_elements = []
    end

    def start
        Window.set(title: "Adventure!", width: 800, height: 600, resizable: true)

        # Start the story first
        show_scene(@story.current_scene)

        Window.on :key_down do |event|
        handle_input(event)
        end

        Window.update do
        update_battle if @state == :battle
        end

        Window.show
    end

    #
    # ─── STORY ──────────────────────────────────────────────
    #
    def show_scene(scene)
        clear_all
        @state = :story

        # Optional scene image
        if scene.image && File.exist?(File.join(__dir__, '..', scene.image))
        @scene_image = Image.new(File.join(__dir__, '..', scene.image))
        center_image(@scene_image)
        @scene_elements << @scene_image
        end

        title = Text.new(scene.title, x: 200, y: 40, size: 30, color: 'yellow')
        body  = Text.new(wrap_text(scene.text, 60), x: 100, y: 100, size: 22, color: 'white')
        @scene_elements += [title, body]

        scene.choices.each_with_index do |(choice_text, _), i|
        choice = Text.new("#{i + 1}. #{choice_text}", x: 120, y: 400 + (i * 40), size: 24, color: 'blue')
        @scene_elements << choice
        end
    end

    def handle_story_input(event)
        scene = @story.current_scene
        if event.key =~ /^[1-9]$/
        choice_index = event.key.to_i - 1
        choice_text = scene.choices.keys[choice_index]
        return unless choice_text

        next_scene = scene.choices[choice_text]
        if next_scene == :battle_menu
            show_menu
        else
            @story.next_scene(choice_text)
            show_scene(@story.current_scene)
        end
        end
    end

    #
    # ─── MENU ──────────────────────────────────────────────
    #
    def show_menu
        clear_all
        @state = :menu

        title = Text.new("Choose a monster to fight:", x: 250, y: 100, size: 30, color: 'white')
        @menu_texts << title

        @monsters.each_with_index do |m, i|
        t = Text.new("#{i + 1}. #{m.name}", x: 300, y: 150 + (i * 40), size: 25, color: 'green')
        @menu_texts << t
        end
    end

    def handle_menu_input(event)
        key = event.key
        return unless key =~ /^[1-9]$/ && key.to_i.between?(1, @monsters.length)

        index = key.to_i - 1
        monster = @monsters[index]
        start_battle(monster)
    end

    #
    # ─── BATTLE ────────────────────────────────────────────
    #
    def start_battle(monster)
        clear_all
        @state = :battle

        @current_battle = Battle.new(@player, monster)
        puts "[DEBUG] Starting battle with #{monster.name}"

        @monster_image = Image.new(File.join(__dir__, '..', monster.image_path))
        center_image(@monster_image)

        @battle_intro = Text.new("A wild #{monster.name} appears!", x: 200, y: 50, size: 28, color: 'red')
    rescue => e
        puts "⚠️ Error starting battle: #{e.message}"
    end

    def handle_battle_input(event)
        return unless @current_battle

        case event.key
        when "a"
        result = @current_battle.player_action(:attack)
        update_battle_message(result)
        when "r"
        result = @current_battle.player_action(:run)
        update_battle_message(result)
        @state = :menu if result.include?("runs away")
        end
    end

    def update_battle
        return unless @current_battle

        if !@current_battle.monster.alive?
        @state = :victory
        show_victory_screen
        elsif !@player.alive?
        @state = :defeat
        show_defeat_screen
        end
    end

    def update_battle_message(message)
        @battle_text&.remove
        wrapped = wrap_text(message, 70)
        @battle_text = Text.new(wrapped, x: 50, y: 500, size: 22, color: 'white')
    end

    #
    # ─── RESULT SCREENS ───────────────────────────────────
    #
    def show_victory_screen
        clear_all
        @state = :story
        Text.new("You won!", x: 350, y: 300, size: 40, color: 'yellow')
        @story.next_scene(:victory)
        show_scene(@story.current_scene)
    end

    def show_defeat_screen
        clear_all
        @state = :defeat

        defeated_text = Text.new("You were defeated...", x: 0, y: 100, size: 40, color: 'red')
        center_text(defeated_text)
        @defeat_elements << defeated_text

        skull_path = File.join(__dir__, '..', 'assets/other/skull.webp')
        if File.exist?(skull_path)
        image = Image.new(skull_path)
        center_image(image)
        @defeat_elements << image
        end

        retry_text = Text.new("Try again? (Y)es (N)o", x: 0, y: 500, size: 30, color: 'orange')
        center_text(retry_text)
        @defeat_elements << retry_text
    end

    def handle_defeat_input(event)
        case event.key
        when "y"
        clear_all
        reset_game
        when "n"
        exit
        end
    end

    #
    # ─── UTILITIES ────────────────────────────────────────
    #
    def wrap_text(text, max_length = 60)
        text.scan(/.{1,#{max_length}}(?:\s+|$)/).join("\n")
    end

    def center_image(image)
        image.x = (Window.width - image.width) / 2
        image.y = (Window.height - image.height) / 2
    end

    def center_text(text)
        text.x = (Window.width - text.width) / 2
    end

    def clear_all
        [@menu_texts, @scene_elements, @defeat_elements].each do |arr|
        arr&.each(&:remove)
        arr&.clear
        end
        @monster_image&.remove
        @battle_text&.remove
    end

    def reset_game
        @player.hp = @player.max_hp if @player.respond_to?(:max_hp)
        show_scene(@story.start_scene)
    end

    #
    # ─── EVENT ROUTER ────────────────────────────────────
    #
    def handle_input(event)
        case @state
        when :story
        handle_story_input(event)
        when :menu
        handle_menu_input(event)
        when :battle
        handle_battle_input(event)
        when :defeat
        handle_defeat_input(event)
        end
    end
end
