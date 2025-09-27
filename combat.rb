require 'ruby2d'

module Combat
    def self.start(player, monster)
        puts "\n⚔️  A wild #{monster.name} appears!"

        # Play music
        battle_music = Music.new('./assets/audio/to_battle.wav', loop: true)
        battle_music.play

        while player.alive? && monster.alive?
            puts "\n#{player.name}: #{player.hp} HP | #{monster.name}: #{monster.hp} HP"
            puts "Choose: (1) Attack (2) Run"
            choice = gets.chomp

        if choice == "1"
            slash = Sound.new('./assets/audio/knifesharpener1.flac')
            slash.play
            player.attack_target(monster)
        elsif choice == "2"
            puts "You fled!"
            battle_music.stop
            return
        end

        monster.attack_target(player) if monster.alive?
    end

        battle_music.stop
        puts player.alive? ? "🎉 You defeated #{monster.name}!" : "💀 You were slain..."
    end
end
