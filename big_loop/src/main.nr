fn main(x: u64) {
    let mut y: u64 = x;
    for i in 0..100000 {
        y += i as u64;
    }
    assert(x != y);
}
