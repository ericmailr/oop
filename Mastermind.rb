class Codebreaker
  attr_accessor = :name
end
class Codemaker
  attr_accessor = :name
end
class Game
 
  def setup
	puts "\t-M A S T E R M I N D-\n\nEnter b to play as Codebreaker\nEnter m  to play as Codemaker"
	entered_mode = gets.chomp.downcase
	until ["b","m"].include?(entered_mode)
  	print "Invalid option. Choose b or m: "
  	entered_mode = gets.chomp.downcase
	end
	entered_mode == "b" ? @human_guesser = true : @human_guesser = false
  end
 
  def play()
	@human_guesser ? run_breaker : run_maker
  end
 
  def run_breaker
	@code = generate_code()
	puts human_guess() ? "You cracked the code!" : "You lose :("
  end
 
  def run_maker
	@ai = AI.new
	get_code()
	puts ai_guess ? "\nAI is unstoppable and it's coming for you. Run." : "What a terrible AI"
  end
 
  private
 
  def generate_code()
	code = ""
	@rng = Random.new()
	4.times {code += (@rng.rand(6) + 1).to_s}
	code
  end
 
  def get_code()
	print @human_guesser ? "\nEnter your guess: " : "\nEnter a code for the AI to break: "
	code_entered = gets.chomp
	until valid_guess?(code_entered)
  	print "\nInvalid code. Codes must be 4 digits long--try again!"
  	code_entered = gets.chomp
	end
	@human_guesser ? @guess = code_entered : @code = code_entered
  end
 
  def ai_guess()
	guesses_left = {0=> [1,2,3,4,5,6],
                	1=> [1,2,3,4,5,6],
                	2=> [1,2,3,4,5,6],
                	3=> [1,2,3,4,5,6]}
  
	last_exacts = 0
	right_nums = []
	num_guesses = 0
	times_altered = [0,0,0,0]
	@guess = generate_code
	grade_guess
	
	puts "\nAI attempt #{num_guesses += 1}: #{@guess}"
	
	if @exacts.count == 4
  	return true
	else @exacts.count
  	last_exacts = @exacts.count
  	last_rights = @right_numbers.count
  	
  	4.times do |ind|
    	return true if @exacts.count == 4 #????????????????? NEEED ??????????????????
    	(ind..3).each do |i| # ex 2533 [2,1,3,4,5,6] [5,2,3,4,1,6] [3,2,1,4,5,6] [3,2,1,4,5,6]
        	temp_index = guesses_left[i].index(@guess[i].to_i)
        	guesses_left[i][0], guesses_left[i][temp_index] = guesses_left[i][temp_index], guesses_left[i][0]
        	
      	end
    	5.times do |j|
      	guesses_left[ind][0], guesses_left[ind][j+1] = guesses_left[ind][j+1], guesses_left[ind][0]
      	@guess[ind] = guesses_left[ind][0].to_s
      	puts "\nAI attempt #{num_guesses += 1}: #{@guess}"
      	grade_guess
      	return true if @exacts.count == 4
      	if @exacts.count < last_exacts #last digit was right
      	
        	if last_rights < @right_numbers.count
          	((ind+1)..3).each do |remaining_place|
            	ind_to_delay = times_altered[remaining_place] + 1
            	ind_to_expedite = guesses_left[remaining_place].index(@guess[ind].to_i)
            	guesses_left[remaining_place][ind_to_delay], guesses_left[remaining_place][ind_to_expedite] = guesses_left[remaining_place][ind_to_expedite], guesses_left[remaining_place][ind_to_delay]
            	times_altered[remaining_place] += 1
          	end
        	end
        	@guess[ind] = guesses_left[ind][1].to_s
        	break
      	elsif @exacts.count == last_exacts
        	#current digit and last digit are wrong, increment to next
        	if last_rights < @right_numbers.count
          	((ind+1)..3).each do |remaining_place|
            	ind_to_delay = times_altered[remaining_place] + 1
            	ind_to_expedite = guesses_left[remaining_place].index(@guess[ind].to_i)
            	guesses_left[remaining_place][ind_to_delay], guesses_left[remaining_place][ind_to_expedite] = guesses_left[remaining_place][ind_to_expedite], guesses_left[remaining_place][ind_to_delay]
            	times_altered[remaining_place] += 1
          	end
          	last_rights = @right_numbers.count
        	end
      	elsif @exacts.count > last_exacts #current digit is right
        	#remove instance of right_number from list
        	last_exacts = @exacts.count
        	break
      	end
    	end
  	end
    	
	end
	
	return false
  end
 
  def find_index_thats_right(unknown_indices, guesses_left)
	
  end
 
  def human_guess()
	12.times.with_index do |i|
  	puts "\nAttempt #{i+1}"
  	get_code()
  	grade_guess()
  	
  	exact_count = @exacts.count
  	print "\t\t\t\t"
  	@guess.each_char {|i| print i + " " }
  	print "\t\t\t\t\t"
  	exact_count.times { print "+ " }
  	@right_numbers.count.times { print "- " }
  	(4 - exact_count - @right_numbers.count).times { print "o " }
  	puts
  	return true if exact_count == 4
	end
	puts "The code was #{@code}"
	return false
  end
 
  def grade_guess()
	accounted = @code.clone
  	@exacts = []
  	@right_numbers = []
  	@code.each_char.with_index do |ch, i|
    	if ch == @guess[i]
      	@exacts.push(i)
      	accounted[i] = "*"
    	end
  	end
  	@guess.each_char.with_index do |ch, i|
    	next if @exacts.include?(i)
    	if accounted.include?(ch)
      	@right_numbers.push(ch)
      	accounted.sub!(ch,"*")
    	end
  	end
  end
 
  def valid_guess?(guess_entered)
	return false if guess_entered.size != 4 || !guess_entered.scan(/\D/).empty?
	guess_entered.each_char do |i|
  	return false if !(1..6).include?(i.to_i)
	end
	return true
  end
 
  def count_chars(string,char)
	string.chars.count(char)
  end
 
end
class AI
  attr_accessor :exacts, :right_numbers
 
  def initialize
	@exacts = {}
	@right_numbers = {}
  end
end
game = Game.new
mode = game.setup
game.play()
