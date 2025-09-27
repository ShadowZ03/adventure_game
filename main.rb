require 'ruby2d'
require_relative 'player'
require_relative 'monster'
require_relative 'battle'
require_relative 'equipment'
require_relative 'menu'

# Setup
set title: "D&D Battle"
player = Player.new(name: "Hero", hp: 12)
# goblin = Monster.new(name: "Goblin", hp: 8)
# battle = Battle.new(player, goblin)

# Graphics
# goblin_image = Image.new('./assets/monsters/goblin.webp', x: 50, y: 50)
items = Equipment.load_items
sword = items.find { |e| e.name == "Iron Sword" }
shield = items.find { |e| e.name == "Wooden Shield" }

# Assign to player
player.equipment << sword if sword
player.equipment << shield if shield
monsters = Monster.load_monsters


puts "Choose a monster to fight:"
# monsters.each_with_index do |m, index|
#     puts "#{index + 1}. #{m.name} (HP: #{m.hp})"
# end



# print "Enter the number of the monster: "
# choice = gets.chomp.to_i

# # Validate input
# if choice < 1 || choice > monsters.size
#     puts "Invalid choice. Defaulting to first monster."
#     choice = 1
# end

# selected_monster = monsters[choice - 1]


# battle = Battle.new(player, selected_monster)

# # Optional: load monster image
# monster_image = Image.new(selected_monster.image_path, x: 400, y: 100)

# def choose_monster(monsters)
#     puts "Choose a monster to fight:"
#     monsters.each_with_index do |m, index|
#         puts "#{index + 1}. #{m.name} (HP: #{m.hp})"
#     end

#     print "Enter the number: "
#     choice = gets.chomp.to_i
#     choice = 1 if choice < 1 || choice > monsters.size
#     monsters[choice - 1]
# end

# selected_monster = choose_monster(monsters)
# battle = Battle.new(player, selected_monster)


# orc = monsters.find { |m| m.name == "Orc" }

# Draw monster image
# orc_image = Image.new(orc.image_path, x: 400, y: 100)

# battle = Battle.new(player, orc)

# message_text = Text.new(battle.message, x: 50, y: 10, size: 20, color: 'green')

selected_monster = choose_monster(monsters)


attack_sound = Sound.new('assets/audio/to_battle.wav')
sharpen_sound = Sound.new('assets/audio/knifesharpener1.flac')

attack_sound.play




# Game loop
update do
    battle.update_turn
    message_text.text = battle.message
end

# Input
on :key_down do |event|
    case event.key
    when 'a'
        battle.player_action(:attack)
        sharpen_sound.play

    when 'r'
        battle.player_action(:run)
    end
end

show
