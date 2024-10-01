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
		edges: [[Name; 2]],
		coloring: [(Name, Color); Vertecies],
	) -> Graph<Name, Color, Vertecies> {
		let ret = Graph {
			vertecies: coloring.map(|vc: (Name, Color)|
				Vertex {
					name: vc.0,
					color: vc.1,
				}),
			adj: &mut [[false; Vertecies]; Vertecies],
		};
		assert(edges.all(|edge: [Name; 2]| ret.add_edge(edge[0], edge[1])));
		ret
	}

	pub fn add_edge(self, v1: Name, v2: Name) -> bool {
		let first = self.get_vind(v1);
		let second = self.get_vind(v2);
		if first >= Vertecies | second >= Vertecies {
			false
		}
		else {
			self.adj[first][second] = true;
			self.adj[second][first] = true;
			true
		}
	}

	fn get_vind(self, v: Name) -> u32 {
		self.vertecies.fold(
			(false, 0),
			|acc: (bool, u32), curr: Vertex<Name, Color>| {
				if acc.0 {
					acc
				}
				else if curr.name == v {
					(true, acc.1)
				}
				else {
					(false, acc.1 + 1)
				}
			}).1
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
