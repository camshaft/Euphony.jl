# Sequence

for _Seq in [:HSeq, :VSeq]
  @eval begin
    # constructor
    @test length($_Seq()) == 0
    @test length($_Seq(Event())) == 1
    @test length($_Seq(HSeq())) == 1
    @test length($_Seq(VSeq())) == 1
    @test length($_Seq(Event(), HSeq(), VSeq())) == 3
    @test length($_Seq([Event(), HSeq(), VSeq()])) == 3

    # conversion
    @test convert($_Seq, Event(:foo => 1)) == $_Seq(Event(:foo => 1))
    @test convert($_Seq, [Event(:foo => 1)]) == $_Seq(Event(:foo => 1))

    # show
    @test length("$($_Seq())") > 0
    @test length("$($_Seq(Event()))") > 0

    # merge
    @test merge($_Seq(), $_Seq()) == $_Seq()
    @test merge($_Seq(Event(:foo => 1)), $_Seq(Event(:bar => 1))) ==
      $_Seq(Event(:foo => 1, :bar => 1))
    @test merge(Event(), $_Seq()) == $_Seq()
    @test merge(Event(), $_Seq(Event())) == $_Seq(Event())
    @test merge($_Seq(), Event()) == $_Seq()
    @test merge($_Seq(Event()), Event()) == $_Seq(Event())
    @test merge($_Seq(Event()), [Dict(:foo => 1)]) == $_Seq(Event(:foo => 1))
    @test merge($_Seq(Event()), Dict(:foo => 1)) == $_Seq(Event(:foo => 1))
    @test merge($_Seq(Event()), :foo => 1) == $_Seq(Event(:foo => 1))

    # repeat
    @test repeat($_Seq(Event(:foo => 1), Event(:bar => 1)), inner=2) ==
      $_Seq(Event(:foo => 1), Event(:foo => 1), Event(:bar => 1), Event(:bar => 1))
    @test repeat($_Seq(Event(:foo => 1), Event(:bar => 1)), outer=2) ==
      $_Seq(Event(:foo => 1), Event(:bar => 1), Event(:foo => 1), Event(:bar => 1))

    # collection
    @test collect($_Seq, []) == $_Seq()
    @test collect($_Seq, [Event(), VSeq(), HSeq()]) ==
      $_Seq(Event(), VSeq(), HSeq())

    @test circshift($_Seq(Event(:i => 1), Event(:i => 2), Event(:i => 3)), 1) ==
      $_Seq(Event(:i => 3), Event(:i => 1), Event(:i => 2))
    @test circshift($_Seq(Event(:i => 1), Event(:i => 2), Event(:i => 3)), -1) ==
      $_Seq(Event(:i => 2), Event(:i => 3), Event(:i => 1))

    @test reverse($_Seq(Event(:i => 1), Event(:i => 2), Event(:i => 3))) ==
      $_Seq(Event(:i => 3), Event(:i => 2), Event(:i => 1))

    @test rot180($_Seq(Event(:i => 1), Event(:i => 2), Event(:i => 3))) ==
      $_Seq(Event(:i => 3), Event(:i => 2), Event(:i => 1))
  end
end

# specific conversion
@test convert(HSeq, VSeq(Event())) == HSeq(Event())
@test convert(VSeq, HSeq(Event())) == VSeq(Event())

# matrix
@test HSeq([Event(:i => 0) Event(:i => 1); Event(:i => 2) Event(:i => 3)]) ==
  HSeq(VSeq(Event(:i => 0),Event(:i => 1)), VSeq(Event(:i => 2),Event(:i => 3)))
@test VSeq([Event(:i => 0) Event(:i => 1); Event(:i => 2) Event(:i => 3)]) ==
  VSeq(HSeq(Event(:i => 0),Event(:i => 1)), HSeq(Event(:i => 2),Event(:i => 3)))

m =
  VSeq([Event(:i => 0) Event(:i => 1) Event(:i => 2);
        Event(:i => 3) Event(:i => 4) Event(:i => 5)])

r1 = rotr90(m)
r2 = rotr90(r1)
r3 = rotr90(r2)
r4 = rotr90(r3)
l1 = rotl90(m)
l2 = rotl90(l1)
l3 = rotl90(l2)
l4 = rotl90(l3)

@test r1 == l3 ==
  HSeq([Event(:i => 3) Event(:i => 4) Event(:i => 5);
        Event(:i => 0) Event(:i => 1) Event(:i => 2)])

@test r2 == l2 ==
  VSeq([Event(:i => 5) Event(:i => 4) Event(:i => 3);
        Event(:i => 2) Event(:i => 1) Event(:i => 0)])

@test r3 == l1 ==
  HSeq([Event(:i => 2) Event(:i => 1) Event(:i => 0);
        Event(:i => 5) Event(:i => 4) Event(:i => 3)])

@test r4 == l4 == m
