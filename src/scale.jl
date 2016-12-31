typealias ScaleIntervals Vector{Int}

immutable Scale
  intervals :: ScaleIntervals
  tuning_size :: Int
  name :: Nullable{Symbol}
end

Scale(s) = Scale(s, 12)
Scale(s::ScaleIntervals, size::Int) = Scale(s, size, nothing)

@delegate Scale.intervals [
  Base.get, Base.getindex, Base.haskey,
  Base.getkey, Base.start, Base.done, Base.next,
  Base.isempty, Base.length, Base.hash
]
