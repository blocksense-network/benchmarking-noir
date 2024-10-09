use super::queue::Queue;

pub struct Vertex<Name, Color> {
	name: Name,
	color: Color,
}

pub struct Graph<Name, Color, let Vertecies: u32> {
	vertecies: [Vertex<Name, Color>],
	adj: &mut [[bool; Vertecies]; Vertecies],
}

impl<Name, Color, let Vertecies: u32> Graph<Name, Color, Vertecies>
where Name: Eq, Color: Eq {
	pub fn new(
		adjacency: [[bool; Vertecies]; Vertecies],
		coloring: [(Name, Color); Vertecies],
	) -> Graph<Name, Color, Vertecies> {
		let ret = Graph {
			vertecies: coloring.map(|vc: (Name, Color)|
				Vertex {
					name: vc.0,
					color: vc.1,
				}),
			adj: &mut adjacency.map(|x| x),
		};
		ret
	}

	pub fn bfs(
		self,
		edge_callback: fn(Vertex<Name, Color>, Vertex<Name, Color>) -> (),
	) {
		let q: Queue<u32, Vertecies> = Queue::new(0);
		let mut mark = [false; Vertecies];
		q.push(0);
		mark[0] = true;

		for _ in 0..Vertecies {
			// If we have disconnected components, then we'll need to add start
			// vertecies for each component
			if q.is_empty() {
				for mi in 0..Vertecies {
					if q.is_empty() & (! mark[mi]) {
						q.push(mi);
						mark[mi] = true;
					}
				}
			}

			let curr_i = q.pop();
			for adj_i in 0..Vertecies {
				if self.adj[curr_i][adj_i] {
					if ! mark[adj_i] {
						edge_callback(self.vertecies[curr_i], self.vertecies[adj_i]);
						q.push(adj_i);
						mark[adj_i] = true;
					}
				}
			}
		}
	}
}
