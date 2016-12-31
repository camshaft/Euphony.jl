module Euphony

using Base
import Base: <, <=, ==

abstract Sequencable

include("delegate.jl")

include("event.jl")
export Event, assoc, dissoc

include("sequence.jl")
export Seq, HSeq, VSeq

include("chord.jl")
export Chord

include("scale.jl")
export Scale

end
