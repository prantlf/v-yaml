#!/usr/bin/env -S v run

struct EmptyStruct {
pub mut:
	b int
}

fn unmarshal_any[T]() T {
	mut typ := T{}
	$if T is $struct {
		unmarshal_struct(mut typ)
	}
	return typ
}

fn unmarshal_struct[T](mut typ T) {
	typ.b = 42
}

fn test_unmarshal() {
	em := unmarshal_any[EmptyStruct]()
	println(em)
}

test_unmarshal()
