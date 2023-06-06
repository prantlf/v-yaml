#!/usr/bin/env -S v run

fn unmarshal_any[T]() T {
	mut typ := T{}
	$if T is $array {
		unmarshal_array(mut typ)
	}
	return typ
}

fn unmarshal_array[T](mut typ []T) {
	typ << 42
}

fn test_unmarshal() {
	arr := unmarshal_any[[]int]()
	println(arr)
}

test_unmarshal()
