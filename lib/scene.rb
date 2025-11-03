class Scene
    attr_reader :id, :title, :text, :image, :triggers, :choices

    def initialize(id:, title:, text:, image: nil, triggers: nil, choices: nil)
        @id = id
        @title = title
        @text = text
        @image = image
        @triggers = triggers
        @choices = choices || {}
    end

    def to_h
        {
        id: @id,
        title: @title,
        text: @text,
        image: @image,
        triggers: @triggers,
        choices: @choices
        }
    end
end
