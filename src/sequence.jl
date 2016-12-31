typealias PV PersistentVector{Sequencable}

import Base

# TODO this is a hack... figure out why it's iterating incorrectly
function _pv_to_array(pv::PV)
  acc = Vector{Sequencable}()
  for i in pv
    push!(acc, i)
  end
  acc
end

for _Seq in [:HSeq, :VSeq]
  @eval begin
    immutable $_Seq <: Sequencable
      d :: PV

      $_Seq(d::PV) = new(d) # We need this because PV inherits from AbstractArray
    end

    $_Seq() = $_Seq(PV())
    $_Seq(d::Sequencable...) = $_Seq(PV([d...]))
    $_Seq(d::AbstractArray{Sequencable, 1}) = $_Seq(PV(d))

    @delegate $_Seq.d [
      Base.get, Base.getindex, Base.haskey,
      Base.getkey, Base.start, Base.done, Base.next,
      Base.isempty, Base.length, Base.hash
    ]

    Base.convert(::Type{$_Seq}, e::Event) = $_Seq(e)
    Base.convert(::Type{$_Seq}, v::Vector) = $_Seq(PV(v))

    function Base.show(io::IO, s::$_Seq)
      Base.print(io, $("Euphony.$(string(_Seq))"))
      if length(s.d) > 0
        # For some reason it doesn't always print out all of the elements
        Base.show_comma_array(io, _pv_to_array(s.d), "(", ")")
      else
        Base.print(io, "()")
      end
    end

    function Base.merge(s1::$_Seq, s2::$_Seq)
      $_Seq(map(t -> Base.merge(t[1], t[2]), zip(s1.d, s2.d)))
    end
    function Base.merge(s::$_Seq, d::AbstractArray)
      $_Seq(map(t -> Base.merge(t[1], t[2]), zip(s.d, PersistentVector(d))))
    end
    function Base.merge(s::$_Seq, e::Event)
      if length(s.d) > 0
        $_Seq(PV(map(i -> Base.merge(i, e), s.d)))
      else
        s
      end
    end
    function Base.merge(e::Event, s::$_Seq)
      if length(s.d) > 0
        $_Seq(PV(map(i -> Base.merge(e, i), s.d)))
      else
        s
      end
    end
    function Base.merge(s::$_Seq, d::Associative)
      $_Seq(PV(map(i -> Base.merge(i, d), s.d)))
    end
    function Base.merge(s::$_Seq, p::Pair)
      Base.merge(s, Dict(p))
    end

    function Base.repeat(s::$_Seq; inner=1, outer=1)
      $_Seq(Base.repeat(_pv_to_array(s.d), inner=inner, outer=outer))
    end

    ==(s1::$_Seq, s2::$_Seq) = ==(s1.d, s2.d)
    <=(s1::$_Seq, s2::$_Seq) = <=(length(s1.d), length(s2.d))
    <(s1::$_Seq, s2::$_Seq) = <(length(s1.d), length(s2.d))

    Base.collect(::Type{$_Seq}, a) = $_Seq(a)
    Base.circshift(s::$_Seq, count) = $_Seq(Base.circshift(_pv_to_array(s.d), count))
    Base.reverse(s::$_Seq) = $_Seq(Base.reverse(s.d))
    function Base.rot180(s::$_Seq)
      acc = map(Base.rot180, _pv_to_array(s.d))
      $_Seq(Base.reverse(acc))
    end
  end
end

immutable EachRow{T<:AbstractMatrix}
  A::T
end
Base.start(::EachRow) = 1
Base.next(itr::EachRow, s) = (itr.A[s,:], s+1)
Base.done(itr::EachRow, s) = s > size(itr.A,1)
Base.length(itr::EachRow) = size(itr.A,1)

Base.convert(::Type{HSeq}, s::VSeq) = HSeq(s.d)
Base.convert(::Type{HSeq}, m::Matrix) = HSeq(map(VSeq, EachRow(m)))

Base.convert(::Type{VSeq}, s::HSeq) = VSeq(s.d)
Base.convert(::Type{VSeq}, m::Matrix) = VSeq(map(HSeq, EachRow(m)))

Base.rotr90(s::HSeq) = VSeq(map(Base.rotr90, _pv_to_array(s.d)))
Base.rotr90(s::VSeq) = HSeq(Base.reverse(map(Base.rotr90, _pv_to_array(s.d))))
Base.rotl90(s::HSeq) = VSeq(Base.reverse(map(Base.rotl90, _pv_to_array(s.d))))
Base.rotl90(s::VSeq) = HSeq(map(Base.rotl90, _pv_to_array(s.d)))
