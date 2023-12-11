module yaml

import prantlf.jany { UnmarshalOpts }

fn test_unmarshal_null_to_scalar() {
	unmarshal_text[int]('', UnmarshalOpts{}) or {
		assert err.msg() == 'null cannot be cast to int'
		return
	}
	assert false
}

fn test_unmarshal_int() {
	r := unmarshal_text[int]('1', UnmarshalOpts{})!
	assert r == 1
}

fn test_unmarshal_u8() {
	r := unmarshal_text[u8]('1', UnmarshalOpts{})!
	assert r == 1
}

fn test_unmarshal_u16() {
	r := unmarshal_text[u16]('1', UnmarshalOpts{})!
	assert r == 1
}

fn test_unmarshal_u32() {
	r := unmarshal_text[u32]('1', UnmarshalOpts{})!
	assert r == 1
}

fn test_unmarshal_u64() {
	r := unmarshal_text[u64]('1', UnmarshalOpts{})!
	assert r == 1
}

fn test_inmarshal_i8() {
	r := unmarshal_text[u8]('1', UnmarshalOpts{})!
	assert r == 1
}

fn test_inmarshal_i16() {
	r := unmarshal_text[u16]('1', UnmarshalOpts{})!
	assert r == 1
}

fn test_inmarshal_i64() {
	r := unmarshal_text[u64]('1', UnmarshalOpts{})!
	assert r == 1
}

fn test_inmarshal_f32() {
	r := unmarshal_text[f32]('1.2', UnmarshalOpts{})!
	assert r == 1.2
}

fn test_inmarshal_f64() {
	r := unmarshal_text[f64]('1.2', UnmarshalOpts{})!
	assert r == 1.2
}

fn test_inmarshal_bool() {
	r := unmarshal_text[bool]('false', UnmarshalOpts{})!
	assert r == false
}

fn test_inmarshal_string() {
	r := unmarshal_text[string]('a', UnmarshalOpts{})!
	assert r == 'a'
}

fn test_unmarshal_array() {
	input := r'
- 1
'
	r := unmarshal_text[[]int](input, UnmarshalOpts{})!
	assert r == [1]
}

enum Human {
	man
	woman
}

// fn test_unmarshal_enum_num() {
// 	r := unmarshal_text[Human]('1', UnmarshalOpts{})!
// 	assert r == .woman
// }

// fn test_unmarshal_enum_nam() {
// 	r := unmarshal_text[Human]('woman', UnmarshalOpts{})!
// 	assert r == .woman
// }

struct Empty {}

fn test_unmarshal_empty_input() {
	unmarshal_text[Empty]('', UnmarshalOpts{}) or {
		assert err.msg() == 'null cannot be cast to yaml.Empty'
			|| err.msg() == 'null cannot be cast to .Empty' // GitHub CI
		return
	}
	assert false
}

fn test_unmarshal_empty_object() {
	unmarshal_text[Empty]('{}', UnmarshalOpts{})!
}

struct PrimitiveTypes {
	h      Human
	u8     u8
	u16    u16
	u32    u32
	u64    u64
	i8     i8
	i16    i16
	int    int
	i64    i64
	f32    f32
	f64    f64
	string string
	bool   bool
}

// fn test_unmarshal_primitive_types() {
// 	input := r'
// h:   woman
// u8:  1
// u16: 2
// u32: 3
// u64: 4
// i8:  5
// i16: 6
// int: 7
// i64: 8
// f32: 9.1
// f64: 9.2
// string: "s"
// bool: true
// '
// 	r := unmarshal_text[PrimitiveTypes](input, UnmarshalOpts{})!
// 	assert r.h == .woman
// 	assert r.u8 == 1
// 	assert r.u16 == 2
// 	assert r.u32 == 3
// 	assert r.u64 == 4
// 	assert r.i8 == 5
// 	assert r.i16 == 6
// 	assert r.int == 7
// 	assert r.i64 == 8
// 	assert r.f32 == 9.1
// 	assert r.f64 == 9.2
// 	assert r.string == 's'
// 	assert r.bool == true
// }

