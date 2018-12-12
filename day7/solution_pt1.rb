if $PROGRAM_NAME == __FILE__

  input = %(
Step C must be finished before step A can begin.
Step C must be finished before step F can begin.
Step A must be finished before step B can begin.
Step A must be finished before step D can begin.
Step B must be finished before step E can begin.
Step D must be finished before step E can begin.
Step F must be finished before step E can begin.
  )

  big_hash = Hash.new { |hash, key| hash[key] = [] }
  input.strip.split("\n").each do |l|
    label = /step (.) can begin./.match(l)[1]
    prereq = /^Step (.) must/.match(l)[1]
    big_hash[label] << prereq
    big_hash[prereq] = [] unless big_hash[prereq]
  end

  answer = ''
  until big_hash.empty?
    remaining_keys = big_hash.keys.sort
    this_step = remaining_keys.select { |k| big_hash[k].length.zero? }.first
    big_hash.delete(this_step)
    answer += this_step
    big_hash.each { |k, _| big_hash[k] -= [this_step] }
  end
  puts answer
end
