# Prepend an element to the start of an array.
function cons(x::T, xs::Vector{T})::Vector{T} where T
	return vcat([x], xs)
end

# Append an element to the end of an array.
function append(xs::Vector{T}, x::T)::Vector{T} where T
	return vcat(xs, [x])
end

# Combine elements unambiguously using associative operation f.
# If the array is empty, return the identity element.
function fold(f, e::B, xs::Vector{A})::B where A where B
	ret = e
	for i in 1:length(xs)
		ret = f(ret, xs[i])
	end
	return ret
end

# Combine elements unambiguously using associative operation f.
# If the array is empty, throw a DomainError.
function fold1(f, xs::Vector{A}) where A
	if length(xs) == 0
		throw(DomainError(xs, "Vector must be nonempty."))
	elseif length(xs) == 1
		return xs[1]
	else
		ret = xs[1]
		for i in 2:length(xs)
			ret = f(ret, xs[i])
		end
		return ret
	end
end

# Create a new array whose elements are pairs of elements of the two given
# arrays.
# The array returned has the minimum length of given arrays.
function zip(xs::Vector{A}, ys::Vector{B})::Vector{Tuple{A, B}} where A where B
	f(x, y) = (x, y)
	return zipWith(f, xs, ys)
end

# Create a new array whose elements are given by applying binary function to the
# elements of the two given arrays.
# The array returned has the minimum length of given arrays.
function zipWith(f, xs::Vector{A}, ys::Vector{B}) where A where B
	ret = []
	for i in 1:min([length(xs), length(ys)])
		ret = append(ret, f(xs[i], ys[i]))
	end
	return ret
end

# Return the largest element of array.
# If array is empty, throw DomainError.
function max(xs::Vector{T})::T where T
	return xs[maxIndex(xs)]
end

# Return first element of xs mapped to the maximum by f.
# If array is empty, throw DomainError.
function maxBy(f, xs::Vector{T})::T where T
	return xs[maxIndexBy(f, xs)]
end

# Return index of first largest element of array.
# If array is empty, throw DomainError.
function maxIndex(xs::Vector{T})::Integer where T
	return maxIndexBy(identity, xs)
end

# Return index of first largest element of array mapped by f.
# If array is empty, throw DomainError.
function maxIndexBy(f, xs::Vector{T})::Integer where T
	if length(xs) == 0
		throw(DomainError(xs, "Vector must be nonempty."))
	else
		mi = 1
		for i in 2:length(xs)
			if f(xs[i]) > f(xs[mi])
				mi = i
			end
		end
		return mi
	end
end

# Return the smallest element of array.
# If array is empty, throw DomainError.
function min(xs::Vector{T})::T where T
	return xs[minIndex(xs)]
end

# Return first element of xs mapped to the minimum by f.
# If array is empty, throw DomainError.
function minBy(f, xs::Vector{T})::T where T
	return xs[minIndexBy(f, xs)]
end

# Return index of first smallest element of array.
# If array is empty, throw DomainError.
function minIndex(xs::Vector{T})::Integer where T
	return minIndexBy(identity, xs)
end

# Return index of first smallest element of array mapped by f.
# If array is empty, throw DomainError.
function minIndexBy(f, xs::Vector{T})::Integer where T
	if length(xs) == 0
		throw(DomainError(xs, "Vector must be nonempty."))
	else
		mi = 1
		for i in 2:length(xs)
			if f(xs[i]) < f(xs[mi])
				mi = i
			end
		end
		return mi
	end
end


# Turn multi-variable function f into a function on tuples.
function unCurry(f, tuple)
	return f(tuple...)
end

# Return the fiber of f over y.
# The elements x in xs such that f(x) == y.
function fiber(f, xs::Vector{A}, y::B)::Vector{A} where A where B
	isFiber(x) = f(x) == y
	return filter(isFiber, xs)
end

# Return a new array with the same contents as xs but with element i having
# a value of y.
function modify(xs::Vector{T}, i::Integer, y::T)::Vector{T} where T
	ys = deepcopy(xs)
	ys[i] = y
	return ys
end

# Return n (deep) copies of the given item into an array.
function replicate(x::T, n::Integer)::Vector{T} where T
	# Just to initlialize the array
	xs = repeat([x], n)
	for i in 1:n
		xs[i] = deepcopy(x)
	end
	return xs
end

# Concatenate array of arrays together.
function concat(xs::Vector{Vector{T}})::Vector{T} where T
	ret = T[]
	for x in xs
		ret = vcat(ret, x)
	end
	return ret
end

# Concatenate array of strings together.
function concat(xs::Vector{String})::String
	ret = ""
	for x in xs
		ret = ret * x
	end
	return ret
end

# Combine array of arrays by interspersing an element in between.
# Throw DomainError if array is empty.
function unSplit(xs::Vector{Vector{T}}, c::T)::Vector{T} where T
	if length(xs) == 0
		throw(DomainError(xs, "Empty array."))
	else
		ret = xs[1]
		for x in xs[2:end]
			ret = append(ret, c)
			ret = vcat(ret, x)
		end
		return ret
	end
end

# Combine array of strings by interspersing a char in between.
# Throw DomainError if array is empty.
function unSplit(xs::Vector{String}, c::Char)::String
	if length(xs) == 0
		throw(DomainError(xs, "Empty array."))
	else
		ret = xs[1]
		for x in xs[2:end]
			ret = ret * c
			ret = ret * x
		end
		return ret
	end
end
