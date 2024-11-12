# RubyHangman, a Hangman game created by me! Can be found open-source at "github.com/StikyPiston/RubyHangman"
# Licensed under MIT

class Hangman
  MAX_ATTEMPTS = 6

  def initialize
    setup_game
  end

  def play
    puts "Welcome to Hangman!"
    puts "Topic: #{@topic}"
    until game_over?
      display_game_status
      guess = player_input
      process_command_or_guess(guess)
      clear_screen
    end
    conclude_game
  end

  private

  def setup_game
    print "Host, enter a word for the player to guess: "
    @secret_word = gets.chomp.downcase
    print "Enter a topic for this word: "
    @topic = gets.chomp
    @hints = []
    3.times do |i|
      print "Enter hint #{i + 1} (or press Enter to skip): "
      hint = gets.chomp
      @hints << hint unless hint.empty?
    end
    @guesses = []
    @attempts = 0
    @used_hints = 0
    clear_screen
  end

  def display_game_status
    puts hangman_art
    puts "Word: #{display_word}"
    puts "Attempts left: #{MAX_ATTEMPTS - @attempts}"
    puts "Used letters: #{@guesses.join(", ")}"
    puts "Hints used: #{@used_hints}/#{@hints.size}"
    puts "-" * 30
    puts "Commands: Type a letter to guess, '/hint' for a hint, '/quit' to give up, or guess the full word."
  end

  def display_word
    @secret_word.chars.map { |char| @guesses.include?(char) || char == " " ? char : "_" }.join(" ")
  end

  def player_input
    print "Enter your guess or command: "
    gets.chomp.downcase
  end

  def process_command_or_guess(input)
    case input
    when "/hint"
      reveal_hint
    when "/quit"
      @attempts = MAX_ATTEMPTS # Trigger game over
    else
      input.length > 1 ? handle_full_word_guess(input) : handle_letter_guess(input)
    end
  end

  def reveal_hint
    if @used_hints < @hints.size
      puts "Hint #{@used_hints + 1}: #{@hints[@used_hints]}"
      @used_hints += 1
    else
      puts "No more hints available!"
    end
    sleep(2) # Pause to give player time to read the hint
  end

  def handle_letter_guess(guess)
    if @guesses.include?(guess)
      puts "You already guessed that letter!"
    elsif @secret_word.include?(guess)
      puts "Good guess!"
    else
      puts "Wrong guess!"
      @attempts += 1
    end
    @guesses << guess
    sleep(1) # Short pause to see feedback
  end

  def handle_full_word_guess(word)
    if word == @secret_word
      @guesses = @secret_word.chars.uniq # Mark all letters as guessed
    else
      puts "Incorrect! That’s not the word."
      @attempts += 1
    end
    sleep(1)
  end

  def game_over?
    won? || lost?
  end

  def won?
    @secret_word.chars.all? { |char| char == " " || @guesses.include?(char) }
  end

  def lost?
    @attempts >= MAX_ATTEMPTS
  end

  def conclude_game
    if won?
      puts "Congratulations! You've guessed the word: #{@secret_word.capitalize}"
    else
      puts hangman_art
      puts "Game over! The word was: #{@secret_word.capitalize}"
    end
  end

  def hangman_art
    stages = [
      """
         +---+
         |   |
             |
             |
             |
             |
        =========
      """,
      """
         +---+
         |   |
         O   |
             |
             |
             |
        =========
      """,
      """
         +---+
         |   |
         O   |
         |   |
             |
             |
        =========
      """,
      """
         +---+
         |   |
         O   |
        /|   |
             |
             |
        =========
      """,
      """
         +---+
         |   |
         O   |
        /|\\  |
             |
             |
        =========
      """,
      """
         +---+
         |   |
         O   |
        /|\\  |
        /    |
             |
        =========
      """,
      """
         +---+
         |   |
         O   |
        /|\\  |
        / \\  |
             |
        =========
      """
    ]
    stages[@attempts]
  end

  def clear_screen
    system("clear") || system("cls")
  end
end

# Start the game
game = Hangman.new
game.play
