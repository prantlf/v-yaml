module yaml

import prantlf.jany { Any }

pub struct YamlError {
	Error
	message string
	line    usize
	column  usize
}

pub fn (err YamlError) msg() string {
	return '${err.message} on line ${err.line}, column ${err.column}'
}

fn fail_parse(parser &C.yaml_parser_t) YamlError {
	return YamlError{
		message: unsafe { cstring_to_vstring(parser.problem) }
		line: parser.problem_mark.line + 1
		column: parser.problem_mark.column + 1
	}
}

fn fail_decode(message string, event &C.yaml_event_t) YamlError {
	return YamlError{
		message: message
		line: event.start_mark.line + 1
		column: event.start_mark.column + 1
	}
}

fn fail_init() !Any {
	return error('initialising yaml parser failed')
}
