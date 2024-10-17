type Float = (i64, i64);

// Given two Floats, make sure they have the same exponent
fn fix_exp(lhs: Float, rhs: Float) -> (Float, Float) {
	let mut l = lhs;
	let mut r = rhs;

	let expdiff = l.1 - r.1;
	if expdiff > 0 { // lhs bigger
		l.0 = l.0 * pow10[expdiff];
		l.1 -= expdiff;
	}
	else if expdiff < 0 { // rhs bigger
		r.0 = r.0 * pow10[-expdiff];
		r.1 -= expdiff;
	}

	(l, r)
}

pub fn lte(lhs: Float, rhs: Float) -> bool {
	let (l, r) = fix_exp(lhs, rhs);
	l.0 <= r.0
}

fn lower_pow(x: Float, power: u64) -> Float {
	(x.0 * pow10[power], x.1 - (power as i64))
}

pub fn div(lhs: Float, rhs: Float) -> Float {
	let mut l = if lhs.0 < rhs.0 {
			lower_pow(lhs, 5)
		} else {
			lhs
		};
	let mut r = rhs;
	(l.0 / r.0, l.1 - r.1)
}

pub fn sub(lhs: Float, rhs: Float) -> Float {
	let (l, r) = fix_exp(lhs, rhs);
	(l.0 - r.0, l.1)
}

pub fn sum(lhs: Float, rhs: Float) -> Float {
	let (l, r) = fix_exp(lhs, rhs);
	(l.0 + r.0, l.1)
}

pub fn abs(x: Float) -> Float {
	if x.0 < 0 {
		(-x.0, x.1)
	}
	else {
		x
	}
}

global pow10: [i64; 10] = [
	1,
	10,
	100,
	1000,
	10000,
	100000,
	1000000,
	10000000,
	100000000,
	1000000000,
];

fn num_len(x: i64) -> i64 {
	let mut len = 0;
	let mut num = x;
	for _ in 0..10 {
		if num != 0 {
			num /= 10;
			len += 1;
		}
	}
	len
}

pub fn printlnF(x: Float) {
	if x.1 >= 0 {
		println(x.0 * pow10[x.1]);
	}
	else {
		print(x.0 / pow10[-x.1]);
		print(".");
		let fractional_part = x.0 % pow10[-x.1];
		let zeroes = -x.1 - num_len(fractional_part);
		for i in 0..10 {
			if i < zeroes {
				print("0");
			}
		}
		println(fractional_part);
	}
}
