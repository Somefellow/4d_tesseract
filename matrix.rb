# frozen_string_literal: true

class Matrix
  def self.multiply(matrix1, matrix2)
    rows1 = matrix1.length
    cols1 = matrix1[0].length
    rows2 = matrix2.length
    cols2 = matrix2[0].length

    # Check if the matrices can be multiplied
    raise ArgumentError, 'Cannot multiply matrices. Invalid dimensions.' unless cols1 == rows2

    result = Array.new(rows1) { Array.new(cols2, 0) }

    (0...rows1).each do |i|
      (0...cols2).each do |j|
        sum = 0
        (0...cols1).each do |k|
          sum += matrix1[i][k] * matrix2[k][j]
        end
        result[i][j] = sum
      end
    end

    result
  end
end
