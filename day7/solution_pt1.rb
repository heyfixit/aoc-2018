if $PROGRAM_NAME == __FILE__

  input = File.readlines('input.txt')
  big_hash = Hash.new { |hash, key| hash[key] = [] }
  input.each do |l|
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
