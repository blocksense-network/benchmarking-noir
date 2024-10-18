mod float;
use float::{Float, lte, div, sub, abs, printlnF};

global MAX_VALIDATORS = 8;

fn main(validators: pub [Float; MAX_VALIDATORS], tolerance: pub Float) {
    // Since you always need to provide MAX_VALIDATORS amount of values,
    // when validators are less, you can pass zeroes.

    // Count of actual validators
    let n = validators.fold(
        0,
        |acc: u32, curr: Float| {
		if curr.0 == 0 {
			acc
		}
		else {
			acc + 1
		}
	}
    );
    // Sorted validator values
    let values = validators.sort_via(lte).map(|x: Float| if x.0 == 0 { (1,0) } else { x });

    // Compute median
    let median = values[(MAX_VALIDATORS - n) + n / 2];
    printlnF(median);

    // Compute reports
    for i in 0..MAX_VALIDATORS {
        if values[i].0 != 0 {
            // Percent change, not percent difference
            // The median is our "true" value, so we award only those who are close to the truth
            //  perc_chng = |values[i] - median| / median
            let perc_chng = div(abs(sub(values[i], median)), median);
            if lte(perc_chng, tolerance) {
                printlnF(values[i]);
            }
        }
    }
}
