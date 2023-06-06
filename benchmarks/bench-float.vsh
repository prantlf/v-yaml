#!/usr/bin/env -S v run

import benchmark
import rand
import strconv
import time

fn C.strtod(charptr, &charptr) f64
fn C.strtol(charptr, &charptr, int) int

fn strtod(s string) !f64 {
	end := unsafe { nil }
	C.errno = 0
	n := C.strtod(s.str, &end)
	if C.errno != 0 {
		return error('out of range')
	}
	if unsafe { s.str + s.len != end } {
		return error('not a number')
	}
	return n
}

fn strtol(s string) !int {
	end := unsafe { nil }
	C.errno = 0
	n := C.strtol(s.str, &end, 10)
	if C.errno != 0 {
		return error('out of range')
	}
	if unsafe { s.str + s.len != end } {
		return error('not a number')
	}
	return n
}

fn str_to_num(s string) !f64 {
	if s.contains_any('.eE') {
		return strtod(s)!
	}
	return f64(strconv.atoi(s) or { strtod(s)! })
}

rand.seed([u32(time.now().unix), 0])

sample_size := 1500
mut strings := []string{}
for _ in 0 .. sample_size {
	n := rand.int_in_range(0, 10000000) or { 0 }
	strings << '${n}'
	d := rand.int_in_range(0, 10000000) or { 0 }
	f := rand.int_in_range(0, 10000000) or { 0 }
	strings << '${d}.${f}'
}

mut b := benchmark.start()

for s in strings {
	_ := strconv.atof64(s)!
}
b.measure('parsing floats')

for s in strings {
	_ := strtod(s)!
}
b.measure('parsing floats with C')

for s in strings {
	_ := f64(strconv.atoi(s) or { strtod(s)! })
}
b.measure('parsing integers and floats')

for s in strings {
	_ := str_to_num(s)!
}
b.measure('parsing integers and floats with check')
