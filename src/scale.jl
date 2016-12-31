typealias Steps Vector{Int}

immutable Scale
  steps :: Steps
  tuning_size :: Int
  name :: Nullable{Symbol}
end

Scale(s) = Scale(s, 12)
Scale(s::Steps, size::Int) = Scale(s, size, nothing)
