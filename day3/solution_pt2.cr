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
# overlap_counts = Hash(String, Int32)

if rectangles.all?
  rectangles.each_with_index do |first, i|
    # overlap_counts[first["idx"]] = 0
    overlap_count = 0
    rectangles.each_with_index do |second, j|
      next if second == first
      overlap_width = 0
      overlap_height = 0
      overlap_x = nil
      overlap_y = nil

      # skip if there can be no overlap
      next if (first["right"] < second["left"] || second["right"] < first["left"] ||
              first["top"] > second["bottom"] || second["top"] > first["bottom"])

      overlap_count += 1
    end

    if overlap_count == 0
      puts "Found ID with no overlaps #{first["idx"]}"
    end
  end
end
