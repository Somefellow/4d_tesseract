# frozen_string_literal: true

require './matrix'

class Cube
  attr_accessor :points

  CONNECTIONS = [
    [0, 1],  # Edge between point 1 and point 2
    [0, 2],  # Edge between point 1 and point 3
    [0, 4],  # Edge between point 1 and point 5
    [1, 3],  # Edge between point 2 and point 4
    [1, 5],  # Edge between point 2 and point 6
    [2, 3],  # Edge between point 3 and point 4
    [2, 6],  # Edge between point 3 and point 7
    [3, 7],  # Edge between point 4 and point 8
    [4, 5],  # Edge between point 5 and point 6
    [4, 6],  # Edge between point 5 and point 7
    [5, 7],  # Edge between point 6 and point 8
    [6, 7]   # Edge between point 7 and point 8
  ].freeze

  def initialize
    # 8 points of [x, y, z]
    values = [-1, 1]
    @points = values.product(values, values)
  end

  def apply_rotation(axis, theta)
    cos_theta = Math.cos(theta)
    sin_theta = Math.sin(theta)

    rotation_matrix = case axis
                      when :x
                        [
                          [1, 0, 0],
                          [0, cos_theta, -sin_theta],
                          [0, sin_theta, cos_theta]
                        ]
                      when :y
                        [
                          [cos_theta, 0, sin_theta],
                          [0, 1, 0],
                          [-sin_theta, 0, cos_theta]
                        ]
                      when :z
                        [
                          [cos_theta, -sin_theta, 0],
                          [sin_theta, cos_theta, 0],
                          [0, 0, 1]
                        ]
                      else
                        raise ArgumentError, 'Unsupported axis.'
                      end

    @points = @points.map do |point|
      Matrix.multiply([point], rotation_matrix)[0]
    end
  end

  def projection
    CONNECTIONS.map do |connection|
      [[points[connection[0]][0], points[connection[0]][1]],
       [points[connection[1]][0], points[connection[1]][1]]]
    end
  end
end
