def test(n)
  while n < 987654322
    n += 1
    test = true
    (1..9).each do |i|
      #  Test to see if every number is in the string (except 0)
      test = false if n.to_s.index(i.to_s) == nil
    end
    return n if test == true
  end
  puts "tried everything"
end

def test2(n)
  a = n.to_s.split(//)
  a.each_index {|i| a[i] = a[i].to_i }
  r = a.length-1
  while r > 0
    if a[r] > a[r-1]
      smallest = nil
      a[r,a.length-1].sort.each {|s| smallest ||= s.to_i if s.to_i > a[r-1]}
      # puts "smallest = #{smallest} and a[r-1] = #{a[r-1]}"
      small_index = a.index(smallest)
      a[r-1], a[small_index] = a[small_index], a[r-1]
      a = a[0..r-1] + a[r..a.length-1].sort
      break
    else
      r -= 1
    end
  end
  a.to_s.to_i
end

def test_tests
  n = 349572681
  100.times do
    a = test(n)
    b = test2(n)
    puts a==b
    # puts "#{a==b}\n#{a}\n#{b}\n\n"
    n = a
  end
end

def count
  t = Time.now
  n = 123456789
  count = 0
  while n < 987654321
    count += 1
    n = test2(n)
  end
  puts "Took #{Time.now - t} seconds"
  count
end
# Took 64.685792 seconds
# => 362879


def benchmark
  n = 349572681
  oldTime = Time.now
  50.times do
    n = test(n)
  end
  puts "1000 Tests took #{Time.now-oldTime}"
  n = 123456789
  oldTime = Time.now
  1000.times do
    n = test2(n)
  end
  puts "1000 Test2s took #{Time.now-oldTime}"
end

irb
require "puzzle"
def run_puzzle
  t = Time.now
  p = Puzzle.new
  n = 5000
  n.times do |i|
    puts "#{n-i} more tests"
    p.test(100) { break }
  end
  puts "Took #{Time.now-t} seconds"
end
#  Took 117.113228 seconds


require "puzzle"
p = Puzzle.new
p.test(1)