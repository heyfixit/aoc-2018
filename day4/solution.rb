require 'time'
module Shift
  class Event
    attr_accessor :timestamp, :guard_id, :is_sleep, :is_start

    def to_s
      "[#{@timestamp.strftime('%Y-%m-%d %H:%M')}]"\
      "#{" Guard ##{@guard_id} begins shift" if @guard_id}"\
      "#{' falls asleep' if @is_sleep}"\
      "#{' wakes up' if !@is_sleep && !@is_start}"\
    end
  end
  class EventParser
    attr_accessor :events
    @events = []

    def self.parse(string)
      # [1518-09-17 23:48] Guard #1307 begins shift
      # [1518-07-28 00:49] falls asleep
      event = Event.new
      event.timestamp = Time.strptime(
        string.match(/\[(\d+-\d+-\d+\s\d+:\d+)\]/)[1],
        '%Y-%m-%d %H:%M'
      )
      event.guard_id = string =~ /\sGuard\s#(\d+)\s/ ? Regexp.last_match[1] : nil
      event.is_start = string =~ /begins shift/ ? true : false
      event.is_sleep = string =~ /falls asleep/ ? true : false
      @events << event

      event
    end
  end
  class Guard
    attr_accessor :shift_events, :id
    def initialize(id)
      @id = id
    end
  end
end

if $PROGRAM_NAME == __FILE__
  input = File.read('input.txt').split("\n")
  # input = File.read('example_input.txt').split("\n")
  events = input.map do |line|
    Shift::EventParser.parse line
  end

  events.sort! { |x, y| x.timestamp <=> y.timestamp }
  sleep_histories = Hash.new(0)
  sleep_minutes = Hash.new { |hash, key| hash[key] = Hash.new(0) }
  while events.length > 0
    guard_event = events.shift
    current_id = guard_event.guard_id
    until events.first.nil? || events.first.guard_id
      sleep_event = events.shift
      wake_event = events.shift
      diff = (wake_event.timestamp - sleep_event.timestamp) / 60
      sleep_histories[current_id] += diff
      current_time = sleep_event.timestamp
      while current_time < wake_event.timestamp
        if ENV['DEBUG']
          puts "############### Checking Minutes for #{current_id} ##################"
          puts "Current Time: #{current_time.strftime('%Y-%m-%d %H:%M')}"
        end
        sleep_minutes[current_id][current_time.strftime("%M")] += 1
        if ENV['DEBUG']
          puts sleep_minutes[current_id]
          sleep 0.01
          print "\e[2J\e[f"
        end
        current_time += 60
      end
    end
  end
  lazy_guard = sleep_histories.to_a.sort_by { |a| a[1] }.last
  lazy_guard_minutes = sleep_minutes[lazy_guard.first]
  highest_minute = lazy_guard_minutes.to_a.sort_by{|a| a[1]}.last
  puts "Laziest Guard ID: " + lazy_guard.first.to_s
  puts "His Highest Frequency Minute: " + highest_minute.join(": ")
  puts highest_minute.first.to_i * lazy_guard.first.to_i
  highest_frequency_minutes = []
  puts "Highest Overall Minutes"
  sleep_minutes.each do |k,v|
    hfm = v.to_a.sort_by{|a| a[1]}.last
    this_one = {}
    this_one[:guard] = k
    this_one[:minute] = hfm[0]
    this_one[:count] = hfm[1]
    highest_frequency_minutes << this_one
  end
  highest_frequency_overall = highest_frequency_minutes.sort_by {|a| a[:count]}.last
  puts "HFM Guard: #{highest_frequency_overall[:guard]}"
  puts "HFM Minute: #{highest_frequency_overall[:minute]}"
  puts "Part 2 answer: #{highest_frequency_overall[:guard].to_i * highest_frequency_overall[:minute].to_i}"
end
