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
player = Player.new(name: "Hero", hp: 12)
monsters = Monster.load_monsters

selected_monster = choose_monster(monsters)
battle = Battle.new(player, selected_monster)

# Load monster image
monster_image = Image.new(selected_monster.image_path, x: 400, y: 100)

# Your Ruby2D loop here...
