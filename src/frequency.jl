using PatternDispatch

degree_scale(degree, scale) = error()
degree_scale(degree, scale, tuning) = error()

@patterns begin
  function (@inverse degree_scale(degree, scale::Scale))(e)
  	e::Event
  	@guard haskey(e, :degree)
  	@guard haskey(e, :scale)
  	degree = e[:degree]
  	scale = e[:scale]
  end
  function (@inverse degree_scale(degree, scale::Scale, tuning::Tuning))(e)
  	e::Event
  	@guard haskey(e, :degree)
  	@guard haskey(e, :scale)
  	@guard haskey(e, :tuning)
  	degree = e[:degree]
  	scale = e[:scale]
  	tuning = e[:tuning]
  end

  to_freq(x) = error("Cannot convert to frequency: $(x)")
  to_freq(degree_scale(d, s)) = dst_to_freq(d, s, Tuning(:edo_12))
  to_freq(degree_scale(d, s, t)) = dst_to_freq(d, s, t)
end

function dst_to_freq(d::Int, s::Scale, t::Tuning)
  # TODO make this more robust
  t[s[d]]
end
