.PHONY: all deps compile run

all: deps compile

deps:
	mix deps.get
	mix deps.compile

compile:
	mix compile

run:
	iex -S mix
