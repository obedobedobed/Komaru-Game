require "gosu"
require_relative "rectangle"
require_relative "animatedrectangle"

class Player < AnimatedRectangle
  attr_accessor :coins

  def initialize(frames, pos = Vector2.new(), size = Vector2.new(), draw_layer = 0)
    super(frames, pos, size, 0.2, draw_layer, true, true, true)
    @speed = 180
    @idle_frames = [frames[0]]
    @run_frames = [frames[0], frames[1]]
    @coins = 0

    @animations = { idle: @idle_frames, run: @run_frames }
    @cur_animation = @idle_frames

    @last_pos = Vector2.new()
  end

  def update(delta)
    get_input(delta)
    animate(delta)

    @last_pos.x = @position.x
    @last_pos.y = @position.y
  end

  def get_input(delta)
    move(x:  @speed * delta) if Gosu.button_down?(Gosu::KB_D)
    move(x: -@speed * delta) if Gosu.button_down?(Gosu::KB_A)
    move(y:  @speed * delta) if Gosu.button_down?(Gosu::KB_S)
    move(y: -@speed * delta) if Gosu.button_down?(Gosu::KB_W)
  end

  def move(x: 0, y: 0) 
    @position.x += x
    @position.y += y

    if x > 0
      @flip_x = false
    elsif x < 0
      @flip_x = true
    end
  end

  def animate(delta)
    if run?
      set_anim(:run)
    else
      set_anim(:idle)
    end

    if (@frame_time_now -= delta) <= 0
      @current_frame += 1
      @frame_time_now = @frame_time

      if @current_frame >= @cur_animation.length
        @current_frame = 0  
      end
      
      @sprite = @cur_animation[@current_frame]
    end
  end

  def set_anim(key)
    @cur_animation = @animations[key]
  end

  def run?
    return @position.x != @last_pos.x || @position.y != @last_pos.y
  end
end
