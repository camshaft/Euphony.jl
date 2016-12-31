typealias PHM PersistentHashMap{Symbol, Any}

immutable Event <: Sequencable
  d :: PHM
end

Event() = Event(PHM())
Event(d::Associative) = Event(merge(PHM(), d))
function Event(ps::Pair...)
  acc = PHM()
  for (k, v) in ps
    acc = FunctionalCollections.assoc(acc, k, v)
  end
  Event(acc)
end

@delegate Event.d [
  Base.get, Base.getindex, Base.haskey,
  Base.getkey, Base.start, Base.done, Base.next,
  Base.isempty, Base.length
]

FunctionalCollections.assoc(e::Event, k, v) = Event(assoc(e.d, k, v))
FunctionalCollections.dissoc(e::Event, k) = Event(dissoc(e.d, k))

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
