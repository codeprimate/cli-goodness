#!/usr/bin/env ruby -wKU
res = Array.new
res = %x(/usr/sbin/ioreg -p IODeviceTree -n "battery" -w 0).grep(/Battery/)[0].match(/\{(.*)\}/)[1].split(',')
stats = Hash.new

res.each do |d| 
  key, val = d.split("=")
  key.downcase!.delete!(" ")
  if key =~ /\"(.*)\"/
    key = $1
  end
  stats[:"#{key}"] = val
end

puts
puts "-------------------------------"
puts "         Battery Stats"
puts "-------------------------------"
puts
stats.each { |k, v| puts "#{k} => #{v}" }
percentOfOriginal = (stats[:capacity].to_f / stats[:absolutemaxcapacity].to_f) * 100
puts "Battery capacity is currently #{sprintf("%.2f", percentOfOriginal)}% of original."