# Towers.rb, a command-line version of the tower of hanoi.

class TowerOfHanoi

  # We initialize three columns, one populated with our initial tower.
  # The internal representation of a column is from the lowest to highest piece.
  # This way, we can easily use push and pop to move a piece.
  # We have an instance variable for the height, columns, what the win condition looks like
  # and if the user quit or won the game.
  def initialize(height)
    @height = height
    @col1 = (1..height).to_a.reverse
    @col2 = []
    @col3 = []

    # I've put a hash to easily convert the player's inputs into the corresponding columns.
    @col_map = {1 => @col1, 2 => @col2, 3 => @col3}

    @win_condition = (1..height).to_a.reverse
    @game_quit = false
    @game_won = false
  end

  # Takes the highest piece from column c1 and places it on top of column c2.
  # We obviously can't do that if column c1 is empty, however.
  def move(c1, c2)
    if @col_map[c1].length == 0
      puts "There's nothing to take from column #{c1}!"
    elsif
      @col_map[c2] << @col_map[c1].pop
    end
  end

  # Takes the user's input, and if it is proper (2 inputs)
  def parse_move(str)

    # If the user opts to quit, we quit.
    if str == "q"
      puts "Better luck next time!"
      @game_quit = true
      return
    end

    # We see if the input is in braces.
    if str[0] == "[" && str[-1] == "]"

      # We remove the braces and put what's in the braces into an array.
      potential_move = str[1..-2].split(',').map{|val| val.to_i}

      # We also check if there's only two inputs in the braces.
      if potential_move.length == 2

        # We need to make sure that it's both in the proper format but also that the values make sense.
        if potential_move[0] < 4 && potential_move[1] < 4 && potential_move[0] > 0 && potential_move[1] > 0

          # Kinda pointless but I'll puts a message if they input something like [1, 1].
          if potential_move[0] != potential_move[1]
            move(potential_move[0], potential_move[1])
          else
            puts "Why would you even pick up a piece just to set it back down?! Try again! (But not what you just did!)"
          end
        else
          puts "You're trying to move columns that don't even exist! Try again!"
        end
      else
        puts "Wrong number of inputs! Try again!"
      end
    else
      puts "I can't tell what you're trying to say! Try again!"
    end
  end

  def render
    # Width of column is height + 2.
    tabl = "Current Board:\n"
    @height.downto(0) do |val|
      tabl += "\# "

      # Since the way I worked out the logic for the game,
      # we just have to check if there's a value in the row or not.
      # If there is, we draw it and then draw the proper amount of spaces afterwards.
      if @col1[val]
        tabl += ("o" * @col1[val])
        tabl += (" " * (@height + 2 - @col1[val]))

      # But if there's not, we just draw the full amount of spaces.
      else
        tabl += (" " * (@height + 2))
      end

      if @col2[val]
        tabl += ("o" * @col2[val])
        tabl += (" " * (@height + 2 - @col2[val]))
      else
        tabl += (" " * (@height + 2))
      end

      if @col3[val]
        tabl += ("o" * @col3[val])
        tabl += (" " * (@height + 2 - @col3[val]))
      else
        tabl += (" " * (@height + 2))
      end

      tabl += ("\n")
    end

    # Space between each column number is height + 1
    tabl += "\# 1"
    tabl += (" " * (@height + 1))
    tabl += "2"
    tabl += (" " * (@height + 1))
    tabl += "3"
    tabl += (" " * (@height + 1))

    print tabl
  end

  def check_win
    if @col3 == @win_condition
      puts "Congratulations! You win!"

      # We draw the board one last time since our game loop ends once @game_won or @game_quit is true.
      render
      @game_won = true
    end
  end

  def welcome_message
    puts "\# Welcome to the Tower of Hanoi!"
    puts "\# Instructions:"
    puts "\# Enter where you'd like to move from and to"
    puts "\# in the format [1,3] Enter 'q' to quit."
  end


  def play
    # Initial message printed at start of game.
    welcome_message

    # Main game loop. Draws board, accepts input, acts on that input, checks if user won.
    until (@game_won or @game_quit) do
      render
      puts "Enter move>"
      current_move = gets.chomp

      parse_move(current_move)
      check_win
    end
  end
end

t = TowerOfHanoi.new(3)

t.play