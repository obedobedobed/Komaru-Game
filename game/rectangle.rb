require "gosu"
require_relative "vector2"
require_relative "camera"

class Rectangle
  attr_accessor :position
  attr_accessor :size
  attr_accessor :can_intersect
  attr_accessor :auto_update
  attr_accessor :auto_draw
  attr_accessor :draw_layer

  def initialize(sprite, pos = Vector2.new(), size = Vector2.new(), draw_layer = 0, can_intersect = true, auto_update = true, auto_draw = true)
    @sprite = sprite
    @position = pos
    @size = size
    @can_intersect = can_intersect
    @auto_update = auto_update
    @auto_draw = auto_draw
    @draw_layer = draw_layer
    @flip_x = false
    @flip_y = false
  end

  def update(delta)

  end

  def draw(camera)
    scale_x = @size.x.to_f / @sprite.width
    scale_y = @size.y.to_f / @sprite.height

    scale_x *= -1 if @flip_x
    scale_y *= -1 if @flip_y

    screen_pos = camera.convert_to_screen(@position)
    screen_pos.x += @size.x if @flip_x
    screen_pos.y += @size.y if @flip_y

    @sprite.draw(screen_pos.x, screen_pos.y, @draw_layer, scale_x, scale_y)
  end

  def intersects?(rectangle)
    return @position.x + @size.x > rectangle.position.x &&
      @position.x < rectangle.position.x + rectangle.size.x &&
      @position.y + @size.y > rectangle.position.y &&
      @position.y < rectangle.position.y + rectangle.size.y &&
      @can_intersect && rectangle.can_intersect
  end
end
