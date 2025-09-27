puts "Greeting Adventurer! What is your name?"
name = gets.chomp


class Player
    def initialize(name, *args)
        @initialized = true
        @player_name = name
    end

    def initialized?
        @initialized || false
    end
end

