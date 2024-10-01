import networkx as nx
import sys

sys.stdout = open("Prover.toml", "wt")

def to_toml_arr(x):
    return list(map(list, x))

argv = sys.argv
n = sys.argv[2] if len(argv) >= 2 else 7
m = sys.argv[3] if len(argv) >= 3 else 9

G = nx.dense_gnm_random_graph(n, m)

print("graph =", to_toml_arr(G.edges))

coloring = list(nx.coloring.greedy_color(G).items())

print("colors =", 1 + max(map(lambda x: x[1], coloring)))
print("coloring =", to_toml_arr(coloring))
