mod queue;
mod graph;
use graph::{ Vertex, Graph };

global VERTECIES: u32 = 100;

type Name  = u8;
type Color = u8;
type Vert = Vertex<Name, Color>;

fn main(
	graph: pub [[bool; VERTECIES]; VERTECIES],
	colors: pub u8,
	coloring: [(Name, Color); VERTECIES]
) {
	// Does it use the correct amount of colors?
	let max_color = 1 + coloring.fold(0, |acc: u8, nc: (Name, Color)| {
			if nc.1 > acc { nc.1 }
			else          { acc }
		});
	assert(max_color == colors);

	// Is coloring correct?
	let g = Graph::new(graph, coloring);
	g.bfs(|first: Vert, second: Vert| {
		assert(first.color != second.color);
	});
}
