input = [
  { "players" => 458, "last_marble" => 7201900 },
]

input.each do |game|
  circle = Deque.new([0])
  scores = [] of Int64
  num_players = game["players"]
  num_players.times do |i|
    scores.push(0_i64)
  end
  last_marble = game["last_marble"]
  (1..last_marble).each do |m|
    if m % 23 == 0
      circle.rotate!(-7)
      popped = circle.pop()
      scores[m % num_players] += m + popped
      circle.rotate!(1)
    else
      circle.rotate!(1)
      circle.push(m)
    end
  end
  puts scores.sort.last
end
