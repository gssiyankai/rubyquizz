class Sudoku
  
  attr_reader :grid
  
  def initialize puzzle
    @grid = puzzle.map { |line|
              line.chomp.gsub /[ |+-]/, ''
            }.select { |line|
              !line.empty?
            }.map { |line|
              line.split(//).map { |c|
                c.to_i
              }
            }
  end
  
  def solve
    @solved_grid = solve_brute_force @grid
  end
  
  def solve_brute_force grid    
    clone_grid = clone_grid grid
    (0..9).each { |i|
      grid_possible_digits = grid_possible_digits clone_grid
      grid_possible_digits.each_with_index { |row_digits, x|
        row_digits.each_with_index { |digits, y|
          if clone_grid[x][y]==0 and digits.size==i
            possible_digits = possible_digits clone_grid, x, y
            digits.each { |digit|
              if possible_digits.include?(digit)
                clone_grid[x][y] = digit
                solved_grid = solve_brute_force clone_grid
                if solved_grid!=nil
                  return solved_grid
                else
                  digits.delete digit
                  clone_grid[x][y] = 0
                end
              end
            }
            if digits.empty?
              return nil
            end
          end
        }
      }
    }
    
    if is_puzzle_solved clone_grid
      return clone_grid
    else
      nil
    end
  end
  
  def grid_possible_digits grid
    (0..8).map { |x|
      (0..8).map { |y|
        if grid[x][y]==0
          possible_digits grid, x, y
        end
      }
    }
  end
  
  def clone_grid grid
    grid.map { |row|
      row.clone
    }
  end
  
  def solution solved_grid=@solved_grid
    (0..12).map { |i|
      if i%4==0
        "+-------+-------+-------+\n"
      else
        grid_x = i - i/4 - 1
        xxx = solved_grid[grid_x].each_with_index.map { |val, j|
          case j%3
            when 0
              "| " + val.to_s
            when 1
              " " + val.to_s + " "
            when 2
              val.to_s + " "
          end
        }.join + "|\n"
        end
      }
  end
  
  def possible_column_digits grid, x, y
    digits = [1,2,3,4,5,6,7,8,9]
    digits.delete grid[x][y]
    column_digits = grid.map { |row|
                      row[y]
                    }
    digits.select { |digit|
      !column_digits.include?(digit)
    }
  end
  
  def possible_row_digits grid, x, y
    digits = [1,2,3,4,5,6,7,8,9]
    digits.delete grid[x][y]
    digits.select { |digit|
      !grid[x].include?(digit)
    }
  end
  
  def possible_3x3_box_digits grid, x,y
    digits = [1,2,3,4,5,6,7,8,9]
    digits.delete grid[x][y]
    start_x = x - x%3
    start_y = y - y%3
    box_digits = [grid[start_x],grid[start_x+1],grid[start_x+2]].map { |row|
                   [row[start_y],row[start_y+1],row[start_y+2]]
                 }.flatten
    digits.select { |digit|
      !box_digits.include?(digit)
    }
  end
      
  def possible_digits grid, x, y
    digits = [1,2,3,4,5,6,7,8,9]
    digits.delete grid[x][y]
    column_digits = possible_column_digits(grid, x, y)
    row_digits = possible_row_digits(grid, x, y)
    box_digits = possible_3x3_box_digits(grid, x,y)
    digits.select { |digit|
      column_digits.include?(digit) and row_digits.include?(digit) and box_digits.include?(digit)
    }
  end
    
  def is_puzzle_solved grid=@solved_grid
    (0..8).each { |x|
      (0..8).each { |y|
        if grid[x][y]==0
          return false          
        end
      }
    }
    (0..8).each { |x|
      (0..8).each { |y|
        if possible_digits(grid, x, y).include?(grid[x][y])
          return false           
        end
      }
    }
    return true
  end
  
end


if $0 == __FILE__
  puzzle = ARGF.readlines
  puts "Puzzle:"
  puts puzzle
  sudoku = Sudoku.new puzzle
  sudoku.solve
  if sudoku.is_puzzle_solved
    puts "Solution:"
    puts sudoku.solution
  else
    puts "*** This puzzle has no solution."
  end
end
