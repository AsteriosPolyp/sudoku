require 'matrix'

class Matrix
    def []=(i, j, x)
        @rows[i][j]= x
    end
end

class Sudoku
	def initialize
		@neo = Matrix.build(9) {}
		fill_matrix
	end

	def solve
		until @neo.inject(0) { |sum, e| sum += e.to_i } == 405 do
			@neo.each_with_index { |e, row, col| check_n_fill(row, col) }
		end
	end

	def show
		(0...9).each do |i|
		    puts "-----------------------------------------------"
			puts (0...9).inject("||") { |str, n| str + " #{@neo.element(i,n) != nil ? @neo.element(i,n) : "x" } ||" }
		end
	end

	private
	def fill_matrix
		@neo.[]=(0,2,8)
		@neo.[]=(0,5,9)
		@neo.[]=(0,8,7)
		@neo.[]=(1,1,4)
		@neo.[]=(1,4,1)
		@neo.[]=(1,7,9)
		@neo.[]=(2,0,6)
		@neo.[]=(2,3,4)
		@neo.[]=(2,6,1)
		@neo.[]=(3,0,1)
		@neo.[]=(3,3,6)
		@neo.[]=(3,5,4)
		@neo.[]=(4,1,3)
		@neo.[]=(4,4,5)
		@neo.[]=(4,7,6)
		@neo.[]=(5,2,5)
		@neo.[]=(5,5,4)
		@neo.[]=(5,8,2)
		@neo.[]=(6,2,1)
		@neo.[]=(6,5,8)
		@neo.[]=(6,8,4)
		@neo.[]=(7,1,2)
		@neo.[]=(7,4,4)
		@neo.[]=(7,7,5)
		@neo.[]=(8,0,3)
		@neo.[]=(8,3,2)
		@neo.[]=(8,6,7)
	end

	def check_n_fill(x, y)
		current_row = @neo.row(x).to_a
		current_col = @neo.column(y).to_a
		square_coords = square_coords(x, y)
		current_square = @neo.minor(*square_coords).to_a.flatten
		leftovers = leftovers(x, y, current_square, square_coords)
		possible = (1..9).to_a - (current_square + current_col + current_row)
		col = leftovers['col_leftovers'].inject(Array.new) do |arr, e| arr << e if leftovers['col_leftovers'].count(e) > 1 
			arr.uniq
		end
		row = leftovers['row_leftovers'].inject(Array.new) do |arr, e| arr << e if leftovers['row_leftovers'].count(e) > 1 
			arr.uniq
		end
		num = possible & (row + col)
		@neo.[]=(x, y, num.join.to_i) if num.count == 1

	end

	def square_coords(x, y)
	    if x < 3 && y < 3
	        [0,2,0,2]
	    elsif x < 3 && (y > 2 && y < 6)
	        [0,2,3,5]
	    elsif x < 3 && (y > 5 && y <= 8)
	        [0,2,6,8]
	    elsif (x > 2 && x < 6) && y < 3
	        [3,5,0,2]
	    elsif (x > 2 && x < 6) && (y > 2 && x < 6)
	        [3,5,3,5]
	    elsif (x > 2 && x < 6) && (y > 5 && y <= 8)
	        [3,5,6,8]
	    elsif (x > 5 && y <=8) && y < 3
	        [6,8,0,2]
	    elsif (x > 5 && y <=8) && (y > 2 && y < 6)
	        [6,8,3,5]
	    else
	        [6,8,6,8]
	    end
	end

	def leftovers(x, y, square, coords)
		row_coords = ((coords[0].to_i)..(coords[1].to_i)).to_a
		col_coords = ((coords[2].to_i)..(coords[3].to_i)).to_a
		#@current_row_leftovers = @neo.row(0).to_a + @neo.row(1).to_a + @neo.row(2).to_a - @neo.row(x).to_a - square
		result = {}
		result['row_leftovers'] = row_coords.inject([]) { |a, e| a + @neo.row(e).to_a } - @neo.row(x).to_a - square
		puts result['row_leftovers']
        result['col_leftovers'] = col_coords.inject([]) { |a, e| a + @neo.column(e).to_a } - @neo.column(x).to_a - square

	end

	def compare
		col = column_leftovers.inject(Array.new) do |arr, e| arr << e if column_leftovers.count(e) > 1 
			arr.uniq
		end
		row = row_leftovers.inject(Array.new) do |arr, e| arr << e if row_leftovers.count(e) > 1 
			arr.uniq
		end
		num = possible_num & (row + col)
		@neo.[]=(x, y, num.join.to_i) if num.count == 1
	end
end


sudo = Sudoku.new

sudo.show
sudo.solve
sudo.show