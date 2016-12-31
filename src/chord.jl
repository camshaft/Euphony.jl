typealias Steps Vector{Int}

immutable Chord <: Sequencable
  steps :: Steps
  scale_size :: Int
  name :: Nullable{Symbol}
  seq :: Sequencable
end

Chord(s) = Chord(s, 7)
Chord(s::Steps, size::Int) = Chord(s, size, nothing)
Chord(steps, size, name) = Chord(steps, size, name, Event())

function Chord(s::Symbol, size::Int)
  if s == :triad && size == 7
    Chord([0, 2, 4], 7, s)
  end

  # TODO this is really slow to compile...
  # @match (s, size) begin
  #   (:triad, 7) => Chord([0, 2, 4], 7, s)
  #   (:sixth, 7) => Chord([0, 2, 4, 5], 7, s)
  #   (:seventh, 7) => Chord([0, 2, 4, 6], 7, s)
  #   (:ninth, 7) => Chord([0, 2, 4, 8], 7, s)
  #   (:eleventh, 7) => Chord([0, 2, 4, 8, 10], 7, s)
  # end
end

@delegate Chord.steps [
  Base.get, Base.getindex, Base.haskey,
  Base.getkey, Base.start, Base.done, Base.next,
  Base.isempty, Base.length, Base.hash
]

@delegate Chord.seq [
  Base.rot180, Base.rotr90, Base.rotl90
]

Base.convert(::Type{Vector{Sequencable}}, c::Chord) =
  Vector{Sequencable}(map(step -> merge(c.seq, :degree => step // c.scale_size), c.steps))

Base.convert(::Type{HSeq}, c::Chord) = HSeq(Vector{Sequencable}(c))
Base.convert(::Type{VSeq}, c::Chord) = VSeq(Vector{Sequencable}(c))
Base.merge(c::Chord, s::Sequencable) = Chord(c.steps, c.scale_size, c.name, merge(c.seq, s))
Base.merge(s::Sequencable, c::Chord) = Chord(c.steps, c.scale_size, c.name, merge(s, c.seq))

function circshift(c::Chord, count)
  # TODO wrap around the scale_size
  c
end
