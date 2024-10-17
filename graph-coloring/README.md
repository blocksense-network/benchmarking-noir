# Graph Coloring Zero-knowledge Program

This is a small set of [Noir](https://noir-lang.org/) programs, which solve [N-coloring](https://en.wikipedia.org/wiki/Graph_coloring#Vertex_coloring) of graphs.

The graph (represented as an adjacency matrix) and amount of colors (`N`) are public, while the coloring is private.
Our aim is to prove we have an N-coloring for the given graph, without sharing that coloring.

## Usage

Make sure to have all dependencies installed!

- `greedy-gen`: Python with NetworkX
- `bruteforce-gen`: GCC compiler

Choose a zero-knowledge implementation: `simple-zk` or `structful-zk`

```bash
cd xxxxx-zk
make
```

If you want to change the amount of vertices and edges (by default, edges are `1.5 * vertices` rounded, you may omit them) you'll need to set the `V` and `E` variables, like this:

```bash
make V=20 # edges will be 30
```

```bash
make V=20 E=5
```

By default `make` will use `greedy-gen`. To use the non-greedy
`bruteforce-gen`, **first** create a `graph.txt` file, **then** run

```bash
make bfg
```

Here you're defining the vertices (and edges in practice) in `graph.txt`.

## Components

### greedy-gen

A small Python program to generate our `Prover.toml`, meaning to generate our graph and coloring.
It uses networkx's greedy_color for coloring.

Arguments: `<OUTPUT_FILE> <VERTICES> <EDGES>`  
Defaults: `Prover.toml 10 15`  
All argument's are optional.

### bruteforce-gen

A parallelized 3-coloring implementation, written in C++, which isn't greedy.
Contrary to `greedy-gen`, it doesn't generate the graph. Hint: you can still
use `greedy-gen` to generate the graph and then convert the Prover.toml in
graph.txt so you can use it as an input for `bruteforce-gen`.

You need to have the amount of vertices and then an adjacency matrix, all
separated with blank characters (space, newline, tab), inside a file called
`graph.txt`.

Prints a `Prover.toml`.

### simple-zk

The simplest possible implementation of the program: using two for-loops in `main`.

### structful-zk

A more sophisticated implementation, using small Graph and Queue libraries, with the goal of representing more closely what Noir code may look like in the future.

### Comparison between zk-s

*Timing done on an AMD Ryzen 9 9950X*

|Vertices|simple-zk|structful-zk|
|--------|---------|------------|
|     10 |   0.11s |      0.56s |
|     20 |   0.16s |      2.55s |
|     30 |   0.20s |      8.22s |
|     40 |   0.27s |     19.68s |
|     50 |   0.38s |     37.49s |
|     60 |   0.50s |     63.00s |
|    100 |   1.31s |          - |
|    200 |   5.43s |          - |
|    300 |  12.22s |          - |
|    400 |  21.73s |          - |
|    500 |  35.16s |          - |
|    600 |  49.60s |          - |
