#!/usr/local/bin/ruby

require "piece_obj"


class Puzzle
  def initialize
    h_o = "Heart out"
    d_o = "Diamond out"
    s_o = "Spade out"
    c_o = "Club out"
    h_i = "Heart in"
    d_i = "Diamond in"
    s_i = "Spade in"
    c_i = "Club in"
    p1 = PuzzlePiece.new(h_o,d_o,d_i,h_i);
    p2 = PuzzlePiece.new(c_o,h_o,s_i,h_i);
    p3 = PuzzlePiece.new(s_o,d_o,s_i,h_i);
    p4 = PuzzlePiece.new(h_o,d_o,c_i,c_i);
    p5 = PuzzlePiece.new(h_o,s_o,s_i,c_i);
    p6 = PuzzlePiece.new(s_o,d_o,h_i,d_i);
    p7 = PuzzlePiece.new(c_o,h_o,d_i,c_i);
    p8 = PuzzlePiece.new(s_o,s_o,h_i,c_i);
    p9 = PuzzlePiece.new(d_o,c_o,c_i,d_i);
    @original_array = [p1,p2,p3,p4,p5,p6,p7,p8,p9]
    @puzzle_array = [p1,p2,p3,p4,p5,p6,p7,p8,p9]
    create_files
  end
  
  def create_files
    if !File.exists?("status.txt")
      puts "Creating status.txt and other files"
      File.new("status.txt","w+")
      Dir.mkdir("test")
      Dir.mkdir("test/7")
      Dir.mkdir("test/8")
      Dir.mkdir("test/9")
      File.new("./test/time.csv","w+")
      File.open("status.txt","w") do |file|
        file.syswrite("Start: 123456789\nChecked: 0")
      end
    end
  end
  
  def read_file
    File.open("status.txt","r") do |file|
      line1 = file.gets
      @position = line1[7..line1.length].to_i
      line2 = file.gets
      @checked = line2[9..line2.length].to_i
      if file.gets == "Finished"
        return true 
      end
    end
    false
  end
  
  def write_file
    File.open("status.txt","w") do |file|
      file.syswrite("Start: #{@position.to_s}\nChecked: #{@checked.to_s}")
      file.syswrite("\nFinished") if @check_till == 9
    end
  end
  
  def test(n)
    yield if read_file
    before = Time.now
    before_count = @checked
    @check_till = 1
    (1..n).each do
      break if @check_till == 9
      @rotation = [0,-1,0,0,0,0,0,0,0]
      next_position
      move_pieces
      @check_till = 1
      while next_rotation
        break if test_rotation
      end
    end
    write_file
    puts "Time elapse: #{Time.now-before}"
    count = @checked.to_i - before_count.to_i
    puts "Checked #{count.to_s} more at #{(sprintf("%.2f", count/(Time.now-before))).to_s} per second."
    puts "Now at #{@checked.to_s}."
    puts "Position: #{@position}"
    File.open("test/time.csv","a") do |file|
      file.syswrite("\n#{Time.now-before}, #{count}")
    end
  end

  def next_position
    a = @position.to_s.split(//)
    a.each_index {|i| a[i] = a[i].to_i }
    r = a.length-1
    while r > 0
      if a[r] > a[r-1]
        smallest = nil
        a[r,a.length-1].sort.each {|s| smallest ||= s.to_i if s.to_i > a[r-1]}
        small_index = a.index(smallest)
        a[r-1], a[small_index] = a[small_index], a[r-1]
        a = a[0..r-1] + a[r..a.length-1].sort
        break
      else
        r -= 1
      end
    end
    puts "tried everything" if @position > 987654322
    @position = a.to_s.to_i
  end
  
  def move_pieces
    (0..8).each do |i|
      pos = @position.to_s.reverse[i,1].to_i-1
      @puzzle_array[i] = @original_array[pos];
    end
  end
  
  # Rotate until it is clear this position fails
  def test_rotation
    @checked += 1
    if !test_puzzle
      write_solution if @check_till > 6
    else
      write_solution
      return true
    end
    false
  end
  
  # counting with base 4
  def next_rotation
    while @check_till < 9
      @rotation[@check_till] += 1
      @puzzle_array[@check_till].rotate_cw
      if @rotation[@check_till] == 4
        return false if @check_till == 0
        @rotation[@check_till] = 0
        @check_till = 0
      else
        # puts "Rotation: #{@rotation}"
        return true
      end
    end
    return false if @check_till == 9
  end
  
  def test_puzzle
    if @check_till == 0
      @check_till = 1
      return false
    end
    if @check_till > 0
      return false if !fits?(@puzzle_array[0].right,@puzzle_array[1].left)
      @check_till = 2
    end
    if @check_till > 1
      return false if !fits?(@puzzle_array[1].right,@puzzle_array[2].left)
      @check_till = 3
    end
    if @check_till > 2
      return false if !fits?(@puzzle_array[0].bottom,@puzzle_array[3].top)
      @check_till = 4
    end
    if @check_till > 3
      return false if !fits?(@puzzle_array[3].right,@puzzle_array[4].left)
      return false if !fits?(@puzzle_array[1].bottom,@puzzle_array[4].top)
      @check_till = 5
    end
    if @check_till > 4
      return false if !fits?(@puzzle_array[4].right,@puzzle_array[5].left)
      return false if !fits?(@puzzle_array[2].bottom,@puzzle_array[5].top)
      @check_till = 6
    end
    if @check_till > 5
      return false if !fits?(@puzzle_array[3].bottom,@puzzle_array[6].top)
      @check_till = 7
    end
    if @check_till > 6
      return false if !fits?(@puzzle_array[6].right,@puzzle_array[7].left)
      return false if !fits?(@puzzle_array[4].bottom,@puzzle_array[7].top)
      @check_till = 8
    end
    if @check_till > 7
      return false if !fits?(@puzzle_array[7].right,@puzzle_array[8].left)
      return false if !fits?(@puzzle_array[5].bottom,@puzzle_array[8].top)
      @check_till = 9
    end
    return true if @check_till == 9
    false
  end
  
  def write_solution
    puts "Writing solution (#{@position}).  Checked till = #{@check_till}"
    File.new("test/#{@check_till}/#{@position}-#{@check_till}.txt","w+")
    File.open("test/#{@check_till}/#{@position}-#{@check_till}.txt","w") do |file|
      file.syswrite("Positions #{@position}:\n")
      file.syswrite("Check-Till #{@check_till}:\n")
      (0..8).each do |t|
        file.syswrite("Position #{t}:\n")
        file.syswrite("Top:     #{@puzzle_array[t].top}\n")
        file.syswrite("Right:   #{@puzzle_array[t].right}\n")
        file.syswrite("Bottom:  #{@puzzle_array[t].bottom}\n")
        file.syswrite("Left:    #{@puzzle_array[t].left}\n")
      end
    end
  end
  
  def fits?(one,two)
    return true if (one == "Heart out" and two == "Heart in") || 
        (one == "Heart in" and two == "Heart out")
    return true if (one == "Diamond out" and two == "Diamond in") || 
        (one == "Diamond in" and two == "Diamond out")
    return true if (one == "Spade out" and two == "Spade in") || 
        (one == "Spade in" and two == "Spade out")
    return true if (one == "Club out" and two == "Club in") || 
        (one == "Club in" and two == "Club out")
    false
  end
end