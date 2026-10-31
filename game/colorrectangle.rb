require "gosu"
require_relative "vector2"
require_relative "rectangle"
require_relative "camera"

class ColorRectangle < Rectangle
  attr_accessor :color

  def initialize(color, pos = Vector2.new(), size = Vector2.new(), draw_layer = 0, can_intersect = true, auto_update = true, auto_draw = true)
    super(nil, pos, size, draw_layer, can_intersect, auto_update, auto_draw)
    @color = color
  end

  def draw(camera)
    screen_pos = camera.convert_to_screen(@position)
    Gosu.draw_rect(screen_pos.x, screen_pos.y, size.x, size.y, color)
  end
end
