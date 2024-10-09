import networkx as nx
import sys
import scipy
argv = sys.argv

outfile = argv[1] if len(argv) > 1 else "Prover.toml"
sys.stdout = open(outfile, "wt")

def to_toml_arr(x):
    return list(map(list, x))

n = int(argv[2]) if len(argv) > 2 else 100
m = int(argv[3]) if len(argv) > 3 else int(1.5 * n)

G = nx.gnm_random_graph(n, m)

print("graph =", to_toml_arr(nx.adjacency_matrix(G).todense()))

coloring = list(nx.coloring.greedy_color(G).items())

print("colors =", 1 + max(map(lambda x: x[1], coloring)))
print("coloring =", sorted(to_toml_arr(coloring)))
