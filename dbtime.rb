#!/usr/bin/ruby


sum = 0.0
queries = 0
last_time = Time.now
IO.popen("tail -f log/development.log") do |pipe|
  pipe.each do |line|
    if (Time.now - last_time) > 10.0
      puts "Sum reset."
      sum = 0.0
      queries = 0
      last_time = Time.now
    end
    old_sum = sum.to_f
    unless line.match(/(Rendered|Completed)/)
      line.scan(/\(([0-9]+\.?[0-9]+?)\)/).each{|x| sum += x.first.to_f}
      if sum > old_sum
        queries += 1
        puts "#{queries} queries => #{sum}s"
      end
    end
  end
end
