module yaml

import jsany { UnmarshalOpts, unmarshal }

pub fn unmarshal_file[T](path string, opts UnmarshalOpts) !T {
	a := parse_file(path)!
	return unmarshal[T](a, opts)!
}

pub fn unmarshal_text[T](input string, opts UnmarshalOpts) !T {
	a := parse_text(input)!
	return unmarshal[T](a, opts)!
}
