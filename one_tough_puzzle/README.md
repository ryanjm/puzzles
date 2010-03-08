# One Tough Puzzle

## Introduction

This is a project to come up with an efficient solution to solving One Tough Puzzle (TM).

Right now the solution is set to iterate over all possibilities and find the correct solution that way.  In the future I plan on either rewriting this in other languages and/or making it more efficient.  This is just a fun personal project I created several months ago.

## PuzzlePiece (piece_obj.rb)

This is a PuzzlePiece Object. It has variables to hold what type of top, left, bottom, and right sides it has, thus reflecting a real world object (puzzle piece). It has one method to be able to rotate it clockwise.

## Puzzle Code (puzzle.rb)

This is where the meat of the work is done.  It initializes the puzzle (creates objects for each of the real world puzzle pieces).  It uses status.txt to show you which patter it is currently checking.  Each piece is numbered 1 through 9 and each position in a nine digit number represents a position in the puzzle.  Therefore 123456789 represents the starting position.  The next position will be 123456798.

For each of these positions the algorithm steps through each piece, checking to see if it fits with the ones before it.  That is, position 2 will check to see if its left side fits with position 1's right side.  If it doesn't it will rotate and repeat the test.  If it checks all 4 sides and fails, then it tries to rotate the one before it (in this example, position 1 would rotate) and the checks would be repeated.  Once the first one has been rotated 3 times (checking all four edges) then it will go onto the next set of positions (by iterating that 9 digit number).

## Test (test.rb)

This file was simply used to run the functions over a smaller set so that I could find out what was faster.