require_relative "vector2"
require_relative "rectangle"

class Camera
  attr_accessor :position

  def initialize(position = Vector2.new())
    @position = position
  end

  def convert_to_screen(position)
    return Vector2.new(position.x - @position.x, position.y - @position.y)
  end

  def follow(rectangle, window_size)
    centrized_window = Vector2.new(window_size.x / 2, window_size.y / 2)
    @position = Vector2.new(rectangle.position.x + rectangle.size.x / 2 - centrized_window.x, rectangle.position.y + rectangle.size.y / 2 - centrized_window.y)
  end
end
