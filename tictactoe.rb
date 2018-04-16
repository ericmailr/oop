class Game
  attr_accessor :player1, :player2
	
  def initialize
	@board = Board.new()
	@game_over = false
	@@ways_to_win = [[1,2,3],[4,5,6],[7,8,9],[1,4,7],
                 	[2,5,8],[3,6,9],[1,5,9],[3,5,7]]
	@@turn = 0
  end
 
  def setup()
	puts "Let's play Tic-Tac-Toe!\n\n"
	print "Player 1, enter your name: "
	@player1 = Player.new(gets.chomp)
	
	print "\nWelcome, #{@player1.name}! Choose X or O: "
	enteredSymbol = gets.chomp.upcase
	until isValidSymbol?(enteredSymbol)
  	print "\nYou entered an invalid symbol. X or O?: "
  	enteredSymbol = gets.chomp.upcase
	end  	
	@player1.symbol = enteredSymbol
	print "\nPlayer 2, enter your name: "
	@player2 = Player.new(gets.chomp)
	@player1.symbol=="X" ? @player2.symbol="O" : @player2.symbol="X"
	puts "\nWelcome, #{@player2.name}! Since #{@player1.name} chose #{@player1.symbol}, you get to be #{@player2.symbol}!"
  end
 
  def play()
	@@turn+=1
	@moves_count = 0
	(@@turn % 2 == 1) ? player_order = [player1,player2] : player_order = [player2,player1]
	until @game_over
  	player_order.each do |player|
    	@board.show
    	print "#{player.name}, choose where to place your #{player.symbol}! "
    	enteredPosition = gets.chomp.to_i
    	until (1..9).include?(enteredPosition) && !["X","O"].include?(@board.board[enteredPosition])
      	print "That position isn't available. Choose another: "
      	enteredPosition = gets.chomp.to_i
    	end
    	@board.board[enteredPosition] = player.symbol
    	if gameOver?(enteredPosition, player.symbol)
      	end_game(player)
      	break
    	elsif (@moves_count += 1) == 9
      	end_game(nil)
      	break
    	end
  	end
	end
	@game_over = false
  end
 
  private
 
  def isValidSymbol?(symbol)
	return symbol=="X" || symbol=="O"
  end
 
  def gameOver?(position,symbol)
	@@ways_to_win.each do |way|
  	if way.include?(position)
    	count=0
    	way.each do |win_position|
      	if @board.board[win_position]==symbol
        	count+=1
        	return true if (count == 3)
      	else
        	count=0
      	end
    	end
  	end
	end
	return false
  end
 
  def end_game(player)
	if player
  	puts "\n#{player.name} WINS!"
	else
  	puts "\nTie game!"
	end
	@game_over = true
	@board.show
	show_score(player)
	@board = Board.new()
  end
 
  def show_score(player)
	if player
  	player.wins += 1
  	if player.name == @player1.name
    	@player2.losses += 1
  	else
    	@player1.losses += 1
  	end
	else
  	@player1.ties += 1
  	@player2.ties += 1
	end
	puts "Score:"
	[@player1,@player2].each do |player|
  	puts "\n#{player.name}: Wins = #{player.wins}, Losses = #{player.losses}"
	end
	puts "\nTie games: #{@player1.ties} \n\n"
  end
 
end
class Board
  attr_accessor :board
  def initialize
	@board = [nil,"1","2","3","4","5","6","7","8","9"]
  end
 
  def show
	clean_entries = [nil]
	@board.each_with_index {|entry,i| ["X","O"].include?(entry) ? clean_entries[i] = entry : clean_entries[i] = " "}
	
	puts "\n #{@board[1]} | #{@board[2]} | #{@board[3]}\t" +
	" #{clean_entries[1]} | #{clean_entries[2]} | #{clean_entries[3]}"
	puts "---|---|---\t---|---|---"
	puts " #{@board[4]} | #{@board[5]} | #{@board[6]}\t" +
	" #{clean_entries[4]} | #{clean_entries[5]} | #{clean_entries[6]}"
	puts "---|---|---\t---|---|---"
	puts " #{@board[7]} | #{@board[8]} | #{@board[9]}\t" +
	" #{clean_entries[7]} | #{clean_entries[8]} | #{clean_entries[9]}"
	puts
  end
end
class Player
  attr_accessor :name, :symbol, :wins, :losses, :ties
  def initialize(name)
	@name = name
	@wins = 0
	@losses = 0
	@ties = 0
  end
end
game = Game.new()
game.setup()
game.play()
option = nil
until option == "q"
  print "Enter q to quit, r to reset, or enter anything else to play again: "
  option = gets.chomp.downcase
  if option == "q"
	break
  elsif option == "r"
	game = Game.new()
	game.setup()
	game.play()
  else
	game.play()
  end
end
"Thanks for playing!"
