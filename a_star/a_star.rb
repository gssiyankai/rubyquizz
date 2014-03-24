require 'set'

class Distance

  def self.manathan p1, p2
    p1.zip(p2).map { |c1, c2| (c1 - c2).abs }
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
    delta_moves.map { |delta_x, delta_y| [x+delta_x, y+delta_y] }
               .select { |n_x, n_y|
                  n_x>=0 && n_y>=0 && n_x<height && n_y<width && movement_cost.include?(map[n_x][n_y])
               }
  end

  def self.find_position map, tile
    map.each_with_index.map { |row, i| [i, row.index(tile)] }
                       .find { |_, y| not y.nil? }
  end

  def self.heuristic_cost p1, p2
    Distance.manathan p1, p2
  end

  def self.find_path map, start, goal, possible_moves, movement_cost
    start_position, goal_position = [start, goal].map { |tile| find_position(map, tile) }
    evaluated_nodes = Set.new
    opened_nodes = Set.new [start_position]
    navigated_nodes = Hash.new
    g_score = { start_position => 0 }
    f_score = { start_position => heuristic_cost(start_position, goal_position) }

    while not opened_nodes.empty?
      current = opened_nodes.map { |node| [f_score[node], node] }.min.last
      if current == goal_position
        return reconstruct_path navigated_nodes, goal_position
      end

      opened_nodes.delete current
      evaluated_nodes.add current

      valid_neighbours(map, possible_moves, movement_cost, current).reject { |n| evaluated_nodes.include? n }
                                                                   .each { |n|
        n_x, n_y = n
        tentative_g_score = g_score[current] + movement_cost[map[n_x][n_y]]
        if not opened_nodes.include?(n) or tentative_g_score < g_score[n]
          navigated_nodes[n] = current
          g_score[n] = tentative_g_score
          f_score[n] = g_score[n] + heuristic_cost(n, goal_position)
          if not opened_nodes.include?(n)
            opened_nodes.add n
          end
        end
      }
    end

    raise "No path found"
  end

  private
  def self.reconstruct_path navigated_nodes, current_node
    previous_node = navigated_nodes[current_node]
    if previous_node.nil?
      [current_node]
    else
      reconstruct_path(navigated_nodes, previous_node) + [current_node]
    end
  end

end
