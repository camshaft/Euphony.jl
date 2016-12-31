# Event

# constructor
@test length(Event()) == 0
@test length(Event(:foo => 1)) == 1
@test length(Event(:foo => 1, :bar => 2)) == 2
@test length(Event(Dict(:foo => 1))) == 1

# show
@test length("$(Event(:foo => 1, :bar => 1))") > 0

# merge
@test merge(Event(:foo => 2), Event(:foo => 1)) == Event(:foo => 1)
@test merge(Event(:foo => 1), Dict(:bar => 1)) == Event(:foo => 1, :bar => 1)
@test merge(Event(:foo => 1), :bar => 1) == Event(:foo => 1, :bar => 1)

# repeat
@test repeat(Event(:foo => 1), 2) == [Event(:foo => 1), Event(:foo => 1)]

# assoc
@test assoc(Event(), :foo, 1) == Event(:foo => 1)
@test dissoc(Event(:foo => 1), :foo) == Event()

# conversion
@test convert(Event, :foo => 1) == Event(:foo => 1)
