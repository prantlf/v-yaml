module yaml

#flag -I @VROOT/libyaml/include
#flag @VROOT/libyaml/src/api.o
#flag @VROOT/libyaml/src/dumper.o
#flag @VROOT/libyaml/src/emitter.o
#flag @VROOT/libyaml/src/loader.o
#flag @VROOT/libyaml/src/parser.o
#flag @VROOT/libyaml/src/reader.o
#flag @VROOT/libyaml/src/scanner.o
#flag @VROOT/libyaml/src/writer.o
#include "yaml.h"

[typedef]
struct C.yaml_mark_t {
	index  usize
	line   usize
	column usize
}

[typedef]
struct C.yaml_event_t {
	@type int
	data  struct {
		scalar struct {
			anchor          &char = unsafe { nil }
			tag             &char = unsafe { nil }
			value           &char = unsafe { nil }
			length          int
			plain_implicit  int
			quoted_implicit int
			style           int
		}
	}

	start_mark C.yaml_mark_t
}

[typedef]
struct C.yaml_parser_t {
	problem      &char = unsafe { nil }
	problem_mark C.yaml_mark_t
}

fn C.yaml_parser_initialize(parser &C.yaml_parser_t) int
fn C.yaml_parser_delete(parser &C.yaml_parser_t)
fn C.yaml_parser_set_input_file(parser &C.yaml_parser_t, input &C.FILE)
fn C.yaml_parser_set_input_string(parser &C.yaml_parser_t, input &char, size usize)
fn C.yaml_parser_parse(parser &C.yaml_parser_t, event &C.yaml_event_t) int
fn C.yaml_event_delete(event &C.yaml_event_t)
