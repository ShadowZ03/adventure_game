require 'yaml'

class Equipment
    attr_accessor :name, :type, :attack_bonus, :defense_bonus

    def initialize(name:, type:, attack_bonus: 0, defense_bonus: 0)
        @name = name
        @type = type.to_sym
        @attack_bonus = attack_bonus
        @defense_bonus = defense_bonus
    end

    # Load all equipment from YAML
    def self.load_items(file = "equipment.yml")
        full_path = File.join(File.dirname(__FILE__), file)
        return [] unless File.exist?(full_path)

        data = YAML.load_file(full_path)
        return [] unless data.is_a?(Array)

        data.map do |item|
        Equipment.new(
            name: item["name"],
            type: item["type"],
            attack_bonus: item["attack_bonus"] || 0,
            defense_bonus: item["defense_bonus"] || 0
        )
        end
    end
end
