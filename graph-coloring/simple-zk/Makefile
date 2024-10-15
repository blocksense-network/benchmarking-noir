all: greedy-gen execute

greedy-gen:
ifdef V
	python ../greedy-gen/main.py Prover.toml ${V} ${E}
else
	python ../greedy-gen/main.py
endif

execute:
ifdef V
	sed -i "s/\(VERTICES.* =\) [0-9]*/\1 ${V}/" ./src/main.nr
endif
	nargo execute
