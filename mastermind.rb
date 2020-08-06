# A recreation of the classing 1970's hit, Mastermind.

class Mastermind

    attr_reader :secret_code
  
    def initialize()
      @CODE_LENGTH = 4
      @NUM_GUESSES = 10 # Total guesses for a round
      @current_guess_num = 0 # Tracks what turn you are on
      @code_cracked = false # Variable to use to loop over to check for a win condition
      @secret_code = Array.new
      @CODE_CHOICES = ["red", "green", "blue", "white", "orange", "fabulous"]
      @draw_board = Draw_Board.new(@NUM_GUESSES)
    end
  
    def generate_secret_code()
      @CODE_LENGTH.times do
        @@generate = @CODE_CHOICES.sample
        @secret_code.push(@@generate)
      end
    end
  
    def player_generated_code()
  
      p "Look's like you're some sort of mastermind trying to outwit a computer."
      p "Create a code! Make a code of #{@CODE_LENGTH} colors."
      p "Make sure your choices contains no spaces. (example: rgfb)"
      p "Key: r = red, g = green, b = blue, w = white, f = fabulous"
      @@keycode = {
        "r" => "red",
        "g" => "green",
        "b" => "blue",
        "w" => "white",
        "o" => "orange",
        "f" => "fabulous"
      }
      @@player_code_array= Array.new
      @@player_code = valid_guess()
      @@i = 0
      while @@i < @CODE_LENGTH
        @@player_code_array << @@keycode[@@player_code[@@i]]
        @@i +=1
      end
      @secret_code = @@player_code_array
  
    end
  
    def player_guess() #Gets player input
      @@code_guess = Array.new # This is the array thats used to check for a win and pass to the game board
      @@interface = {
        "r" => "red",
        "g" => "green",
        "b" => "blue",
        "w" => "white",
        "o" => "orange",
        "f" => "fabulous"
      }
  
      p "Crack the code! Make a guess of #{@CODE_LENGTH} colors."
      p "Make sure your choices contains no spaces. (example: rgfb)"
      p "Key: r = red, g = green, b = blue, w = white, f = fabulous"
  
      @@current_guess = valid_guess()
      # TODO: Input function that checks if the player made a valid guess
      @@current_guess = @@current_guess.split('')
      # Creating a loop to convert the players choice into an array using the interface hash
      @@i = 0
      while @@i < @CODE_LENGTH
        @@code_guess << @@interface[@@current_guess[@@i]]
        @@i +=1
      end
  
      @@hint = hint_creator()
      
      # Checks to see if the player won
      @code_cracked = true if @@code_guess == @secret_code
  
      @draw_board.push_guess_display(@@code_guess, @@hint, @current_guess_num)# Sends @@current_guess to the game board to update it
  
      system "clear" # Clears the game board
      @draw_board.draw() # Update the game board
  
      @current_guess_num += 1
    end
  
    def computer_guess
      @@code_guess = Array.new
      @CODE_LENGTH.times do
        @@generate = @CODE_CHOICES.sample
        @@code_guess.push(@@generate)
      end
      p @@code_guess
      @code_cracked = true if @@code_guess == @secret_code
      @@hint = hint_creator()
      @draw_board.push_guess_display(@@code_guess, @@hint, @current_guess_num)
      system "clear" # Clears the game board
      @draw_board.draw() # Update the game board
  
      @current_guess_num += 1
    end
  
    def valid_guess()
      # Check to see if the player has input a 4 letter string of approved letters
      @@valid_letters = ["r", "g", "b", "w", "o", "f"]
      @@valid_guess = false
      while @@valid_guess != true do
        @@guess = gets.chomp
        @@guess = @@guess.split(//)
        if @@guess.length() != 4
          p "That isn't a valid! The length isn't quite right"
          @@valid_guess = false
        elsif
          if @@guess.all? { |letter| @@valid_letters.include?(letter)}
            @@valid_guess = true
          end
        else
          p "Gotta choose from either 'r', 'g', 'b', 'w', 'o', or 'f' there, buddy."
          @@valid_guess = false
        end
      end
  
      @@guess = @@guess.join
      return @@guess
    end
        
  
    def hint_creator()
      # Create the right side XO board X- correct O - right color wrong place
      @@hint_array = self.secret_code.clone #checks to see if it should be exluded while enumerating
      @@hint = Array.new
      @@i = 0
      @@code_guess.each do |color| 
  
        if @@code_guess[@@i] == @secret_code[@@i]
          @@hint << " X "
          @@hint_array[@@i] = "correct"
          @@i += 1
        else
          @@i +=1
        end
      end
  
      @@code_guess.each do |color|
        if @@hint_array.include?(color)
          @@hint << " O "
          @@hint_array.delete_at(@@hint_array.index(color))
        end
      end
  
      p @@hint_array
      # Ensuring that the returned array has 4 elements for aethstitic purpose
      @@expand = @@hint.length
      if @@expand < 4
        @@expand = 4 - @@expand
        @@expand.times do
          @@hint << "   "
        end
      end
  
      return @@hint.sort
    end
  
    def computer_is_mastermind() #Putting it all together for the player to be guessing
      # Input instructions here
      @draw_board.draw()
      generate_secret_code()
      while @code_cracked == false and @current_guess_num < @NUM_GUESSES do
        player_guess()
      end
  
      # Displaying the win/lose condition
      if @code_cracked == true
        p "Congratulations! You guessed the secret code!"
        p "The secret code was:", @secret_code
      else
        p "Curses! You've been bamboozled by the computer."
        p "The secret code was:", @secret_code
      end
  
    end
  
    def player_is_mastermind()
      player_generated_code()
      @draw_board.draw()
  
  
      while @code_cracked == false and @current_guess_num < @NUM_GUESSES do
        computer_guess()
      end
  
      # Displaying the win/lose condition
      if @code_cracked == true
        p "Curses! The computer guessed the secret code!"
        p "The secret code was:", @secret_code
      else
        p "You've bamboozled the computer! You sly dog, you."
        p "The secret code was:", @secret_code
      end
    end
  
  end
  
  class Draw_Board
  
    def initialize(num_guesses)
      @@NUM_GUESSES = num_guesses
      @guess_display = Array.new(@@NUM_GUESSES, Array.new)
      # Creating the arrays to fill the Game Board
      @guess_display.each { |x| @guess_display[@guess_display.index(x)] = Array.new(4, "          ")}
      @guess_hint = Array.new(@@NUM_GUESSES, Array.new)
    end
  
    def push_guess_display(current_guess, guess_hint, guess_num)
      @@code_display = Array.new
      @@current_guess = current_guess
      @@guess_hint = guess_hint
      @@guess_num = guess_num # Using to refrence what element in array to update
      @@visual_display = {
        "red" => "  red   ",
        "green" => " green  ",
        "blue" => "  blue  ",
        "white" => "  white ",
        "orange" => " orange ",
        "fabulous" => "fabulous"
      }
  
      @@i = 0
      while @@i < 4 #Hard coded to code length for redability
        @@code_display << @@visual_display[@@current_guess[@@i]]
        @@i +=1
      end
  
      # Update the game board with the new array 
      @guess_display[@@guess_num] = @@code_display
      @guess_hint[@@guess_num] = @@guess_hint
      p @guess_hint
  
    end
  
    def draw()
      p "Life is short"
      p " -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  "
      @@NUM_GUESSES.times do |number|
        p "| #{@guess_display[number][0]} | #{@guess_display[number][1]} | #{@guess_display[number][2]} | #{@guess_display[number][3]} |   | #{@guess_hint[number][0]} #{@guess_hint[number][1]} #{@guess_hint[number][2]} #{@guess_hint[number][3]} |"
      p " -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  "
      end
    end
  
  end
  
  # Let's get this party started
  p "Get ready for a rousing game of the 1970's classic game, 'Masterming'"
  p "Fist things first, who will be the mastermind? You? Or the computer."
  p "Input either 'player' or 'computer'."
  new_game = Mastermind.new()
  $choice = gets.chomp
  if $choice == "player"
    new_game.player_is_mastermind()
  elsif $choice == "computer"
    new_game.computer_is_mastermind()
  else
    p "You cheeky son-of-a-biscuit-muncher, I said either 'player' or 'computer'"
  end