require 'ruby2d'
require_relative '../lib/battle'
class GameWindow
    def initialize(player, monsters)
        @player = player
        @monsters = monsters
        @monster_image = nil
        @menu_texts = []
        @state = :menu
        @selected_monster = nil
        @current_battle = nil
    end

    def start
        Window.set(title: "Adventure!", width: 800, height: 600)
        show_menu

        Window.on :key_down do |event|
        case @state
            when :menu
                handle_menu_input(event)
            when :battle
                handle_battle_input(event)
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

        Text.new("Choose a monster:", x: 300, y: 100, size: 30, color: 'white')

        @monsters.each_with_index do |m, i|
        t = Text.new("#{i + 1}. #{m.name}", x: 330, y: 150 + (i * 40), size: 25, color: 'green')
        @menu_texts << t
        end
    end

    # def handle_menu_input(event)
    #     case event.key
    #         when "1", "2", "3"
    #         index = event.key.to_i - 1
    #             if index.between?(0, @monsters.length - 1)
    #                 start_battle(@monsters[index])
    #         end
    #     end
    # end
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




    # def start_battle(monster)
    #     @state = :battle
    #     @menu_texts.each(&:remove)
    #     @selected_monster = monster

    #     @current_battle = Battle.new(@player, monster)

    #     @monster_image = Image.new(monster.image_path)
    #     center_image(@monster_image)

    #     @battle_text = Text.new("A wild #{monster.name} appears!", x: 250, y: 50, size: 30, color: 'red')
    # end

    def start_battle(monster)
        @state = :battle
        @menu_texts.each(&:remove)
        @selected_monster = monster

        @current_battle = Battle.new(@player, monster)
        #        yaml_file = File.join(__dir__, '..', 'data', 'monsters.yml')
        
        # puts "monster: #{selected_monster.name}"
        # puts "monster image link: #{select_monster.image_path}"
        
        @monster_image = Image.new(File.join(__dir__, '..', monster.image_path))
        center_image(@monster_image)

        Text.new("A wild #{monster.name} appears!", x: 250, y: 50, size: 30, color: 'red')
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
        @battle_text = Text.new(message, x: 250, y: 500, size: 25, color: 'white')
    end

    def show_victory_screen
        clear_battle
        Text.new("You won!", x: 350, y: 300, size: 40, color: 'yellow')
    end

    def show_defeat_screen
        clear_battle
        Text.new("You were defeated...", x: 300, y: 300, size: 40, color: 'red')
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
end
