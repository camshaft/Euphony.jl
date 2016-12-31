test:
	@julia -e 'Pkg.test("Euphony")' --compilecache=yes

testw: test
	@fswatch src test | xargs -n1 -I{} make test

.PHONY: test