struct OptionalTypes {
	h      ?Human
	u8     ?u8
	u16    ?u16
	u32    ?u32
	u64    ?u64
	i8     ?i8
	i16    ?i16
	int    ?int
	i64    ?i64
	f32    ?f32
	f64    ?f64
	string ?string
	bool   ?bool
}

// fn test_unmarshal_optional_types() {
// 	input := r'
// h:   woman
// u8:  1
// u16: 2
// u32: 3
// u64: 4
// i8:  5
// i16: 6
// int: 7
// i64: 8
// f32: 9.1
// f64: 9.2
// string: "s"
// bool: true
// '
// 	r := unmarshal_text[OptionalTypes](input, UnmarshalOpts{})!
// 	assert r.h? == .woman
// 	assert r.u8? == 1
// 	assert r.u16? == 2
// 	assert r.u32? == 3
// 	assert r.u64? == 4
// 	assert r.i8? == 5
// 	assert r.i16? == 6
// 	assert r.int? == 7
// 	assert r.i64? == 8
// 	assert r.f32? == 9.1
// 	assert r.f64? == 9.2
// 	assert r.string? == 's'
// 	assert r.bool? == true
// }

struct PrimitiveNullType {
	int int
}

fn test_unmarshal_primitive_null_type() {
	input := r'
int: null
'
	r := unmarshal_text[PrimitiveNullType](input, UnmarshalOpts{}) or {
		assert err.msg() == 'null cannot be set to int of int'
		return
	}
	assert false
}

struct OptionalNullType {
	int ?int
}

fn test_unmarshal_optional_null_type() {
	input := r'
int: null
'
	r := unmarshal_text[OptionalNullType](input, UnmarshalOpts{})!
	r.int or { return }

	assert false
}

struct OptionalArray {
	int ?[]int
}

fn test_unmarshal_optional_array() {
	input := r'
int:
  - 1
'
	r := unmarshal_text[OptionalArray](input, UnmarshalOpts{})!
	assert r.int?.len == 1
	assert r.int?[0] == 1
}

/*
struct ArrayOfOptions {
	int []?int
}

fn test_unmarshal_array_of_options() {
	input := r'
int:
	- 1
'
	r := unmarshal_text[ArrayOfOptions](input, UnmarshalOpts{})!
	assert r.int.len == 1
	first := r.int[0]
	assert first? == 1
}
*/

struct ArrayInStruct {
	arr []int
}

fn test_unmarshal_array_in_struct() {
	input := r'
arr:
  - 1
'
	r := unmarshal_text[ArrayInStruct](input, UnmarshalOpts{})!
	assert r.arr.len == 1
	assert r.arr[0] == 1
}

struct InnerStruct {
	val int
}

struct OuterStruct {
	inner InnerStruct
}

fn test_unmarshal_struct_in_struct() {
	input := r'
inner:
  val: 1
'
	r := unmarshal_text[OuterStruct](input, UnmarshalOpts{})!
	assert r.inner.val == 1
}

struct Attributes {
	int    int    @[required]
	bool   bool   @[skip]
	string string
	f64    f64    @[json: float; required]
	u8     u8     @[nooverflow]
	u16    u16    @[nullable]
}

fn test_attributes() {
	input := r'
int: 1
float: 2.3
bool: true
u8: 1234
u16: null
'
	opts := UnmarshalOpts{
		require_all_fields: false
		forbid_extra_keys: false
		cast_null_to_default: false
		ignore_number_overflow: false
	}
	r := unmarshal_text[Attributes](input, opts)!
	assert r.int == 1
	assert r.bool == false
	assert r.string == ''
	assert r.f64 == 2.3
	assert r.u8 == u8(1234)
	assert r.u16 == 0
}
