pub struct Queue<T, let Capacity: u32> {
	elements: &mut [T; Capacity + 1],
	start: &mut u32,
	end: &mut u32,
}

impl<T, let Capacity: u32> Queue<T, Capacity> {
	pub fn new(init: T) -> Queue<T, Capacity> {
		Queue {
			elements: &mut [init; Capacity + 1],
			start: &mut 0,
			end: &mut 0,
		}
	}

	pub fn push(self, element: T) {
		self.elements[*self.end] = element;
		*self.end = (*self.end + 1) % (Capacity + 1);
		assert(*self.start != *self.end, "Push while queue is full!");
	}

	pub fn top(self) -> T {
		self.elements[*self.start]
	}

	pub fn pop(self) -> T {
		assert(*self.start != *self.end, "Pop while queue is empty!");
		let top = self.top();
		*self.start = (*self.start + 1) % (Capacity + 1);
		top
	}

	pub fn is_empty(self) -> bool {
		*self.start == *self.end
	}
}
