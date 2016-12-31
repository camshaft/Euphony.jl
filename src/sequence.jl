typealias SeqData Vector{Sequencable}

import Base

for _Seq in [:HSeq, :VSeq]
  @eval begin
    immutable $_Seq <: Sequencable
      d :: SeqData

      $_Seq(d::SeqData) = new(d)
    end

    $_Seq() = $_Seq(SeqData())
    $_Seq(d::Sequencable...) = $_Seq(SeqData([d...]))
    $_Seq(d::AbstractArray{Sequencable, 1}) = $_Seq(SeqData(d))

    @delegate $_Seq.d [
      Base.get, Base.getindex, Base.haskey,
      Base.getkey, Base.start, Base.done, Base.next,
      Base.isempty, Base.length, Base.hash
    ]

    Base.convert(::Type{$_Seq}, e::Event) = $_Seq(e)
    Base.convert(::Type{$_Seq}, v::Vector) = $_Seq(SeqData(v))

    function Base.show(io::IO, s::$_Seq)
      Base.print(io, $("Euphony.$(string(_Seq))"))
      Base.show_comma_array(io, s.d, "(", ")")
    end

    function Base.merge(s1::$_Seq, s2::$_Seq)
      $_Seq(map(t -> Base.merge(t[1], t[2]), zip(s1.d, s2.d)))
    end
    function Base.merge(s::$_Seq, d::AbstractArray)
      $_Seq(map(t -> Base.merge(t[1], t[2]), zip(s.d, d)))
    end
    function Base.merge(s::$_Seq, e::Event)
      $_Seq(map(i -> Base.merge(i, e), s.d))
    end
    function Base.merge(e::Event, s::$_Seq)
      $_Seq(map(i -> Base.merge(e, i), s.d))
    end
    function Base.merge(s::$_Seq, d::Associative)
      $_Seq(map(i -> Base.merge(i, d), s.d))
    end
    function Base.merge(s::$_Seq, p::Pair)
      Base.merge(s, Dict(p))
    end

    function Base.repeat(s::$_Seq; inner=1, outer=1)
      $_Seq(Base.repeat(s.d, inner=inner, outer=outer))
    end

    ==(s1::$_Seq, s2::$_Seq) = ==(s1.d, s2.d)
    <=(s1::$_Seq, s2::$_Seq) = <=(length(s1.d), length(s2.d))
    <(s1::$_Seq, s2::$_Seq) = <(length(s1.d), length(s2.d))

    Base.collect(::Type{$_Seq}, a) = $_Seq(a)
    Base.circshift(s::$_Seq, count) = $_Seq(Base.circshift(s.d, count))
    Base.reverse(s::$_Seq) = $_Seq(Base.reverse(s.d))
    Base.rot180(s::$_Seq) = $_Seq(Base.reverse(map(Base.rot180, s.d)))
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

Base.rotr90(s::HSeq) = VSeq(map(Base.rotr90, s.d))
Base.rotr90(s::VSeq) = HSeq(Base.reverse(map(Base.rotr90, s.d)))
Base.rotl90(s::HSeq) = VSeq(Base.reverse(map(Base.rotl90, s.d)))
Base.rotl90(s::VSeq) = HSeq(map(Base.rotl90, s.d))
