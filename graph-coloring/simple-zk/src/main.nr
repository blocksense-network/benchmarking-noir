global VERTICES: u32 = 10;

type Name  = u8;
type Color = u8;

fn main(
	graph: pub [[bool; VERTICES]; VERTICES],
	colors: pub u8,
	coloring: [(Name, Color); VERTICES]
) {
	// Does it use the correct amount of colors?
	let mut max_color = coloring[0].1;
	for nc in coloring {
		if nc.1 > max_color {
			max_color = nc.1;
		}
	}
	assert(max_color + 1 == colors);

	// Is coloring correct?
	for i in 0..VERTICES {
		for j in 0..VERTICES {
			// graph[i][j] -> coloring[i] != coloring[j]
			assert(! graph[i][j] | (coloring[i] != coloring[j]));
		}
	}
}
