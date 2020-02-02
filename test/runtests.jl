using Test
include("../src/Util.jl")
using TicTacToe

#
# Test Util
#

@testset "Util" begin
	@test cons(1, []) == [1]
	@test cons(1, [2, 3]) == [1, 2, 3]
	@test append([], 1) == [1]
	@test append([1, 2], 3) == [1, 2, 3]
	@test fold(+, 0, []) == 0
	@test fold(+, 0, [1, 2, 3]) == 6
	@test_throws DomainError fold1(+, [])
	@test zip([], []) == []
	@test zip([1, 2, 3], [4, 5, 6]) == [(1, 4), (2, 5), (3, 6)]
	@test zip([1], [2, 3]) == [(1, 2)]
	@test zip([1, 2], [3]) == [(1, 3)]
	@test zipWith(+, [], []) == []
	@test zipWith(+, [1, 2, 3], [4, 5, 6]) == [5, 7, 9]
	@test zipWith(+, [1], [2, 3]) == [3]
	@test zipWith(+, [1, 2], [3]) == [4]
	@test_throws DomainError max([])
	sqr(x) = x^2
	@test max([-2, -1, 0, 1]) == 1
	@test_throws DomainError maxBy(sqr, [])
	@test maxBy(sqr, [-2, -1, 0, 1]) == -2
	@test_throws DomainError maxIndex([])
	@test maxIndex([-2, -1, 0, 1]) == 4
	@test_throws DomainError maxIndexBy(sqr, [])
	@test maxIndexBy(sqr, [-2, -1, 0, 1]) == 1
	@test_throws DomainError min([])
	@test min([-2, -1, 0, 1]) == -2
	@test_throws DomainError minBy(sqr, [])
	@test minBy(sqr, [-2, -1, 0, 1]) == 0
	@test_throws DomainError minIndex([])
	@test minIndex([-2, -1, 0, 1]) == 1
	@test_throws DomainError minIndexBy(sqr, [])
	@test minIndexBy(sqr, [-2, -1, 0, 1]) == 3
	# @test unCurry
	@test fiber(sqr, [], 2) == []
	@test fiber(sqr, [-2, -1, 0, 1], 1) == [-1, 1]
	# test immutability
	@test modify([-2, -1, 0, 1], 1, 3) == [3, -1, 0, 1]
	@test_throws BoundsError modify([-2, -1, 0, 1], 0, 3)
	@test_throws BoundsError modify([-2, -1, 0, 1], 5, 3)
	# test original array is not altered
	a = [-2, -1, 0, 1]
	b = modify(a, 1, 3)
	@test a == [-2, -1, 0, 1]
	# test returned array is not altered
	a[1] = -2
	@test b == [3, -1, 0, 1]
	@test replicate(1, 0) == []
	@test replicate(1, 3) == [1, 1, 1]
	# test returned array is not altered
	a = [1]
	b = replicate(a, 3)
	a[1] = 2
	@test b == [[1], [1], [1]]
	# test original array is not altered and
	# test elements of returned array can be changed independently
	a = [1]
	b = replicate(a, 3)
	b[1][1] = 2
	@test a == [1]
	@test b == [[2], [1], [1]]
	@test concat([]::Array{Array{Int}}) == []::Array{Int}
	@test concat([[1, 2, 3], [4, 5, 6]]) == [1, 2, 3, 4, 5, 6]
	@test concat([]::Array{String}) == ""
	@test concat(["abc", "def"]) == "abcdef"
	@test unSplit([], 7) == [7]
	@test unSplit([[1, 2, 3], [4, 5, 6]], 7) == [1, 2, 3, 7, 4, 5, 6]
	@test unSplit([], '.') == "."
	@test unSplit(["abc", "def"], '.') == "abc.def"
end

#
# Test TicTacToe
#

@testset "TicTacToe" begin
	# Under optimal play, there should be a tie
	@test minimax(root) == 0
end
