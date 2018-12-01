puts File.read('input.txt').split("\n").map(&:to_i).reduce(0, :+)
