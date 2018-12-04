rectangles = Array(Hash(String, Int32)).new
File.read("input.txt").strip.split("\n").each do |line|
  this_hash = {} of String => Int32

  # Crystal needs to be able to infer that you've checked
  # that you've actually matched something before you're able to
  # use bracket notation for MatchData, otherwise you need to use
  # md.not_nil![1]?
  next unless md = line.match(/\#([0-9]+)\s@\s([0-9]+),([0-9]+):\s([0-9]+)x([0-9]+)/)
  this_hash["idx"]    = md[1].to_i
  this_hash["left"]   = md[2].to_i
  this_hash["top"]   = md[3].to_i
  this_hash["width"]  = md[4].to_i
  this_hash["height"] = md[5].to_i
  this_hash["right"] = md[2].to_i + md[4].to_i - 1
  this_hash["bottom"] = md[3].to_i + md[5].to_i - 1
  rectangles << this_hash
end

overlap_points = Array(Array(Int32)).new

if rectangles.all?
  rectangles.each_with_index do |first, i|
    overlap_count = 0;
    rectangles.each_with_index do |second, j|
      next if second == first
      overlap_width = 0
      overlap_height = 0
      overlap_x = nil
      overlap_y = nil

      # skip if there can be no overlap
      next if (first["right"] < second["left"] || second["right"] < first["left"] ||
              first["top"] > second["bottom"] || second["top"] > first["bottom"])

      # got some overlap
      if first["right"] >= second["right"] && first["left"] <= second["left"]
        # second is contained inside first from x perspective
        overlap_x = second["left"]
        overlap_width = second["width"]
      elsif second["right"] >= first["right"] && second["left"] <= first["left"]
        # first is contained inside second from x perspective
        overlap_x = first["left"]
        overlap_width = first["width"]
      elsif first["right"] >= second["right"]
        overlap_width = second["right"] - first["left"] + 1
        overlap_x = first["left"]
      else
        overlap_width = first["right"] - second["left"] + 1
        overlap_x = second["left"]
      end

      if first["top"] <= second["top"] && first["bottom"] >= second["bottom"]
        # second is contained inside first from y perspective
        overlap_y = second["top"]
        overlap_height = second["height"]
      elsif second["top"] <= first["top"] && second["bottom"] >= first["bottom"]
        # first is contained inside second from x perspective
        overlap_y = first["top"]
        overlap_height = first["height"]
      elsif first["top"] <= second["top"]
        overlap_height =  first["bottom"] - second["top"] + 1
        overlap_y = second["top"]
      else
        overlap_height = second["bottom"] - first["top"] + 1
        overlap_y = first["top"]
      end

      overlap_y.upto(overlap_y + overlap_height - 1) do |y|
        overlap_x.upto(overlap_x + overlap_width - 1) do |x|
          overlap_points << [ x, y ]
        end
      end

    end
  end
end
puts(overlap_points.uniq.size) if overlap_points.all?
