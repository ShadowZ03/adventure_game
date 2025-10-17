# require 'yaml'

# class Monster
#     attr_accessor :name, :hp, :min_damage, :max_damage, :image_path, :equipment

#     def initialize(name:, hp:, min_damage:, max_damage:, image_path:)
#         @name = name
#         @hp = hp
#         @min_damage = min_damage
#         @max_damage = max_damage
#         @image_path = image_path
#         @equipment = []
#     end

#     def alive?
#         @hp     > 0
#     end

#     def attack(player)
#         damage = rand(@min_damage..@max_damage)
#         player.hp -= damage
#         "#{@name} attacks #{player.name} for #{damage} damage!"
#     end

#     # factory method to load from YAML
#     def self.load_monsters(file = "monsters.yml")
#         full_path = File.expand_path("../data/#{file}", __dir__)

#         puts full_path
#         data = YAML.load_file(full_path)
#         return [] unless data.is_a?(Array)

#         data.map do |m|
#             Monster.new(
#             name: m["name"],
#             hp: m["hp"],
#             min_damage: m["min_damage"],
#             max_damage: m["max_damage"],
#             image_path: m["image"]
#             )
#         end
#     end

# end


# require 'yaml'

# class Monster
#     attr_accessor :name, :hp, :min_damage, :max_damage, :image_path

#     def initialize(name:, hp:, min_damage:, max_damage:, image_path:)
#         @name = name
#         @hp = hp
#         @min_damage = min_damage
#         @max_damage = max_damage
#         @image_path = image_path
#     end

#     def alive?
#         @hp > 0
#     end

#     def self.load_monsters
#         file = "monsters.yml"
#         full_path = File.expand_path("../data/#{file}", __dir__)
#         data = YAML.load_file(full_path)
#         data.map do |m|
#         puts "[DEBUG] Monsters loaded: #{@monsters.inspect}"

#         Monster.new(
#             name: m["name"],
#             hp: m["hp"],
#             min_damage: m["min_damage"],
#             max_damage: m["max_damage"],
#             image_path: m["image_path"]
#         )
#         end
#     end
# end


require 'yaml'

class Monster
    attr_accessor :name, :hp, :min_damage, :max_damage, :image_path, :equipment

    def initialize(name:, hp:, min_damage:, max_damage:, image_path:, equipment: [])
        @name = name
        @hp = hp
        @min_damage = min_damage
        @max_damage = max_damage
        @image_path = image_path
        @equipment = equipment
    end

    def alive?
        @hp > 0
    end

    def self.load_monsters
        # data = YAML.load_file("data/monsters.yml")
        yaml_file = File.join(__dir__, '..', 'data', 'monsters.yml')
        monsters_data = YAML.load_file(yaml_file)

        # monsters_data.map do |m|
        #     Monster.new(**m.transform_keys(&:to_sym))
        # end

        monsters_data.map do |m|
            puts "[DEBUG] Loading monster: #{m.inspect}"  # ← debug print
            Monster.new(
                name: m["name"],
                hp: m["hp"],
                min_damage: m["min_damage"],
                max_damage: m["max_damage"],
                image_path: m["image"],
                # image_path: File.join(File.dirname(__FILE__), '..', monsters_data['image_path']),
                equipment: m["equipment"] || []
            )
        end
    end
    # def self.load_monsters
    #     file_path = File.join(__dir__, '../data/monsters.yml')
    #     data = YAML.load_file(file_path)

    #     data.map do |m|
    #         # m = m.transform_keys(&:to_sym)
    #         # m[:image_path] = File.join(__dir__, '..', m[:image_path]) # ensure absolute path
    #         # puts "[DEBUG] Monster loaded: #{m[:name]} | Image path: #{m[:image_path]} | Exists? #{File.exist?(m[:image_path])}"
    #         Monster.new(**m)
    #             name: m["name"],
    #             hp: m["hp"],
    #             min_damage: m["min_damage"],
    #             max_damage: m["max_damage"],
    #             image_path: m["image_path"],
    #             equipment: m["equipment"] || []
    #     end
    # end


    # rescue => e
    #     puts "⚠️ Error loading monsters: #{e.class} - #{e.message}"
    #     puts e.backtrace
    #     []
    # end
# end



# require 'yaml'

# class Monster
#     attr_accessor :name, :hp, :min_damage, :max_damage, :equipment

#     def initialize(name:, hp:, min_damage:, max_damage:, equipment: [])
#         @name = name
#         @hp = hp
#         @min_damage = min_damage
#         @max_damage = max_damage
#         # make sure this path is always absolute:
#         # @image_path = File.expand_path(File.join(__dir__, '..', image_path))
#         @equipment = equipment
#     end

#     def self.load_monsters
#         file_path = File.join(__dir__, '..', 'data', 'monsters.yml')
#         data = YAML.load_file(file_path)

#         data.map do |monster_data|
#         Monster.new(**monster_data.transform_keys(&:to_sym))
#         end
#     end
end