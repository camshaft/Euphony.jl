typealias EventData Dict{Symbol, Any}

immutable Event <: Sequencable
  d :: EventData
end

Event() = Event(EventData())
Event(d::Associative) = Event(merge(EventData(), d))
Event(ps::Pair...) = Event(EventData(ps...))

@delegate Event.d [
  Base.get, Base.getindex, Base.haskey,
  Base.getkey, Base.start, Base.done, Base.next,
  Base.isempty, Base.length
]

assoc(e::Event, k::Symbol, v::Any) = Event(setindex!(copy(e.d), v, k))
dissoc(e::Event, k::Symbol) = Event(delete!(copy(e.d), k))

Base.convert(::Type{Event}, p::Pair) = Event(p)
Base.convert(::Type{Event}, p::Tuple) = Event([p])

function Base.show(io::IO, e::Event)
  limit::Bool = Base.get(io, :limit, false)

  print(io, "Euphony.Event(")
  first = true
  n = 0
  for (k, v) in e.d
    first || print(io, ',')
    first = false
    show(io, k)
    print(io, " => ")
    show(io, v)
    n+=1
    limit && n >= 10 && (print(io, "…"); break)
  end
  print(io, ')')
end

==(e1::Event, e2::Event) = ==(e1.d, e2.d)

function Base.merge(e1::Event, e2::Event)
  Event(Base.merge(e1.d, e2.d))
end
function Base.merge(e::Event, a::Associative)
  Event(Base.merge(e.d, a))
end
function Base.merge(e::Event, p::Pair)
  Event(Base.merge(e.d, Dict(p)))
end

function Base.repeat(e::Event, count)
  Base.repeat([e], inner=count)
end

# Just for a clean visitor pattern :)
Base.rot180(e::Event) = e
Base.rotr90(e::Event) = e
Base.rotl90(e::Event) = e
