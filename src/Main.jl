using TicTacToe
# TODO: Util is also included in TicTacToe. Is this okay?
include("Util.jl")

# Who may play?
@enum PlayerType begin
	Human
	Computer
end

# Who's playing?
struct Players
	X::PlayerType
	O::PlayerType
end

function greet()
	# TODO: print greeting
end

# Keep asking user to choose a player combination until he/she enters a
# valid player combination.
function choosePlayers()::Players
	println("Who's playing?")
	while true
		sel = parseInteger(
			1,
			4,
			unSplit([
				"   X            O",
				"1. Human    vs. Human",
				"2. Human    vs. Computer",
				"3. Computer vs. Human",
				"4. Computer vs. Computer"
			], '\n')
		)
		if sel == 1
			return Players(Human, Human)
		elseif sel == 2
			return Players(Human, Computer)
		elseif sel == 3
			return Players(Computer, Human)
		elseif sel == 4
			return Players(Computer, Computer)
		else
			# Shouldn't happen if parseInteger works as it should
			throw(DomainError(sel, "Expected selection to be an integer from 1 to 4."))
		end
	end
end

# Keep prompting the user for an integer in the given range until he/she
# enters a valid integer.
# Include optional instructions for the user to follow.
function parseInteger(min, max, instructions="")
	prompt = string(min) * "-" * string(max) * "> "
	while true
		if length(instructions) > 0
			println(instructions)
		end
		print(prompt)
		line = readline()
		mInt = tryparse(Int, line)
		if isnothing(mInt)
			println("Expected integer.")
		else
			int = mInt
			if int < min || int > max
				println("Expected integer from " * string(min) * " to " * string(max) * ".")
			else
				return int
			end
		end
	end
end

# Advance the game state by one move.
# Throw DomainError if given a terminal state.
function gameStep(players::Players, state::State)::State
	# Find the player type for this move
	if state.player == X
		playerType = players.X
	else
		playerType = players.O
	end
	while true
		if playerType == Human
			pos = parseInteger(
				1,
				9,
				showState(state)
			)
			move = Move(pos, state.player)
		else
			println(showState(state))
			println("Computer is thinking.")
			moves = minimaxMoves(state)[2]
			if length(moves) == 0
				throw(DomainError(state, "Expected non-terminal state."))
			else
				move = moves[1]
			end
		end
		try
			# So we don't call Base.join
			newState = TicTacToe.join(state, move)
			return newState
		catch e
			println(e.msg)
		end
	end
end

function gameLoop(players::Players)
	state = root
	while !terminal(state)
		state = gameStep(players, state)
	end
	println(showBoard(state.board))
	if wins(state.board, X)
		println("X wins!")
	elseif wins(state.board, O)
		println("O wins!")
	else
		println("It's a tie!")
	end
end

function main()
	greet()
	players = choosePlayers()
	gameLoop(players)
end

main()
