require "gosu"
require_relative "game/rectangle"
require_relative "game/vector2"
require_relative "game/colorrectangle"
require_relative "game/player"
require_relative "game/camera"
require_relative "game/animatedrectangle"

class Game < Gosu::Window
  def initialize
    @window_size = Vector2.new(1000, 600)

    super(@window_size.x, @window_size.y)
    self.caption = "Komaru Game"
    load
  end

  def load
    @rectangles = []
    @coins = []

    @rectangles << @ground = ColorRectangle.new(Gosu::Color.new(255, 39, 153, 31), Vector2.new(0, 0), Vector2.new(1500, 1500), -1)
    @rectangles << @player = Player.new(Gosu::Image.load_tiles("assets/player.png", 290, 290), Vector2.new(@ground.size.x / 2, @ground.size.y / 2), Vector2.new(100, 100), 1)
    @rectangles << @button = ColorRectangle.new(Gosu::Color.new(255, 255, 255, 255), Vector2.new(@ground.size.x / 2, @ground.size.y / 2 - 200), Vector2.new(70, 70))

    for _ in 0...15
      x = rand(50..(@ground.size.x - 50 - 70))
      y = rand(50..(@ground.size.y - 50 - 70))

      coin = AnimatedRectangle.new(Gosu::Image.load_tiles("assets/coin.png", 16, 16, retro: true), Vector2.new(x, y), Vector2.new(70, 70), 0.25, 0.5)
      @rectangles << coin
      @coins << coin
    end

    for _ in 0...10
      x = rand(50..(@ground.size.x - 50 - 50))
      y = rand(50..(@ground.size.y - 50 - 50))
      flower = rand(1..2)

      @rectangles << Rectangle.new(Gosu::Image.new("assets/flower#{flower}.png", retro: true), Vector2.new(x, y), Vector2.new(50, 50))
    end

    @font = Gosu::Font.new(48)
    @small_font = Gosu::Font.new(36)
    @camera = Camera.new()
    @gg = false
  end

  def update
    delta = update_interval / 1000.0
    
    if !@gg
      @rectangles.each do |rect|
        if rect.auto_update
          rect.update(delta)
        end
      end

      if @player.intersects?(@button) && @player.coins >= 10
        @gg = true
        @button.color = Gosu::Color.new(255, 255, 0, 0)
      else
        @button.color = Gosu::Color.new(255, 255, 255, 255)
      end

      @coins.each do |coin|
        if @player.intersects?(coin) && @rectangles.include?(coin)
          @player.coins += 1
          @rectangles.delete(coin)
          @coins.delete(coin)
        end
      end

      @player.position.x = 0                               if @player.position.x < 0
      @player.position.x = @ground.size.x - @player.size.x if @player.position.x > @ground.size.x - @player.size.x
      @player.position.y = 0                               if @player.position.y < 0
      @player.position.y = @ground.size.y - @player.size.y if @player.position.y > @ground.size.y - @player.size.y

      @camera.follow(@player, @window_size)
    else
      load if Gosu.button_down?(Gosu::KB_SPACE)
    end

    close if Gosu.button_down?(Gosu::KB_ESCAPE)
  end

  def draw
    Gosu.draw_rect(0, 0, @window_size.x, @window_size.y, Gosu::Color.new(255, 100, 149, 237))

    @rectangles.each do |rect|
      if rect.auto_draw
        rect.draw(@camera)
      end
    end

    button_text = "Stand on this button when you collect 10 coins"
    button_text_x = @button.position.x + @button.size.x / 2 - @small_font.text_width(button_text) / 2
    button_text_y = @button.position.y - 60
    draw_global_pos_text(@small_font, button_text, Vector2.new(button_text_x, button_text_y), Vector2.new(1, 1), 0.9, Gosu::Color.new(255, 0, 50, 0))

    @font.draw_text("Komaru Game", 10, 20, 10, 1, 1, Gosu::Color::WHITE)
    @font.draw_text("Player: x#{@player.position.x.to_i} y#{@player.position.y.to_i}", 10, 80, 10, 1, 1, Gosu::Color::WHITE)
    @font.draw_text("Coins: #{@player.coins}", 10, 140, 10, 1, 1, Gosu::Color::WHITE)

    if @gg
      Gosu.draw_rect(0, 0, @window_size.x, @window_size.y, Gosu::Color.new(150, 0, 0, 0), 11)
      
      gg_text = "Congratulations!"
      gg_text_pos = get_centralized(gg_text, @font)
      @font.draw_text(gg_text, gg_text_pos.x, gg_text_pos.y - 40, 11, 1, 1, Gosu::Color::WHITE)

      again_text = "Press SPACE to play again"
      again_text_pos = get_centralized(again_text, @font)
      @font.draw_text(again_text, again_text_pos.x, again_text_pos.y, 11, 1, 1, Gosu::Color::WHITE)

      quit_text = "Press ESC to quit"
      quit_text_pos = get_centralized(quit_text, @font)
      @font.draw_text(quit_text, quit_text_pos.x, quit_text_pos.y + 40, 11, 1, 1, Gosu::Color::WHITE)
    end
  end

  def draw_global_pos_text(font, text, position, scale, layer, color)
    screen_pos = @camera.convert_to_screen(position)
    font.draw_text(text, screen_pos.x, screen_pos.y, layer, scale.x, scale.y, color)
  end

  def get_centralized(text, font)
    return Vector2.new(
      @window_size.x / 2 - font.text_width(text) / 2,
      @window_size.y / 2
    )
  end
end

Game.new.show
