# battle.rb
class Battle
    attr_reader :player, :monster, :turn, :message

    def initialize(player, monster)
        @player = player
        @monster = monster
        @turn = :player
        @message = "#{monster.name} appears!"
    end

    # called every frame
    def update_turn
        return if @turn == :player

        if @monster.alive?
        @message = resolve_attack(@monster, @player)
        @turn = :player if @player.alive?
        end

        if !@player.alive?
        @message = "#{@player.name} has fallen!"
        elsif !@monster.alive?
        @message = "#{@monster.name} has been defeated!"
        end
    end

    def player_action(action)
        return unless @turn == :player

        case action
        when :attack
        @message = resolve_attack(@player, @monster)
        @turn = :monster if @monster.alive?
        when :run
        @message = "#{@player.name} runs away!"
        @monster.hp = 0
        end
    end

    private

    # Centralized combat calculation
    def resolve_attack(attacker, defender)
        base_damage = rand(2..4)
        weapon_bonus = attacker.equipment.select { |e| e.type == :weapon }.sum(&:attack_bonus)
        total_attack = base_damage + weapon_bonus

        defense_bonus = defender.equipment.select { |e| e.type == :armor }.sum(&:defense_bonus)
        actual_damage = [total_attack - defense_bonus, 0].max

        defender.hp -= actual_damage
        "#{attacker.name} attacks #{defender.name} for #{actual_damage} damage!"
    end
end
