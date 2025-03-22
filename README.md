# YAML Parser and Formatter

Strictly parse and format [YAML] data.

* Works [fast](#performance) leveraging [libyaml] written in C.
* Works with the `Any` type suitable for safe handling of [JSON]/[YAML] data.
* Allows unmarshalling the [YAML] contents to a static V type.

Uses [prantlf.jany]. See also the [prantlf.json] package and the [yaml2json] tool.

## Synopsis

```go
import prantlf.yaml { parse_file, parse_text }

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

You can install this package either from [VPM] or from GitHub:

```txt
v install prantlf.yaml
v install --git https://github.com/prantlf/v-yaml
```

You will usually need the `Any` type as well, either from [VPM] or from GitHub:

```txt
v install prantlf.jany
v install --git https://github.com/prantlf/v-jany
```

## API

The following functions are exported:

### parse_text(input string) !Any

Parses an input string in the YAML format to an `Any` value. See [jany] for more information about the `Any` type.

```go
input := r'
  answer: 42
'
any := parse_text(input)!
```

### parse_file(path string) !Any

Loads the contents of a text file in the YAML format and parses it to an `Any` value. See [jany] for more information about the `Any` type.

```go
any := parse_file('config.yaml')!
```

### unmarshal_text[T](input string, opts &UnmarshalOpts) !T

Unmarshals an input string in the YAML format to a new instance of `T`. See [jany] for more information about the `Any` type and the `UnmarshalOpts` struct.

```go
struct Config {
	answer int
}

input := r'
  answer: 42
'
config := unmarshal_text[Config](input, UnmarshalOpts{})!
```

### unmarshal_text_to[T](input string, mut obj T, opts &UnmarshalOpts) !

Unmarshals an input string in the YAML format to an existing instance of `T`. See [jany] for more information about the `Any` type and the `UnmarshalOpts` struct.

```go
struct Config {
	answer int
}

input := r'
  answer: 42
'
mut config := Config{}
config := unmarshal_text_to(input, mut config, UnmarshalOpts{})!
```

### unmarshal_file[T](path string, opts &UnmarshalOpts) !T

Loads the contents of a text file in the YAML format and unmarshals it to a new instance of `T`. See [jany] for more information about the `Any` type and the `UnmarshalOpts` struct.

```go
struct Config {
	answer int
}

config := unmarshal_file[Config]('config.yaml', UnmarshalOpts{})!
```

### unmarshal_file_to[T](path string, mut obj T, opts UnmarshalOpts) !

Loads the contents of a text file in the YAML format and unmarshals it to an existing instance of `T`. See [jany] for more information about the `Any` type and the `UnmarshalOpts` struct.

```go
struct Config {
	answer int
}

mut config := Config{}
config := unmarshal_file_to('config.yaml', mut config, UnmarshalOpts{})!
```

## Performance

This module is only 2.6x slower than `prantlf.json` when parsing more complicated input:

    ❯ ./parse_bench.vsh

    SPENT   271.321 ms in parsing with prantlf.json
    SPENT   708.940 ms in parsing with prantlf.yaml

## Contributing

In lieu of a formal styleguide, take care to maintain the existing coding style. Lint and test your code.

## License

Copyright (c) 2023-2025 Ferdinand Prantl

Licensed under the MIT license.

[VPM]: https://vpm.vlang.io/packages/prantlf.yaml
[prantlf.jany]: https://github.com/prantlf/v-jany
[prantlf.json]: https://github.com/prantlf/v-json
[yaml2json]: https://github.com/prantlf/v-yaml2json
[libyaml]: https://github.com/yaml/libyaml/
[JSON]: https://www.json.org/
[YAML]: https://yaml.org/
