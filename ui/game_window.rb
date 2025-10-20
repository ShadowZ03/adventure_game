require 'ruby2d'
require_relative '../lib/battle'

class GameWindow
    def initialize(player, monsters, story)
        @player = player
        @monsters = monsters
        @story = story
        @monster_image = nil
        @menu_texts = []
        @state = :menu
        @selected_monster = nil
        @current_battle = nil
        @intro_texts = nil
    end

    def start
        Window.set(title: "Adventure!", width: 800, height: 600, resizable: true)
        show_menu

        Window.on :key_down do |event|
        case @state
            when :menu
                handle_menu_input(event)
            when :battle
                handle_battle_input(event)
            when :defeat
                handle_defeat_input(event)
            end
        end

        Window.update do
        case @state
        when :battle
            update_battle
        end
        end

        Window.show
    end

    def show_menu
        @state = :menu
        @menu_texts.each(&:remove)
        @menu_texts.clear

        title = Text.new("Choose a monster:", x: 300, y: 100, size: 30, color: 'white')
        @menu_texts << title  

        @monsters.each_with_index do |m, i|
            t = Text.new("#{i + 1}. #{m.name}", x: 330, y: 150 + (i * 40), size: 25, color: 'green')
            @menu_texts << t
        end
    end

    def handle_menu_input(event)
        key = event.key

        begin
            if key =~ /^[1-9]$/ && key.to_i.between?(1, @monsters.length)
            index = key.to_i - 1
            monster = @monsters[index]
            puts "[DEBUG] Monster selected: #{monster.name}"
            start_battle(monster)
            else
            puts "[DEBUG] Invalid key: #{key.inspect}"
            end
        rescue => e
            puts "⚠️ Error in handle_menu_input: #{e.class} - #{e.message}"
            puts e.backtrace
        end
    end

    def handle_defeat_input(event)
        case event.key
        when "y"
            clear_defeat_screen
            reset_game
        when "n"
            exit
        end
    end


    def start_battle(monster)
        @state = :battle
        # @menu_texts&.remove
        
        chapter = @story.current_chapter
        Text.new("#{chapter[:title]}", x: 200, y: 20, size: 30, color: 'yellow')
        Text.new("#{chapter[:text]}", x: 100, y: 60, size: 20, color: 'white')
        @story.next_chapter

        @menu_texts.each(&:remove)
        @selected_monster = monster

        @current_battle = Battle.new(@player, monster)
        
        @monster_image = Image.new(File.join(__dir__, '..', monster.image_path))
        center_image(@monster_image)

        @intro_texts = Text.new("A wild #{monster.name} appears!", x: 250, y: 50, size: 30, color: 'red')
        rescue => e
            puts "⚠️ Could not start battle: #{e.class} - #{e.message}"
            puts e.backtrace
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

    def wrap_text(text, max_length = 50)
        text.scan(/.{1,#{max_length}}(?:\s+|$)/).join("\n")
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
        @battle_text.remove if @battle_text
        wrapped = wrap_text(message, 800) # adjust 60 to fit your window width
        @battle_text = Text.new(wrapped, x: 50, y: 500, size: 25, color: 'white')
    end

    def show_victory_screen
        clear_battle
        Text.new("You won!", x: 350, y: 300, size: 40, color: 'yellow')
    end

    def show_defeat_screen
        clear_battle
        clear_texts

        @state = :defeat
        @defeat_elements = []

        defeated_text = Text.new("You were defeated...", x: 0, y: 100, size: 40, color: 'red')
        center_text(defeated_text)
        @defeat_elements << defeated_text

        skull_path = File.join(__dir__, '..', 'assets/other/skull.webp')
        if File.exist?(skull_path)
            game_over_image = Image.new(skull_path)
            center_image(game_over_image)
            @defeat_elements << game_over_image
        else
            puts "⚠️ Missing image: #{skull_path}"
        end

        try_again_text = Text.new("Try again? (Y)es (N)o", x: 0, y: 500, size: 30, color: 'orange')
        center_text(try_again_text)
        @defeat_elements << try_again_text
    end


    def clear_battle
        @monster_image&.remove
        @battle_text&.remove
    end

    private

    def center_image(image)
        image.x = (Window.width - image.width) / 2
        image.y = (Window.height - image.height) / 2
    end

    def center_text(text)
        text.x = (Window.width - text.width) / 2
    end

    def clear_texts
        @menu_texts&.each(&:remove)
        @menu_texts&.clear
        @battle_text&.remove
        @intro_texts&.remove
        @intro_texts = nil
    end

    def clear_defeat_screen
        @defeat_elements&.each(&:remove)
        @defeat_elements&.clear
    end

    def reset_game
        @player.hp = @player.max_hp if @player.respond_to?(:max_hp)
        show_menu
    end


end
