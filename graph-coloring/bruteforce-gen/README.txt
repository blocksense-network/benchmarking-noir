This directory implements a brute-force solver for the graph 3-coloring
problem. It spawns 81 threads to leverage parallelism.

`greedy-24-48.txt` is the output of the greedy algorithm written in python for
a graph with 24 nodes and 48 edges; it gives a 4-coloring as a result. It
finishes in negligible time (<<1s).

`24-48-graph-2.txt` is the input for `color.cpp` for the same graph; it gives a
valid 3-coloring in 44 seconds on a 32-core i9-13900K.

`24-48-graph.txt` is the input for `color.cpp` for another graph with the same
features (24 nodes; 48 edges); it gives a valid 3-coloring in 1.5 minutes.

Note that runtime may vary, even on the same machine, since there is randomness
in the parallelized solution (in distributing the initial colorings that
searching starts from).

`24-48-graph-none.txt` is an input of `color.cpp` for another graph with the
same features (24 nodes; 48 edges) that is not 3-colorable; it gives a correct
negative result in 1.6 minutes.

Same goes for `greedy-22-44.txt` and `22-44-graph.txt`: the greedy alg gives a
4-coloring for it; the bruteforce finds a 3-coloring in 9 seconds.
