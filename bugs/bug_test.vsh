#!/usr/bin/env -S v run

// vlib/v/tests/method_call_var_comp_test.v

struct EmptyStruct {
	a int
	b []int
}

struct Encoder {
}

fn (e &Encoder) encode_array[T](val []T) []T {
	return val
}

fn encode_struct[T](val T) []string {
	e := Encoder{}
	mut out := []string{}
	$if T is $struct {
		$for field in T.fields {
			out << field.name
			out << field.is_array.str()

			$if field.is_array {
				value := val.$(field.name)
				out << e.encode_array(value).str()
				out << e.encode_array([1, 2]).str()
			}
		}
	}
	return out
}

struct Decoder {
}

fn (e &Decoder) decode_array[T](mut val []T) {
}

fn decode_struct[T]() (T, []string) {
	d := Decoder{}
	val := T{}
	mut out := []string{}
	$if T is $struct {
		$for field in T.fields {
			out << field.name
			out << field.is_array.str()

			$if field.is_array {
				d.decode_array(mut val.$(field.name))
				out << val.$(field.name).str()
			}
		}
	}
	return val, out
}

out := encode_struct(EmptyStruct{3, [2, 1]})
println(out)
assert out[0] == 'a'
assert out[1] == 'false'
assert out[2] == 'b'
assert out[3] == 'true'
assert out[4] == '[2, 1]'
assert out[5] == '[1, 2]'

val, out2 := decode_struct[EmptyStruct]()
println(val)
println(out2)
