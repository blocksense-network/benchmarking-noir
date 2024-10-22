mod float;
use float::{Float, lte, div, sub, abs, printlnF, sum};

global MAX_VALIDATORS = 8;

fn main(
    validators: pub [Float; MAX_VALIDATORS],
    tolerance: pub Float
) -> pub ([Float; MAX_VALIDATORS], Float) {
    // Since you always need to provide MAX_VALIDATORS amount of values,
    // when validators are less, you can pass zeroes.

    // Count of actual validators
    let n = validators.fold(
        0,
        |acc: u32, curr: Float| { if curr.0 == 0 { acc } else { acc + 1 } }
    );
    // If n == 0, then mid = MAX_VALIDATORS and index becomes too large
    assert(n > 0);

    // Sorted validator values
    let values = validators.sort_via(lte);

    // Compute median
    let mid = (MAX_VALIDATORS - n) + n / 2;
    let mut median = values[mid];

    if n % 2 == 0 {
        median = div(sum(median, values[mid - 1]), (2, 0));
    }

    print("Median value: ");
    printlnF(median);

    println("Correct validator values: ");
    let mut correct: BoundedVec<Float, MAX_VALIDATORS> = BoundedVec::new();

    // Compute reports
    for i in 0..MAX_VALIDATORS {
        if values[i].0 != 0 {
            // Percent change, not percent difference
            // The median is our "true" value, so we award only those who are close to the truth
            //  perc_chng = |values[i] - median| / median
            let perc_chng = div(abs(sub(values[i], median)), median);

            if lte(perc_chng, tolerance) {
                correct.push(values[i]);
                printlnF(values[i]);
            }
        }
    }

    let percentage = div((correct.len() as i64, 0), (n as i64, 0));

    print("Number of correct validators: ");
    print(correct.len());
    print(" of ");
    print(n);
    print(" which is ");
    printlnF(percentage);

    (correct.storage(), percentage)
}
