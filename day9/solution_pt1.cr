input = [
  { "players" => 10, "last_marble" => 1618 },
  { "players" => 13, "last_marble" => 7999 },
  { "players" => 17, "last_marble" => 1104 },
  { "players" => 21, "last_marble" => 6111 },
  { "players" => 30, "last_marble" => 5807 },
]

# input = [
#   { "players" => 9, "last_marble" => 25 },
# ]

input.each do |game|
  current_marble = 1
  circle = [0]
  current_position = 0
  scores = [] of Int32
  game["players"].times do |i|
    scores.push(0)
  end
  current_player = 0
  while(current_marble <= game["last_marble"])
    current_player = 0 if current_player >= game["players"]
    if current_marble % 23 == 0
      scores[current_player] += current_marble
      current_position -= 7
      if current_position < 0
        current_position = circle.size + current_position
      end
      scores[current_player] += circle.delete_at(current_position)

    else
      if current_position + 1 == circle.size
        next_position = 0
        circle.insert(next_position + 1, current_marble)
        current_position = next_position + 1
      else
        current_position += 2
        circle.insert(current_position, current_marble)
      end
    end
    current_player += 1
    current_marble += 1
    # puts circle
  end
  puts scores.sort.last
end
