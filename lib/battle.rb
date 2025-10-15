class Battle
    attr_reader :player, :monster

    def initialize(player, monster)
        @player = player
        @monster = monster
        @turn = :player
    end

    def player_action(action)
        case action
        when :attack
        return player_attack
        when :run
        return attempt_escape
        else
        return "Unknown action."
        end
    end

    private

    def player_attack
        damage = rand(@player.min_damage..@player.max_damage)
        @monster.hp -= damage
        msg = "#{@player.name} attacks #{@monster.name} for #{damage} damage!"

        if @monster.hp <= 0
        @monster.hp = 0
        msg += " #{@monster.name} is defeated!"
        return msg
        end

        msg + " " + monster_attack
    end

    def monster_attack
        damage = rand(@monster.min_damage..@monster.max_damage)
        @player.hp -= damage
        msg = "#{@monster.name} strikes back for #{damage} damage!"

        if @player.hp <= 0
        @player.hp = 0
        msg += " #{@player.name} falls in battle..."
        end

        msg
    end

    def attempt_escape
        if rand < 0.5
        "You successfully run away!"
        else
        "You fail to escape! " + monster_attack
        end
    end
end
