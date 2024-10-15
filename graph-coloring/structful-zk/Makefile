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

bfg: bruteforce-gen execute-bfg

bruteforce-gen:
	g++ -O3 ../bruteforce-gen/color.cpp -o color.out
	./color.out < graph.txt > Prover.toml

execute-bfg:
	V="$$(sed -n '/[0-9]\+/{s/^[ \t\n]*//;s/[ \t\n].*//;p;Q}' graph.txt)" ;\
	sed -i "s/\(VERTICES.* =\) [0-9]*/\1 $$V/" ./src/main.nr
	nargo execute
