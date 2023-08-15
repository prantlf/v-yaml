#!/usr/bin/env -S v -prod run

import benchmark
import rand
import strconv
import time

fn C.strtod(charptr, &charptr) f64
fn C.strtol(charptr, &charptr, int) int

fn strtod(s string) !f64 {
	C.errno = 0
	n := C.strtod(s.str, 0)
	if C.errno != 0 {
		return error('range overflow')
	}
	return n
}

fn strtol(s string) !int {
	C.errno = 0
	n := C.strtol(s.str, 0, 10)
	if C.errno != 0 {
		return error('range overflow')
	}
	return n
}

rand.seed([u32(time.now().unix), 0])

sample_size := 3000
mut strings := []string{}
for _ in 0 .. sample_size {
	n := rand.int_in_range(0, 10000000) or { 0 }
	strings << '${n}'
}

mut b := benchmark.start()
for s in strings {
	_ := f64(strconv.atoi(s)!)
}
b.measure('parsing integers')

for s in strings {
	C.errno = 0
	_ := f64(C.strtol(s.str, 0, 10))
	if C.errno != 0 {
		panic('range overflow')
	}
}
b.measure('parsing integers with C')

for s in strings {
	_ := f64(strtol(s)!)
}
b.measure('parsing integers with C wrapped')

for s in strings {
	_ := strconv.atof64(s)!
}
b.measure('parsing floats')

for s in strings {
	_ := strconv.atof_quick(s)
}
b.measure('parsing floats quickly')

for s in strings {
	C.errno = 0
	_ := C.strtod(s.str, 0)
	if C.errno != 0 {
		panic('range overflow')
	}
}
b.measure('parsing floats with C')

for s in strings {
	_ := strtod(s)!
}
b.measure('parsing floats with C wrapped')
