#!/usr/local/bin/ruby

class PuzzlePiece
  attr_accessor :top    
  attr_accessor :right  
  attr_accessor :bottom 
  attr_accessor :left

  def initialize(top,right,bottom,left)
   @top = top
   @right = right
   @bottom = bottom
   @left = left
  end
  def rotate_cw
    old_top = @top
    @top = @left
    @left = @bottom
    @bottom = @right
    @right = old_top
  end
end