require_relative 'ui/game_window'
require_relative 'lib/monster'
require_relative 'lib/player'

player = Player.new(name: "Hero", hp: 12)
monsters = Monster.load_monsters

GameWindow.new(player, monsters).start
