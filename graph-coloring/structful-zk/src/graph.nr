use super::queue::Queue;

pub struct Vertex<Name, Color> {
	name: Name,
	color: Color,
}

pub struct Graph<Name, Color, let Vertices: u32> {
	vertices: [Vertex<Name, Color>],
	adj: &mut [[bool; Vertices]; Vertices],
}

impl<Name, Color, let Vertices: u32> Graph<Name, Color, Vertices>
where Name: Eq, Color: Eq {
	pub fn new(
		adjacency: [[bool; Vertices]; Vertices],
		coloring: [(Name, Color); Vertices],
	) -> Graph<Name, Color, Vertices> {
		let ret = Graph {
			vertices: coloring.map(|vc: (Name, Color)|
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
		let q: Queue<u32, Vertices> = Queue::new(0);
		let mut mark = [false; Vertices];
		q.push(0);
		mark[0] = true;

		for _ in 0..Vertices {
			// If we have disconnected components, then we'll need to add start
			// vertices for each component
			if q.is_empty() {
				for mi in 0..Vertices {
					if q.is_empty() & (! mark[mi]) {
						q.push(mi);
						mark[mi] = true;
					}
				}
			}

			let curr_i = q.pop();
			for adj_i in 0..Vertices {
				if self.adj[curr_i][adj_i] {
					if ! mark[adj_i] {
						edge_callback(self.vertices[curr_i], self.vertices[adj_i]);
						q.push(adj_i);
						mark[adj_i] = true;
					}
				}
			}
		}
	}
}
