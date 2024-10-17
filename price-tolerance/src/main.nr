mod float;
use float::{ Float, lte, div, sub, sum, abs, printlnF };

global MAX_VALIDATORS = 8;

fn main(
	validators: [Float; MAX_VALIDATORS],
	tolerance: Float,
) {
	// Helpers
	let n = validators.fold(0, |acc: u32, curr: Float| {
		if curr.0 == 0 {
			acc
		}
		else {
			acc + 1
		}
	});
	let values = validators.sort_via(lte).map(|x: Float| if x.0 == 0 { (1,0) } else { x });

	// Compute median
	let median = values[(MAX_VALIDATORS - n) + n / 2];
	printlnF(median);

	// Compute reports
	for i in 0..MAX_VALIDATORS {
		if values[i].0 != 0 {
			let perc_diff = div(abs(sub(values[i], median)), div(sum(values[i], median), (2,0)));
			if lte(perc_diff, tolerance) {
				printlnF(values[i]);
			}
		}
	}
}
