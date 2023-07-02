# frozen_string_literal: true

require './matrix'

class Tesseract
  attr_accessor :points

  CONNECTIONS_3D = [
    [0, 1],
    [0, 2],
    [0, 4],
    [1, 3],
    [1, 5],
    [2, 3],
    [2, 6],
    [3, 7],
    [4, 5],
    [4, 6],
    [5, 7],
    [6, 7]
  ].freeze

  CONNECTIONS_4D = [
    [0, 1], [0, 2], [0, 4], [0, 8],
    [1, 3], [1, 5], [1, 9],
    [2, 3], [2, 6], [2, 10],
    [3, 7], [3, 11],
    [4, 5], [4, 6], [4, 12],
    [5, 7], [5, 13],
    [6, 7], [6, 14],
    [7, 15],
    [8, 9], [8, 10], [8, 12],
    [9, 11], [9, 13],
    [10, 11], [10, 14],
    [11, 15],
    [12, 13], [12, 14],
    [13, 15],
    [14, 15]
  ].freeze

  def initialize
    values = [-1, 1]
    @points = values.product(values, values, values)
  end

  def apply_rotation(plane, theta)
    cos_theta = Math.cos(theta)
    sin_theta = Math.sin(theta)

    rotation_matrix = case plane
                      when :xy
                        [
                          [cos_theta, -sin_theta, 0, 0],
                          [sin_theta, cos_theta, 0, 0],
                          [0, 0, 1, 0],
                          [0, 0, 0, 1]
                        ]
                      when :xz
                        [
                          [cos_theta, 0, -sin_theta, 0],
                          [0, 1, 0, 0],
                          [sin_theta, 0, cos_theta, 0],
                          [0, 0, 0, 1]
                        ]
                      when :yz
                        [
                          [1, 0, 0, 0],
                          [0, cos_theta, -sin_theta, 0],
                          [0, sin_theta, cos_theta, 0],
                          [0, 0, 0, 1]
                        ]
                      when :xw
                        [
                          [cos_theta, 0, 0, -sin_theta],
                          [0, 1, 0, 0],
                          [0, 0, 1, 0],
                          [sin_theta, 0, 0, cos_theta]
                        ]
                      when :yw
                        [
                          [1, 0, 0, 0],
                          [0, cos_theta, 0, -sin_theta],
                          [0, 0, 1, 0],
                          [0, sin_theta, 0, cos_theta]
                        ]
                      when :zw
                        [
                          [1, 0, 0, 0],
                          [0, 1, 0, 0],
                          [0, 0, cos_theta, -sin_theta],
                          [0, 0, sin_theta, cos_theta]
                        ]
                      else
                        raise ArgumentError, 'Unsupported plane.'
                      end

    @points = @points.map do |point|
      Matrix.multiply([point], rotation_matrix)[0]
    end
  end

  def projection_3d
    @points.map do |point|
      w = 1 / (PERSPECTIVE_4D - point[3])
      [point[0] * w, point[1] * w, point[2] * w]
    end
  end

  def projection_2d
    projection_3d.map do |point|
      z = 1 / (PERSPECTIVE_3D - point[2])
      [point[0] * z, point[1] * z]
    end
  end

  def pairs_2d
    projection = projection_2d
    CONNECTIONS_4D.map do |connection|
      connection.map do |i|
        projection[i]
      end
    end
  end
end
