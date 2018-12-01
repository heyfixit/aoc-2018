input = File.read('input.txt').split("\n").map(&:to_i)
# input = [7, 7, -2, -7, -4]

starting_frequency = 0
found_duplicate = false

# need an initial set
frequencies = input.reduce([starting_frequency]) do |memo, freq|
  memo.push(freq + memo.last)
end

while found_duplicate == false
  input.each do |change|
    this_one = frequencies.last + change
    if frequencies.index(this_one)
      puts this_one
      found_duplicate = true
      break
    end
    frequencies.push(this_one)
  end
end
