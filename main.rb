require_relative 'ui/game_window'
require_relative 'lib/monster'
require_relative 'lib/player'
require_relative 'lib/battle'
require_relative 'lib/story'


player = Player.new(name: "Xuin", hp: 12)
monsters = Monster.load_monsters
story = Story.new

GameWindow.new(player, monsters, story).start
