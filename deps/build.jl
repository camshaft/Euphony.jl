using Base.Pkg

try Pkg.clone("https://github.com/camshaft/PatternDispatch.jl") end
Pkg.checkout("PatternDispatch", "new_pattern")
