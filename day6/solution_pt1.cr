class Coordinate
  property label
  property closest_count
  def initialize(coord : Array(Int32), @label : String = "")
    @coord = coord
    @closest_count = 0
  end

  def x
    return @coord.first
  end

  def y
    return @coord.last
  end

  def distance_to(point)
    return (x - point[0]).abs + (y - point[1]).abs
  end

end

if PROGRAM_NAME.index(File.basename(__FILE__, ".cr"))
  labels = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("");
  # input = File.read_lines("input.txt").map do |l|
  #   l.split(", ")
  # end

  # example input
  input = [[1,1],[1,6],[8,3],[3,4],[5,5],[8,9]].map do |c|
    Coordinate.new(c, labels.shift)
  end

  x_min = input.sort_by { |a| a.x }.first.x
  x_max = input.sort_by { |a| a.x }.last.x
  y_min = input.sort_by { |a| a.y }.first.y
  y_max = input.sort_by { |a| a.y }.last.y

  (y_min - 1).upto(y_max + 1) do |y|
    (x_min - 1).upto(x_max + 1) do |x|
      known_point_idx = input.index {|c| c.x == x && c.y == y}
      if known_point_idx
        print input[known_point_idx].label
        input[known_point_idx].closest_count += 1
      else
        distances = input.map_with_index do |c, idx|
          { "index" => idx, "distance" => c.distance_to([x,y]) }
        end

        sorted = distances.sort_by { |a| a["distance"] }
        if sorted[0]["distance"] == sorted[1]["distance"]
          print "."
        else
          print input[sorted[0]["index"]].label.downcase
        end
      end
    end
    print "\n"
  end
end
