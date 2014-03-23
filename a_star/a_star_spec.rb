require 'rspec'
require_relative 'a_star'
require 'set'

describe 'A star behaviour' do

  possible_moves = [:left, :right, :up, :down, :up_left, :up_right, :down_left, :down_right]
  movement_cost = { '@' => 1,
                    'X' => 1,
                    '.' => 1,
                    '*' => 2,
                    '^' => 3 }

  it 'should compute Manathan distance' do
    Distance.manathan([0,0], [0,0]).should == 0
    Distance.manathan([1,0], [0,0]).should == 1
    Distance.manathan([1,2], [0,1]).should == 2
  end

  it 'should find valid neighours' do
    A_star.valid_neighbours(["."], possible_moves, movement_cost, [0,0]).should == []
    A_star.valid_neighbours([".~"], possible_moves, movement_cost, [0,0]).should == []
    A_star.valid_neighbours([".."], possible_moves, movement_cost, [0,0]).should == [[0,1]]
    A_star.valid_neighbours([".^@",
                             "~.X"], possible_moves, movement_cost, [1,1]).to_set.should == [[0,0],[0,1],[0,2],[1,2]].to_set
  end

  it 'should pass the small test' do

  end

  it 'should pass the large map test' do

  end

end