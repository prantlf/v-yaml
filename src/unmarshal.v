module yaml

import prantlf.jany { UnmarshalOpts }

pub fn unmarshal_text[T](input string, opts &UnmarshalOpts) !T {
	mut obj := T{}
	unmarshal_text_to[T](input, mut obj, opts)!
	return obj
}

pub fn unmarshal_text_to[T](input string, mut obj T, opts &UnmarshalOpts) ! {
	a := parse_text(input)!
	jany.unmarshal_to[T](a, mut obj, opts)!
}

pub fn unmarshal_file[T](path string, opts &UnmarshalOpts) !T {
	mut obj := T{}
	unmarshal_file_to[T](path, mut obj, opts)!
	return obj
}

pub fn unmarshal_file_to[T](path string, mut obj T, opts &UnmarshalOpts) ! {
	a := parse_file(path)!
	jany.unmarshal_to[T](a, mut obj, opts)!
}
