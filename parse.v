module yaml

import os
import jany { Any }

fn C.strtod(charptr, &charptr) f64

pub fn parse_file(path string) !Any {
	file := C.fopen(path.str, 'r'.str)
	if isnil(file) {
		return error("${os.posix_get_error_msg(C.errno)} (\"${path}\")")
	}
	defer {
		C.fclose(file)
	}

	parser := C.yaml_parser_t{}
	if C.yaml_parser_initialize(&parser) == 0 {
		return fail_init()
	}
	defer {
		C.yaml_parser_delete(&parser)
	}

	C.yaml_parser_set_input_file(&parser, file)

	return parse(&parser)
}

pub fn parse_text(input string) !Any {
	parser := C.yaml_parser_t{}
	if C.yaml_parser_initialize(&parser) == 0 {
		return fail_init()
	}
	defer {
		C.yaml_parser_delete(&parser)
	}

	start := unsafe { input.str + after_bom(input) }
	C.yaml_parser_set_input_string(&parser, start, input.len)

	return parse(&parser)
}

fn parse(parser &C.yaml_parser_t) !Any {
	event := C.yaml_event_t{}
	for {
		if C.yaml_parser_parse(parser, &event) == 0 {
			return fail_parse(parser)
		}
		defer {
			C.yaml_event_delete(&event)
		}

		match event.@type {
			C.YAML_STREAM_START_EVENT, C.YAML_DOCUMENT_START_EVENT, C.YAML_DOCUMENT_END_EVENT {
				continue
			}
			C.YAML_STREAM_END_EVENT {
				return Any(jany.null)
			}
			C.YAML_MAPPING_START_EVENT {
				return parse_object(parser)
			}
			C.YAML_SEQUENCE_START_EVENT {
				return parse_array(parser)
			}
			C.YAML_SCALAR_EVENT {
				return parse_value(parser, &event)
			}
			C.YAML_NO_EVENT {
				return fail_decode('unexpected yaml event ${event.@type}', &event)
			}
			else {
				return fail_decode('unrecognised yaml event ${event.@type}', &event)
			}
		}
	}
	panic('unreachable code')
}

fn parse_object(parser &C.yaml_parser_t) !Any {
	event := C.yaml_event_t{}
	mut object := map[string]Any{}
	mut is_key := false
	mut key := ''
	for {
		if C.yaml_parser_parse(parser, &event) == 0 {
			return fail_parse(parser)
		}
		defer {
			C.yaml_event_delete(&event)
		}

		match event.@type {
			C.YAML_MAPPING_START_EVENT {
				if is_key {
					object[key] = parse_object(parser)!
					is_key = false
				} else {
					return fail_decode('key expected', &event)
				}
			}
			C.YAML_SEQUENCE_START_EVENT {
				if is_key {
					object[key] = parse_array(parser)!
					is_key = false
				} else {
					return fail_decode('key expected', &event)
				}
			}
			C.YAML_SCALAR_EVENT {
				if is_key {
					object[key] = parse_value(parser, &event)!
					is_key = false
				} else {
					key = parse_string(parser, &event)!
					is_key = true
				}
			}
			C.YAML_MAPPING_END_EVENT {
				return object
			}
			C.YAML_NO_EVENT, C.YAML_STREAM_START_EVENT, C.YAML_STREAM_END_EVENT,
			C.YAML_DOCUMENT_START_EVENT, C.YAML_DOCUMENT_END_EVENT {
				return fail_decode('unexpected yaml event ${event.@type}', &event)
			}
			else {
				return fail_decode('unrecognised yaml event ${event.@type}', &event)
			}
		}
	}
	panic('unreachable code')
}

fn parse_array(parser &C.yaml_parser_t) !Any {
	event := C.yaml_event_t{}
	mut array := []Any{}
	for {
		if C.yaml_parser_parse(parser, &event) == 0 {
			return fail_parse(parser)
		}
		defer {
			C.yaml_event_delete(&event)
		}

		match event.@type {
			C.YAML_MAPPING_START_EVENT {
				array << parse_object(parser)!
			}
			C.YAML_SEQUENCE_START_EVENT {
				array << parse_array(parser)!
			}
			C.YAML_SCALAR_EVENT {
				array << parse_value(parser, &event)!
			}
			C.YAML_SEQUENCE_END_EVENT {
				return array
			}
			C.YAML_NO_EVENT, C.YAML_STREAM_START_EVENT, C.YAML_STREAM_END_EVENT,
			C.YAML_DOCUMENT_START_EVENT, C.YAML_DOCUMENT_END_EVENT {
				return fail_decode('unexpected yaml event ${event.@type}', &event)
			}
			else {
				return fail_decode('unrecognised yaml event ${event.@type}', &event)
			}
		}
	}
	panic('unreachable code')
}

fn parse_value(parser &C.yaml_parser_t, event &C.yaml_event_t) !Any {
	raw := parse_raw(parser, event)!
	match event.data.scalar.style {
		C.YAML_PLAIN_SCALAR_STYLE {
			match raw {
				'null' {
					return Any(jany.null)
				}
				'true' {
					return Any(true)
				}
				'false' {
					return Any(false)
				}
				else {
					if number := parse_number(raw) {
						return Any(number)
					}
					return Any(raw.clone())
				}
			}
		}
		C.YAML_SINGLE_QUOTED_SCALAR_STYLE, C.YAML_DOUBLE_QUOTED_SCALAR_STYLE,
		C.YAML_LITERAL_SCALAR_STYLE, C.YAML_FOLDED_SCALAR_STYLE {
			return Any(raw.clone())
		}
		C.YAML_ANY_SCALAR_STYLE {
			return fail_decode('unexpected yaml scalar style ${event.data.scalar.style}',
				event)
		}
		else {
			return fail_decode('unrecognised yaml scalar style ${event.data.scalar.style}',
				event)
		}
	}
}

fn parse_number(s string) !f64 {
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

fn parse_string(parser &C.yaml_parser_t, event &C.yaml_event_t) !string {
	raw := parse_raw(parser, event)!
	return raw.clone()
}

fn parse_raw(parser &C.yaml_parser_t, event &C.yaml_event_t) !string {
	if !isnil(event.data.scalar.anchor) {
		anchor := unsafe { event.data.scalar.anchor.vstring() }
		return fail_decode('unsupported anchor "${anchor}"', event)
	}
	if !isnil(event.data.scalar.tag) {
		tag := unsafe { event.data.scalar.tag.vstring() }
		return fail_decode('unsupported tag "${tag}"', event)
	}
	return unsafe { event.data.scalar.value.vstring_with_len(event.data.scalar.length) }
}

fn after_bom(input string) usize {
	if input.len >= 3 {
		unsafe {
			text := input.str
			if text[0] == 0xEF && text[1] == 0xBB && text[2] == 0xBF {
				return 3
			}
		}
	}
	return 0
}
