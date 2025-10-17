require_relative 'ui/game_window'
require_relative 'lib/monster'
require_relative 'lib/player'
require_relative 'lib/battle'


player = Player.new(name: "Xuin", hp: 12)
monsters = Monster.load_monsters

GameWindow.new(player, monsters).start
