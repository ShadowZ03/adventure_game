require 'yaml'

class Monster
    attr_accessor :name, :hp, :min_damage, :max_damage, :image_path, :equipment

    def initialize(name:, hp:, min_damage:, max_damage:, image_path:)
        @name = name
        @hp = hp
        @min_damage = min_damage
        @max_damage = max_damage
        @image_path = image_path
        @equipment = []
    end

    def alive?
        @hp     > 0
    end

    def attack(player)
        damage = rand(@min_damage..@max_damage)
        player.hp -= damage
        "#{@name} attacks #{player.name} for #{damage} damage!"
    end

    # factory method to load from YAML
    def self.load_monsters(file = "monsters.yml")
        full_path = File.expand_path("../data/#{file}", __dir__)

        puts full_path
        data = YAML.load_file(full_path)
        return [] unless data.is_a?(Array)

        data.map do |m|
            Monster.new(
            name: m["name"],
            hp: m["hp"],
            min_damage: m["min_damage"],
            max_damage: m["max_damage"],
            image_path: m["image"]
            )
        end
    end

end
