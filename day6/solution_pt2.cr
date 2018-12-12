class Coordinate
  property label
  property closest_count
  property area_infinite

  def initialize(coord : Array(Int32), @label : String = "")
    @coord = coord
    @closest_count = 0
    @area_infinite = false
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
  # input = File.read_lines("input.txt").map do |l|
  #   Coordinate.new(l.split(", ").map { |n| n.to_i })
  # end

  labels = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("");
  # example input
  input = [[1,1],[1,6],[8,3],[3,4],[5,5],[8,9]].map do |c|
    Coordinate.new(c, labels.shift)
  end

  x_min = input.sort_by { |a| a.x }.first.x
  x_max = input.sort_by { |a| a.x }.last.x
  y_min = input.sort_by { |a| a.y }.first.y
  y_max = input.sort_by { |a| a.y }.last.y

  region_point_count = 0
  (y_min - 1).upto(y_max + 1) do |y|
    (x_min - 1).upto(x_max + 1) do |x|
      this_total_dist = 0
      input.each do |c|
        this_total_dist += c.distance_to([x,y])
      end
      if this_total_dist < 32
        region_point_count += 1
      end
    end
  end

  puts "# of regeions with < 1000 total distance: #{region_point_count}"
end
