using PatternDispatch

immutable Tempo
  bpm::Real
  base::Real
end
Tempo(bpm) = Tempo(bpm, 1 // 4)

duration_tempo(duration, tempo) = error()

@patterns begin
  function (@inverse duration_tempo(duration, tempo))(e)
  	e::Event
  	@guard haskey(e, :duration)
  	@guard haskey(e, :tempo)
  	duration = e[:duration]
  	tempo = e[:tempo]
  end

  to_second(x) = error("Cannot convert to seconds: $(x)")
  to_second(duration_tempo(d, t)) = dt_to_second(d, t)
end

typealias DurationNum Union{Rational,Int}

function dt_to_second(d, tempo::Real)
  dt_to_second(d, Tempo(tempo))
end
function dt_to_second(d, tempo::Tempo)
  base = tempo.base
  bps(tempo.bpm) * beat_duration(d, base)
end

bps(d::DurationNum) = 60 // d
bps(d) = 60 / d

beat_duration(d::DurationNum, b::DurationNum) = d // b
beat_duration(d, b) = d / b
