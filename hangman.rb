def game_start
  player_name = get_player_name
  greet_player(player_name)
  word = generate_word
  empty_word = get_empty_word(word)
  display_empty_word(empty_word)
  man_is_not_hung = true
  word_is_incomplete = true
  while man_is_not_hung && word_is_incomplete
    letter = player_chooses_letters(player_name)
    check_if_in_word(letter, word, empty_word)
    display_empty_word(empty_word)
    man_is_not_hung = check_if_man_is_hung
    word_is_incomplete = check_if_word_is_complete
  end
  player_wins_or_loses(player_name)
end

def get_player_name
  puts("Hello, player. What is your name?")
  name = gets.chomp.to_s
end

def greet_player(player_name)
  puts("Hello, " + player_name + ". Let's play Hangman.")
end

def generate_word
  "word"
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
end

def check_if_in_word(letter, word, empty_word)
  is_in_word = find_letter_in_word(word, letter)
  if is_in_word
    display_successful_guess_message(letter)
    add_letter_to_word(letter, word, empty_word)
  else
    display_bad_guess_message(letter)
    add_line_to_man
  end
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

def add_line_to_man
end

def check_if_man_is_hung
end

def check_if_word_is_complete
end

def player_wins_or_loses(player_name)
  wins = check_if_wins
  if wins
    display_winner_message(player_name)
  else
    display_loser_message(player_name)
  end
end

def check_if_wins
end

def display_winner_message(player_name)
end

def display_loser_message(player_name)
end

game_start
