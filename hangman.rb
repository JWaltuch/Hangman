require_relative "renderers.rb"
# require_relative "guirenderer.rb"

def game_start
  word = generate_word
  player_name = get_player_name
  greet_player(player_name)
  renderer = get_display_method_from_player
  empty_word = get_empty_word(word)
  display_empty_word(empty_word)
  word_is_incomplete = true
  wrong_answers = 0
  while word_is_incomplete && wrong_answers < 6
    letter = player_chooses_letters(player_name)
    is_in_word = check_if_in_word(letter, word)
    if is_in_word
      resolve_successful_guess(letter, word, empty_word)
    else
      wrong_answers += 1
      resolve_bad_guess(letter, wrong_answers, renderer)
    end
    display_empty_word(empty_word)
    word_is_incomplete = check_if_word_is_complete(word, empty_word)
  end
  player_wins_or_loses(player_name, word, empty_word)
end

def generate_word
  dictionary_name = choose_dictionary
  dictionary = File.read(dictionary_name)
  dictionary = dictionary.split("\n")
  randomizer = rand(0..dictionary.length).to_i
  dictionary[randomizer].to_s
end

def choose_dictionary
  if /\w+/ =~ ARGV[0]
    dictionary_name = ARGV[0].chomp.to_s
  else
    dictionary_name = "dictionary.rtf"
  end
end

def get_player_name
  ARGV.clear
  puts("Hello, player. What is your name?")
  name = gets.chomp.to_s
end

def greet_player(player_name)
  puts("Hello, " + player_name + ". Let's play Hangman.")
end

def get_display_method_from_player
  puts("How would you like your Hangman displayed?\nOptions:\n")
  puts("1. Basic lines \n2. Basic lines with noose")
  puts("3. Emojis \n4. GUI rendering\n")
  puts("Choose 1, 2, 3, or 4")
  method_number = gets.chomp.to_i
  unless /[1-4]/ =~ method_number.to_s
    puts("Please make a valid choice of 1-4.")
    method_number = gets.chomp.to_i
  end
  if method_number == 1
    return renderer = LittleManRenderer.new
  elsif method_number == 2
    return renderer = SimpleRenderer.new
  elsif method_number == 3
    return renderer = EmojiRenderer.new
  elsif method_number == 4
    return renderer = LittleManRenderer.new
  end
end

def display_empty_word(empty_word)
  puts("This is your word: " + empty_word.join(" "))
end

def get_empty_word(word)
  word_length = get_word_length(word)
  empty_word = []
  for i in 1..word_length
    empty_word.push("_")
  end
  empty_word
end

def get_word_length(word)
  word.length
end

def player_chooses_letters(player_name)
  ask_player_for_letter
  letter = get_letter
end

def ask_player_for_letter
  puts("What letter would you like to guess?")
end

def get_letter
  letter = gets.chomp.to_s
  unless /\p{Alpha}{1}/ =~ letter
    puts("This is not a letter of the alphabet. Please guess a valid letter.")
    letter = gets.chomp.to_s
  end
  letter
end

def check_if_in_word(letter, word)
  is_in_word = find_letter_in_word(word, letter)
end

def resolve_successful_guess(letter, word, empty_word)
  display_successful_guess_message(letter)
  add_letter_to_word(letter, word, empty_word)
end

def resolve_bad_guess(letter, wrong_answers, renderer)
  display_bad_guess_message(letter)
  puts(renderer.render(wrong_answers))
end

def find_letter_in_word(word, letter)
  letter_in_word = false
  for character in word.split(//)
    if character == letter
      letter_in_word = true
      break
    end
  end
  letter_in_word
end

def display_successful_guess_message(letter)
  puts("Good guess! '" + letter + "' is in the word!")
end

def display_bad_guess_message(letter)
  puts("I'm sorry. '" + letter + "' is not in the word.")
end

def add_letter_to_word(letter, word, empty_word)
  i = 0
  for character in word.split(//)
    if character == letter
      empty_word[i] = letter
    end
    i += 1
  end
end

class LittleManRenderer
  def render(wrong_answers)
    if wrong_answers == 1
      puts("O")
    elsif wrong_answers == 2
      puts("O\n|")
    elsif wrong_answers == 3
      puts("  O\n\\ |")
    elsif wrong_answers == 4
      puts("  O\n\\ |  /")
    elsif wrong_answers == 5
      puts("  O\n\\ |  /\n  |\n/")
    elsif wrong_answers == 6
      puts("  O\n\\ |  /\n  |\n/   \\ ")
    end
  end
end

# def add_line_to_man(wrong_answers)
#   if wrong_answers == 1
#     puts("O")
#   elsif wrong_answers == 2
#     puts("O\n|")
#   elsif wrong_answers == 3
#     puts("  O\n\\ |")
#   elsif wrong_answers == 4
#     puts("  O\n\\ |  /")
#   elsif wrong_answers == 5
#     puts("  O\n\\ |  /\n  |\n")
#   elsif wrong_answers == 6
#     puts("  O\n\\ |  /\n  |\n/")
#   elsif wrong_answers == 7
#     puts("  O\n\\ |  /\n  |\n/   \\ ")
#   end
# end

def check_if_word_is_complete(word, empty_word)
  word != empty_word.join("")
end

def player_wins_or_loses(player_name, word, empty_word)
  wins = check_if_wins(word, empty_word)
  if wins
    display_winner_message(player_name)
  else
    display_loser_message(player_name, word)
  end
end

def check_if_wins(word, empty_word)
  word == empty_word.join("")
end

def display_winner_message(player_name)
  puts("You've guessed the word, " + player_name + ". You win!")
end

def display_loser_message(player_name, word)
  puts("You've failed to guess the word, " + player_name + ". You lose :(\n")
  puts("The word was: " + word)
end

game_start
