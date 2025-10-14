require 'ruby2d'
require_relative '../lib/player'
require_relative '../lib/monster'
require_relative '../lib/battle'

class GameWindow
    def initialize(player, monsters)
        @player = player
        @monsters = monsters
        @monster_image = nil
    end

    def start
        set title: "Adventure!", width: 800, height: 600, resizable: true
        show_menu
        show
    end

    def show_menu
        puts "Choose a monster:"
        @monsters.each_with_index do |m, i|
        puts "#{i + 1}. #{m.name}"
        end
        print "> "
        choice = gets.to_i - 1
        start_battle(@monsters[choice])
    end

    def start_battle(monster)
        @monster_image = Image.new(monster.image_path)
        center_image(@monster_image)
    end

    private

    def center_image(image)
        image.x = Window.width / 2 - image.width / 2
        image.y = Window.height / 2 - image.height / 2
    end
end
