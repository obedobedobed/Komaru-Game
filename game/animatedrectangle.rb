require "gosu"
require_relative "vector2"
require_relative "rectangle"

class AnimatedRectangle < Rectangle
  def initialize(frames, pos = Vector2.new(), size = Vector2.new(), frame_time = 0.25, draw_layer = 0, can_intersect = true, auto_update = true, auto_draw = true)
    super(frames[0], pos, size, draw_layer, can_intersect, auto_update, auto_draw)
    @frames = frames
    @current_frame = 0
    @frame_time = frame_time
    @frame_time_now = @frame_time
  end

  def update(delta)
    if (@frame_time_now -= delta) <= 0
      @current_frame += 1
      @frame_time_now = @frame_time

      if @current_frame >= @frames.length
        @current_frame = 0  
      end
      
      @sprite = @frames[@current_frame]
    end
  end
end
