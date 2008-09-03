#AStar tester.
#by Marcin Coles
#27/Sep/2007

require 'time'
require 'astar/AMap'
include AStar

mapfile,startx,starty,goalx,goaly=ARGV
if ARGV.size < 5 then
  puts "usage: astar mapfile startx starty goalx goaly"
  puts "using defaults"
  mapfile,startx,starty,goalx,goaly='map.txt',0,0,5,0
end
puts "using: file #{mapfile}, start [#{startx},#{starty}], end [#{goalx},#{goaly}]"

mymap=AMap.load(mapfile)
puts "\nThe map"
puts mymap
start=mymap.co_ord(startx.to_i,starty.to_i)
finish=mymap.co_ord(goalx.to_i,goaly.to_i)
time1=Time.now
goal=mymap.astar(start,finish)
time2=Time.now
puts "The path"
curr=goal
while curr.parent do
  print "#{curr}<-"
  curr=curr.parent
end
  puts "#{curr}!!"
puts mymap.show_path(goal)
puts "A* processing time = #{time2-time1} seconds."