require 'ruby2d'
require_relative 'player'
require_relative 'monster'
require_relative 'equipment'
require_relative 'battle'

# --- Helper function ---
def choose_monster(monsters)
    puts "Choose a monster to fight:"
    monsters.each_with_index do |m, i|
        puts "#{i + 1}. #{m.name} (HP: #{m.hp})"
    end

    choice = nil
    until choice && choice.between?(1, monsters.size)
        print "> "
        choice = gets.chomp.to_i
    end

    monsters[choice - 1]   # returns the selected monster
end

# --- Setup ---
player   = Player.new(name: "Hero", hp: 12)
monsters = Monster.load_monsters

# --- Menu state ---
game_state = :menu
battle     = nil
selected_monster = nil
set width: 800, height: 600
set resizable: true



# Menu graphics
title_text  = Text.new("Ruby D&D Adventure", x: 200, y: 100, size: 40, color: 'yellow')
start_text  = Text.new("Press ENTER to Start", x: 250, y: 200, size: 25, color: 'white')
quit_text   = Text.new("Press Q to Quit", x: 270, y: 240, size: 25, color: 'white')

# Placeholder for battle graphics (created later)
monster_image = nil
message_text  = nil

# --- Input handling ---
on :key_down do |event|
    case game_state
    when :menu
        case event.key
        when 'return'
        # Start game
        selected_monster = choose_monster(monsters)
        battle = Battle.new(player, selected_monster)

        # Setup graphics for battle
        monster_image = Image.new(selected_monster.image_path, x: 400, y: 100)
        message_text  = Text.new(battle.message, x: 50, y: 10, size: 20, color: 'green')

        # Hide menu
        title_text.remove
        start_text.remove
        quit_text.remove

        game_state = :battle

        when 'q'
        close
        end

    when :battle
        case event.key
        when 'a'
        battle.player_action(:attack)
        when 'r'
        battle.player_action(:run)
        end
    end
end

# --- Game loop ---
update do
    if game_state == :battle
        battle.update_turn
        message_text.text = battle.message

        # Monster defeated
        if !battle.monster.alive?
        puts "#{battle.monster.name} has been defeated!"

        selected_monster = choose_monster(monsters)
        battle = Battle.new(player, selected_monster)

        # Update graphics
        monster_image.path = selected_monster.image_path
        message_text.text  = battle.message
        end
    end
end

show
