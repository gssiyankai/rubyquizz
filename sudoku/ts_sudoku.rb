require "sudoku"
require "test/unit"
 
class TestSudoku  < Test::Unit::TestCase
 
  def setup
    @puzzle = File.readlines "puzzle1.txt"
    @solved_puzzle = File.readlines "puzzle2.txt"
  end
  
  def test_given_a_puzzle_when_sudoku_solver_is_initialized_then_the_solver_contains_a_9x9_grid
    sudoku = Sudoku.new @puzzle
    assert_equal [[0,6,0,1,0,4,0,5,0],
                  [0,0,8,3,0,5,6,0,0],
                  [2,0,0,0,0,0,0,0,1],
                  [8,0,0,4,0,7,0,0,6],
                  [0,0,6,0,0,0,3,0,0],
                  [7,0,0,9,0,1,0,0,4],
                  [5,0,0,0,0,0,0,0,2],
                  [0,0,7,2,0,6,9,0,0],
                  [0,4,0,5,0,8,0,7,0]], sudoku.grid
    
    sudoku = Sudoku.new @solved_puzzle
    assert_equal [[9,6,3,1,7,4,2,5,8],
                  [1,7,8,3,2,5,6,4,9],
                  [2,5,4,6,8,9,7,3,1],
                  [8,2,1,4,3,7,5,9,6],
                  [4,9,6,8,5,2,3,1,7],
                  [7,3,5,9,6,1,8,2,4],
                  [5,8,9,7,1,3,4,6,2],
                  [3,1,7,2,4,6,9,8,5],
                  [6,4,2,5,9,8,1,7,3]], sudoku.grid
  end
  
  def test_given_an_already_solved_puzzle_when_sudoku_solver_solves_this_puzzle_then_the_solution_is_human_readable
    sudoku = Sudoku.new @solved_puzzle
    sudoku.solve
    assert_equal @solved_puzzle, sudoku.solution
  end
  
  def test_given_an_unsolved_puzzle_when_sudoku_solver_is_initialized_then_the_solver_computes_all_possible_digits_of_a_blank
    sudoku = Sudoku.new(@puzzle)
    assert_equal [6,7,8], sudoku.possible_column_digits(sudoku.grid, 4, 3)
    assert_equal [1,2,4,5,7,8,9], sudoku.possible_row_digits(sudoku.grid, 4, 3)
    assert_equal [2,3,5,6,8], sudoku.possible_3x3_box_digits(sudoku.grid, 4, 3)
    assert_equal [8], sudoku.possible_digits(sudoku.grid, 4, 3)
    
    assert_equal [2,3,9], sudoku.possible_column_digits(sudoku.grid, 2, 5)
    assert_equal [3,4,5,6,7,8,9], sudoku.possible_row_digits(sudoku.grid, 2, 5)
    assert_equal [2,6,7,8,9], sudoku.possible_3x3_box_digits(sudoku.grid, 2, 5)
    assert_equal [9], sudoku.possible_digits(sudoku.grid, 2, 5)
  end
  
  def test_given_a_puzzle_when_sudoku_solver_is_initialized_then_the_solver_can_determine_if_the_puzzle_is_solved
    sudoku = Sudoku.new(@puzzle)
    assert !sudoku.is_puzzle_solved(sudoku.grid)
    
    sudoku = Sudoku.new(@solved_puzzle)
    assert sudoku.is_puzzle_solved(sudoku.grid)
  end
  
  def test_given_a_puzzle_when_sudoku_solver_is_initialize_then_the_solver_can_duplicate_grid
    sudoku = Sudoku.new(@puzzle)
    clone_grid = sudoku.clone_grid sudoku.grid
    clone_grid[0][0] = 9
    assert clone_grid[0][0] != sudoku.grid[0][0]
  end
  
  def test_given_a_puzzle_when_sudoku_solver_is_initialize_then_the_solver_computes_a_solution
    sudoku = Sudoku.new(@puzzle)
    sudoku.solve
    assert_equal @solved_puzzle, sudoku.solution
  end
  
end
