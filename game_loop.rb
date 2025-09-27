require 'ruby2d'

set title: "D&D Battle"

# Assets
goblin = Image.new('./assets/monsters/goblin.webp', x: 50, y: 50)
message = Text.new("A Goblin appears!", x: 50, y: 10, size: 20, color: 'green')

# Game state
player_hp = 10
goblin_hp = 6
turn = :player

    # battle_music = Music.new('./assets/audio/to_battle.wav', loop: true)
    # battle_music.play


# Game loop (runs every frame)
update do
    if turn == :player
        message.text = "Press A to attack or R to run"
    else
        # Goblin's turn
        damage = rand(1..3)
        player_hp -= damage
        message.text = "Goblin hits you for #{damage}! (HP: #{player_hp})"
        turn = :player if player_hp > 0
    end

    # End game conditions
    if goblin_hp <= 0
        message.text = "You defeated the goblin!"
    elsif player_hp <= 0
        message.text = "You were defeated..."
    end
end

# Player input
on :key_down do |event|
    if turn == :player
        case event.key
        when 'a' # attack
        damage = rand(2..4)
        goblin_hp -= damage
        message.text = "You strike the goblin for #{damage}! (Goblin HP: #{goblin_hp})"
        turn = :goblin if goblin_hp > 0
        when 'r' # run
        message.text = "You ran away!"
        goblin.remove
        end
    end
end

show
