# class Player
#     attr_accessor :name, :hp, :equipment

#     def initialize(name = "Hero", hp = 10)
#         @hp = hp
#         @equipment = []   # array of Equipment objects

#     end

#     def alive?
#         @hp > 0
#     end

#     def attack(monster)
#         weapon_bonus = @equipment.select { |e| e.type == :weapon }.sum(&:attack_bonus)
#         damage = rand(2..4) + weapon_bonus
#         monster.hp -= damage
#         "#{@name} hits #{monster.name} for #{damage} damage!"
#     end

#     def defense
#     # sum up defense bonuses from armor
#         @equipment.select { |e| e.type == :armor }.sum(&:defense_bonus)
#     end
# end


class Player
    attr_accessor :name, :hp, :min_damage, :max_damage

    def initialize(name:, hp:, min_damage: 2, max_damage: 6)
        @name = name
        @hp = hp
        @min_damage = min_damage
        @max_damage = max_damage
    end

    def alive?
        @hp > 0
    end
end
