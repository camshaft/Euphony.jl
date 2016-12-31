typealias TuningIntervals Vector{Real}

immutable Tuning
  intervals :: TuningIntervals
  base :: Real
  name :: Nullable{Symbol}

  function Tuning(n::Symbol, base::Real)
    if n == :edo_12
      new(map(n -> 2 ^ (n / 12), 1:12), base, n)
    end
  end
end

Tuning(n) = Tuning(n, 440)

@delegate Tuning.intervals [
  Base.get, Base.getindex, Base.haskey,
  Base.getkey, Base.start, Base.done, Base.next,
  Base.isempty, Base.length, Base.hash
]
