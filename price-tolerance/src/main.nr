mod float;
use float::{Float, lte, div, sub, abs, printlnF, sum};

global MAX_VALIDATORS = 8;

fn main(
    validators: pub [Float; MAX_VALIDATORS],
    tolerance: pub Float
) -> pub ([Float; MAX_VALIDATORS], u32, u32) {
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
    // If n == 0, then mid = MAX_VALIDATORS and index becomes too large
    assert(n > 0);

    // Sorted validator values
    let values = validators.sort_via(lte);

    let mut median: Float = (0, 0);

    // Compute median
    if n % 2 == 0 {
        median = div(
            sum(
                values[(MAX_VALIDATORS - n) + n / 2],
                values[(MAX_VALIDATORS - n) + n / 2 - 1]
            ),
            (2, 0)
        );
    }
    // Note; else gives a different behaviour here, so don't replace.
    if n % 2 != 0 {
        median = values[(MAX_VALIDATORS - n) + n / 2];
    }
    print("Median value: ");
    printlnF(median);

    println("Correct validator values: ");
    let mut correct_count: u32 = 0;
    // Compute reports
    for i in 0..MAX_VALIDATORS {
        if values[i].0 != 0 {
            // Percent change, not percent difference
            // The median is our "true" value, so we award only those who are close to the truth
            //  perc_chng = |values[i] - median| / median
            let perc_chng = div(abs(sub(values[i], median)), median);
            if lte(perc_chng, tolerance) {
                correct_count += 1;
                printlnF(values[i]);
            }
        }
    }

    print("Number of correct validators: ");
    print(correct_count);
    print(" of ");
    println(n);

    (values, correct_count, n)
}
