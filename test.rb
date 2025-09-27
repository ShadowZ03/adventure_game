require 'ruby2d'

music = Music.new('./assets/audio/to_battle.wav', loop: true)
music.play


set title: "Hello Ruby2D"
set background: 'navy'

Text.new("Hello World", x: 50, y: 50, size: 30, color: 'yellow')
goblin = Image.new('./assets/monsters/goblin.webp', x: 50, y: 50)

slash = Sound.new('./assets/audio/knifesharpener1.flac')


on :key_down do |event|
    if event.key == 'space'
        puts "You attack!"
        slash.play
    elsif event.key == 'escape'
        close  # closes the window
    end
end


show
