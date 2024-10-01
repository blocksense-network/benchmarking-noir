mod queue;
mod graph;
use graph::{ Vertex, Graph };

type Name  = u8;
type Color = u8;
type Vert = Vertex<Name, Color>;

fn main(
	graph: pub [[Name; 2]; 2],
	colors: pub u32,
	coloring: [(Name, Color); 3]
) {
	// Does it use the correct amount of colors?
	let c = coloring.map(|nc: (Name, Color)| nc.1).sort();
	let mut colorcount = 1;
	for i in 1..c.len() {
		if c[i] != c[i-1] {
			colorcount = colorcount + 1;
		}
	}
	assert(colorcount == colors);

	// Is coloring correct?
	let g = Graph::new(graph, coloring);
	g.bfs(|first: Vert, second: Vert| {
		assert(first.color != second.color);
	});
}
