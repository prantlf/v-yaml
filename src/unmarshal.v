module yaml

import prantlf.jany { UnmarshalOpts }

@[inline]
pub fn unmarshal_text[T](input string) !T {
	return unmarshal_text_opt[T](input, &UnmarshalOpts{})!
}

pub fn unmarshal_text_opt[T](input string, opts &UnmarshalOpts) !T {
	mut obj := T{}
	unmarshal_text_opt_to[T](input, mut obj, opts)!
	return obj
}

@[inline]
pub fn unmarshal_text_to[T](input string, mut obj T) ! {
	unmarshal_text_opt_to[T](input, mut obj, &UnmarshalOpts{})!
}

pub fn unmarshal_text_opt_to[T](input string, mut obj T, opts &UnmarshalOpts) ! {
	a := parse_text(input)!
	jany.unmarshal_opt_to[T](a, mut obj, opts)!
}

@[inline]
pub fn unmarshal_file[T](path string) !T {
	return unmarshal_file_opt[T](path, &UnmarshalOpts{})!
}

pub fn unmarshal_file_opt[T](path string, opts &UnmarshalOpts) !T {
	mut obj := T{}
	unmarshal_file_opt_to[T](path, mut obj, opts)!
	return obj
}

@[inline]
pub fn unmarshal_file_to[T](path string, mut obj T) ! {
	unmarshal_file_opt_to[T](path, mut obj, &UnmarshalOpts{})!
}

pub fn unmarshal_file_opt_to[T](path string, mut obj T, opts &UnmarshalOpts) ! {
	a := parse_file(path)!
	jany.unmarshal_opt_to[T](a, mut obj, opts)!
}
