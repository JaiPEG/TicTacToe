module TicTacToe

include("Util.jl")

export None, X, O
# Players include {X, O}
# PositionStates include {None, X, O}
None = 0
X = 1
O = 2

# Board is a list of 9 PositionStates
# Starting from the top-left, going right and then down

export State
# State for a game
struct State{T}
	board::Array{T}
	player
end

export Move
# Represents a move in a game.
# Unique identifier of a child state of a given state.
struct Move
	position
	player
end

export root
# Initial state
# The root node of game state tree.
# Board is empty, X goes first.
root = State(repeat([None], 9), X)

export full
# Test if the board is full.
function full(board)::Bool
	occupied(p) = board[p] != None
	return all(occupied, [1,2,3,4,5,6,7,8,9])
end

export wins
# Test if player wins with this board.
# CAVEAT: If the game is indeed in a winning state, the player whose
# turn it is is the LOSING player.
# E.g.: If wins(board, X) == true, then the current state is actually
# (board, O)
function wins(board, player)
	tl = board[1] == player
	tc = board[2] == player
	tr = board[3] == player
	ml = board[4] == player
	mc = board[5] == player
	mr = board[6] == player
	bl = board[7] == player
	bc = board[8] == player
	br = board[9] == player
	horz = (tl && tc && tr) || (ml && mc && mr) || (bl && bc && br)
	vert = (tl && ml && bl) || (tc && mc && bc) || (tr && mr && br)
	diag = (tl && mc && br) || (tr && mc && bl)
	return horz || vert || diag
end

export terminal
# Test if the state is a terminal state.
function terminal(state)::Bool
	return utility(state) != Nothing
end

export utility
# Get the utility (score) of the terminal state.
# If state is not a terminal state, return Nothing.
# X is the maximizing player.
# TODO: throw exception.
function utility(state)
	# The reason why we take in a state and not just a board, is
	# because, in principle, the utility function really should know
	# about the whole state. However, for simplicity, ignore the player
	# and just assume we have a consistent state.
	# (In contrast, the wins function really only needs to know about
	# the board).
	if wins(state.board, X)
		return 1
	elseif wins(state.board, O)
		return -1
	elseif full(state.board)
		return 0
	else
		return Nothing
	end
end

export nextPlayer
# Return the next player given the current player.
# If not given a valid player, throw DomainError
function nextPlayer(player)
	if player == X
		return O
	elseif player == O
		return X
	else
		throw(DomainError(player, "Invalid player."))
	end
end

export join
# Return the unique child state of the given state identified by the given
# move.
# If given move does define a valid child state of the given state,
# throw DomainError.
function join(state::State, move::Move)::State
	if move.player != state.player
		throw(DomainError(move, "Move must be played by current player."))
	elseif state.board[move.position] != None
		throw(DomainError(move, "Move must be played on an empty square."))
	else
		nextBoard = modify(state.board, move.position, move.player)
		nextState = State(nextBoard, nextPlayer(move.player))
		return nextState
	end
end

export childrenMoves
# Return the moves accessible from a given state.
# Accessible states grow as a DAG (tree-ish, but allows duplicate states).
# These are unique identifiers for the children of a node in such a DAG.
#
# See also: children.
function childrenMoves(state)
	boardF(pos) = state.board[pos]
	nextPositions = fiber(boardF, [1,2,3,4,5,6,7,8,9], None)
	nextMoves = map(pos -> Move(pos, state.player),
		nextPositions)
	return nextMoves
end

export children
# Return the states accessible from a given state.
# Accessible states grow as a DAG (tree-ish, but allows duplicate states).
# These are the children of a node in such a DAG.
#
# See also: childrenMoves.
function children(state)
	nextMoves = childrenMoves(state)
	# Assuming moves are valid, join should never fail.
	return map(move -> join(state, move), nextMoves)
end

export minimax
# Return the effective utility of the state using the minimax algorithm.
# Assumes optimal play by both players.
# X is the maximizer.
# TODO: alpha-beta pruning.
#
# See also: minimaxMoves.
function minimax(state::State)::Real
	u = utility(state)
	# If terminal state
	if u != Nothing
		return u
	else
		# X is the maximizing player
		if state.player == X
			return max(map(minimax, children(state)))
		# O is the minimizing player
		else
			return min(map(minimax, children(state)))
		end
	end
end

export minimaxMoves
# Return the effective utility of the state and the sequence of moves
# yielding such a result using the minimax algorithm.
# Assumes optimal play by both players.
# X is the maximizer.
# TODO: alpha-beta pruning.
#
# See also: minimax.
function minimaxMoves(state::State)::Tuple{Real, Array{Move}}
	u = utility(state)
	# If terminal state
	if u != Nothing
		return (u, [])
	else
		nextMoves = childrenMoves(state)
		nextStates = map(move -> join(state, move), nextMoves)
		uNextBestMoves = map(minimaxMoves, nextStates)
		getUtility(uMoves) = uMoves[1]
		# X is the maximizing player
		if state.player == X
			# Since state is not terminal
			# uNextBestMoves is not empty
			bestMoveIndex = maxIndexBy(getUtility, uNextBestMoves)
		# O is the minimizing player
		else
			# Since state is not terminal
			# uNextBestMoves is not empty
			bestMoveIndex = minIndexBy(getUtility, uNextBestMoves)
		end
		bestMove = nextMoves[bestMoveIndex]
		uBestMoves = uNextBestMoves[bestMoveIndex]
		return (uBestMoves[1],
			cons(bestMove, uBestMoves[2]))
	end
end

export showBoard
function showBoard(board)
	ret = ""
	function showPos(p)
		if board[p] == X
			return "X"
		elseif board[p] == O
			return "O"
		else
			return " "
		end
	end
	for i in 1:3
		for j in 1:3
			p = (i - 1)*3 + j
			ret = string(ret, showPos(p))
		end
		ret = string(ret, "\n")
	end
	return ret
end

export showState
function showState(state)
	function showPlayer(player)
		if player == X
			return "X"
		else
			return "O"
		end
	end
	return string(showBoard(state.board),
		"Player: ", showPlayer(state.player), "\n")
end

end # module
