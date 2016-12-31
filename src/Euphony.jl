module Euphony

using Base
import Base: <, <=, ==

using FunctionalCollections
import FunctionalCollections: assoc, dissoc
export assoc, dissoc

abstract Sequencable

include("delegate.jl")

include("event.jl")
export Event

include("sequence.jl")
export Seq, HSeq, VSeq

include("chord.jl")
export Chord

include("scale.jl")
export Scale

end
