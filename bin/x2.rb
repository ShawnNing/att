require 'time'
t1 = Time.parse("Jan 1, 2014 3:23PM")
puts t1
t2 = Time.parse("Jan 1, 2014 10:04PM")
puts t2
#puts (((t2-t1)/3600.0-0.5)*4.0+0.5).to_i/4.0
puts ((t2-t1)/3600.0-0.5)*4