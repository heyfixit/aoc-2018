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
  # input = File.readlines('input.txt')
  big_hash = Hash.new { |hash, key| hash[key] = [] }

  input.strip.split("\n").each do |l|
  # input.each do |l|
    label = /step (.) can begin./.match(l)[1]
    prereq = /^Step (.) must/.match(l)[1]
    big_hash[label] << prereq
    big_hash[prereq] = [] unless big_hash[prereq]
  end

  time_elapsed = 0
  available_workers = 2
  time_per_step = 0
  active_jobs = []
  until big_hash.empty?
    remaining_keys = big_hash.keys.sort
    current_steps = remaining_keys.select { |k| big_hash[k].length.zero? }.first(available_workers)
    puts "Current Steps:::::"
    puts current_steps
    available_workers -= current_steps.length
    puts "available_workers: #{available_workers}"
    current_steps.each do |step|
      next if active_jobs.index { |j| j[:job] == step }
      active_jobs.push({ :job => step, :finish => time_elapsed + ( step.ord - 64 + time_per_step) })
    end
    puts "active_jobs:::::"

    # jump time up to finish of next job(s)
    active_jobs.sort_by! { |j| j[:finish] }
    puts active_jobs
    gets
    time_elapsed = active_jobs.first[:finish]

    finished_jobs = active_jobs.select { |j| j[:finish] <= time_elapsed }
    finished_jobs.each do |j|
      big_hash.delete(j[:job])
      big_hash.each { |k, _| big_hash[k] -= [j[:job]] }
    end
    active_jobs -= finished_jobs
    available_workers += finished_jobs.length
  end
  puts time_elapsed
end
