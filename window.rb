# frozen_string_literal: true

require 'gosu'
require './tesseract'

PERSPECTIVE_4D = 4
PERSPECTIVE_3D = 4

class Window < Gosu::Window
  attr_reader :tesseract

  def initialize(size)
    super size, size, false
    self.caption = '4D Hyper-cube / Tesseract'
    @tesseract = Tesseract.new
  end

  def update
    return if @pause

    @tesseract.apply_rotation(:xz, Math::PI * 0.002)
    @tesseract.apply_rotation(:yw, Math::PI * 0.005)
  end

  def draw
    @tesseract.pairs_2d.each do |pair|
      draw_line(
        scale_value(pair[0][0]),
        scale_value(pair[0][1]),
        Gosu::Color::WHITE,
        scale_value(pair[1][0]),
        scale_value(pair[1][1]),
        Gosu::Color::WHITE
      )

      pair.each do |x, y|
        radius = 5
        draw_quad(
          scale_value(x) - radius,
          scale_value(y) - radius,
          Gosu::Color::WHITE,
          scale_value(x) - radius,
          scale_value(y) + radius,
          Gosu::Color::WHITE,
          scale_value(x) + radius,
          scale_value(y) - radius,
          Gosu::Color::WHITE,
          scale_value(x) + radius,
          scale_value(y) + radius,
          Gosu::Color::WHITE
        )
      end
    end
  end

  def button_down(id)
    return unless id == Gosu::MsLeft

    @pause = !@pause
  end

  private

  def scale_value(value)
    value = value * PERSPECTIVE_4D * PERSPECTIVE_3D
    ((width / 4) + (value - -1) * (width / 2) / (1 - -1))
  end
end
