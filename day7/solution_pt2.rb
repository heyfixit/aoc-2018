if $PROGRAM_NAME == __FILE__
  input = File.readlines('input.txt')
  big_hash = Hash.new { |hash, key| hash[key] = [] }

  input.each do |l|
    label = /step (.) can begin./.match(l)[1]
    prereq = /^Step (.) must/.match(l)[1]
    big_hash[label] << prereq
    big_hash[prereq] = [] unless big_hash[prereq]
  end

  time_elapsed = 0
  available_workers = 5
  time_per_step = 60
  active_jobs = []
  answer = ""
  until big_hash.empty?
    remaining_keys = big_hash.keys.sort
    current_steps = remaining_keys.select { |k| big_hash[k].length.zero? }.first(available_workers)
    current_steps.each do |step|
      next if active_jobs.index { |j| j[:job] == step }
      break if active_jobs.length > available_workers

      active_jobs.push({ :job => step, :finish => time_elapsed + ( step.ord - 64 + time_per_step) })
    end

    # jump time up to finish of next job(s)
    active_jobs.sort_by! { |j| j[:finish] }
    time_elapsed = active_jobs.first[:finish]

    finished_jobs = active_jobs.select { |j| j[:finish] <= time_elapsed }
    finished_jobs.each do |j|
      answer += j[:job]
      big_hash.delete(j[:job])
      big_hash.each { |k, _| big_hash[k] -= [j[:job]] }
    end
    active_jobs -= finished_jobs
  end
  puts "Final Answer: #{time_elapsed}"
end
