
class Distance

  def self.manathan p1, p2
    p1.zip(p2).map { |c1, c2| (c1 - c2.abs) }
              .reduce(:+)
  end

end

class A_star

  @@moves = { :left       => [ 0,-1],
              :right      => [ 0, 1],
              :up         => [-1, 0],
              :down       => [ 1, 0],
              :up_left    => [-1,-1],
              :up_right   => [-1, 1],
              :down_left  => [ 1,-1],
              :down_right => [ 1, 1] }


  def self.valid_neighbours map, possible_moves, movement_cost, position
    height, width = [map.size, map[0].size]
    x,y = position
    delta_moves = possible_moves.map { |move| @@moves[move] }
    neighbours = delta_moves.map { |delta_x, delta_y| [x+delta_x, y+delta_y] }
                            .select { |n_x, n_y|
                              n_x>=0 && n_y>=0 && n_x<height && n_y<width && movement_cost.include?(map[n_x][n_y])
                            }
  end

end
