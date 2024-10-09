import networkx as nx
import sys
import scipy
argv = sys.argv

sys.stdout = open(argv[1], "wt")

def to_toml_arr(x):
    return list(map(list, x))

n = argv[2] if len(argv) > 2 else 100
m = argv[3] if len(argv) > 3 else 1.5 * n

G = nx.gnm_random_graph(n, m)

print("graph =", to_toml_arr(nx.adjacency_matrix(G).todense()))

coloring = list(nx.coloring.greedy_color(G).items())

print("colors =", 1 + max(map(lambda x: x[1], coloring)))
print("coloring =", sorted(to_toml_arr(coloring)))
