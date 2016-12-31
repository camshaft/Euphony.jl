using PatternDispatch

duration_tempo(duration, tempo) = error()
duration_tempo(duration, tempo, beat) = error()

@patterns begin
  function (@inverse duration_tempo(duration, tempo))(e)
  	e::Event
  	@guard haskey(e, :duration)
  	@guard haskey(e, :tempo)
  	duration = e[:duration]
  	tempo = e[:tempo]
  end
  function (@inverse duration_tempo(duration, tempo, beat))(e)
  	e::Event
  	@guard haskey(e, :duration)
  	@guard haskey(e, :tempo)
  	@guard haskey(e, :tempo_beat)
  	duration = e[:duration]
  	tempo = e[:tempo]
  	beat = e[:tempo_beat]
  end

  to_second(x) = error("Cannot convert to seconds: $(x)")
  to_second(duration_tempo(d, s)) = dt_to_second(d, s, 1 // 4)
  to_second(duration_tempo(d, s, b)) = dt_to_second(d, s, b)
end

typealias DurationNum Union{Rational,Int}

function dt_to_second(d, tempo, beat)
  bps(tempo) * beat_duration(d, beat)
end

bps(d::DurationNum) = 60 // d
bps(d) = 60 / d

beat_duration(d::DurationNum, b::DurationNum) = d // b
beat_duration(d, b) = d / b
