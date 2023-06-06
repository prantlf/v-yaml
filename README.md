# YAML Parser and Formatter

Strictly parse and format YAML data.

* Works with the `Any` type suitable for safe handling of JSON/YAML data.
* Allows unmarshalling the YAML contents to a static V type.

Uses [jany]. See also the [json] package.

## Synopsis

```go
import yaml { parse_file, parse_text }

// Parse text input
input := r'
  answer: 42
'
any := parse_text(input)!

// Log the Any data
println(any.str()) // {answer:42}

// Get a value
config := any.object()!
answer := config['answer']!.int()!

// Unmarshal a file to a V type
struct Config {
	answer int
}
config := unmarshal_file[Config]('config.yaml')
```

## Installation

This package isn't ready for installation from [VPM] or from GitHub yet. It has a native C dependency, which has to be built before this package can be used. This is a workaround how to develop for the time being:

1) Clone and build the native library from the sources:

```sh
git clone --recurse-submodules git://github.com/prantlf/v-yaml.git
cd v-yaml/libyaml
./bootstrap
./configure
make
```

2) Create a symbolic link in your project using this package:

```sh
cd myproject
ln -s ../v-yaml yaml
```

V will resolve the import `yaml` to the symlinked directory.

You will usually need the `Any` type as well, either from [VPM] or from GitHub:

```txt
v install prantlf.jany
v install --git https://github.com/prantlf/v-jany
```

## API

### parse_text(input string) !Any

Parses an input string in the YAML format to an `Any` value. See [jany] for more information about the `Any` type.

```go
input := r'
  answer: 42
'
any := parse_text(input)
```

### parse_file(path string) !Any

Loads the contents of a text file in the YAML format and parses it to an `Any` value. See [jany] for more information about the `Any` type.

```go
any := parse_file('config.yaml')
```

### unmarshal_text[T](input string, opts UnmarshalOpts) !T

Unmarshals an input string in the YAML format to an instance of `T`. See [jany] for more information about the `Any` type and the `UnmarshalOpts` struct.

```go
struct Config {
	answer int
}

input := r'
  answer: 42
'
config := unmarshal_text[Config](input)
```

### unmarshal_file[T](path string, opts UnmarshalOpts) !T

Loads the contents of a text file in the YAML format and unmarshals it to an instance of `T`. See [jany] for more information about the `Any` type and the `UnmarshalOpts` struct.

```go
struct Config {
	answer int
}

config := unmarshal_file[Config]('config.yaml')
```

## TODO

This is a work in progress.

* Add the function `stringify`.
* Support `replacer` for `stringify` and `reviver` for `parse`.
* Add `marshal_*` functions.
* Enable support for arrays (bug [#18317]).

[VPM]: https://vpm.vlang.io/packages/prantlf.jany
[jany]: https://github.com/prantlf/v-jany
[json]: https://github.com/prantlf/v-json
[#18317]: https://github.com/vlang/v/issues/18317
