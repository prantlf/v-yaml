# Changes

## [0.2.2](https://github.com/prantlf/v-yaml/compare/v0.2.1...v0.2.2) (2024-11-16)

### Bug Fixes

* Fix sources for the new V compiler ([8c4a27d](https://github.com/prantlf/v-yaml/commit/8c4a27d8c3aefa337bd7596cda87d1d23e3e38a4))

## [0.2.1](https://github.com/prantlf/v-yaml/compare/v0.2.0...v0.2.1) (2024-01-28)

### Bug Fixes

* Fix sources for the new V compiler ([34e9c2a](https://github.com/prantlf/v-yaml/commit/34e9c2a7c3fe1ddc3fe573606cca5f3096dd4597))

## [0.2.0](https://github.com/prantlf/v-yaml/compare/v0.1.2...v0.2.0) (2024-01-01)

### Features

* Remove options from unmarshal_text and unmarshal_file ([a069880](https://github.com/prantlf/v-yaml/commit/a06988019fc7c8af053ebaba8b0de9d5a997ea89))

### BREAKING CHANGES

If you just pass default options to the functions,
just delete them. They do not expect options any more. If you use
non-empty options, replace the function name with `<name>_opt`,
which supports options.

## [0.1.2](https://github.com/prantlf/v-yaml/compare/v0.1.1...v0.1.2) (2023-12-11)

### Bug Fixes

* Adapt for V langage changes ([16d8c86](https://github.com/prantlf/v-yaml/commit/16d8c8681c149326e6169732f4242b59d7ea4e8f))

## [0.1.1](https://github.com/prantlf/v-yaml/compare/v0.1.0...v0.1.1) (2023-09-09)

### Bug Fixes

* Work around broken enums in anon structs in new v ([53ade3b](https://github.com/prantlf/v-yaml/commit/53ade3b88781a087351dad9d38193e05e6d62a18))

## [0.1.0](https://github.com/prantlf/v-yaml/compare/v0.0.4...v0.1.0) (2023-08-15)

### Features

* Add unmarshal_to to modify an existing object ([3aad9ec](https://github.com/prantlf/v-yaml/commit/3aad9ec2cdfdef79d2bd5957ce663919292179f3))

## [0.0.4](https://github.com/prantlf/v-yaml/compare/v0.0.3...v0.0.4) (2023-06-08)

### Bug Fixes

* Upgrade `jany` dependency ([13fcab1](https://github.com/prantlf/v-yaml/commit/13fcab1edd903cc750e3b52ec7cdbe10b1d62e5e))

## [0.0.3](https://github.com/prantlf/v-yaml/compare/v0.0.2...v0.0.3) (2023-06-06)

### Bug Fixes

* Fix the dependency on `jany` ([57dcc4d](https://github.com/prantlf/v-yaml/commit/57dcc4d84813fab13ecdc50d36d7a2557ce7ce86))

## [0.0.2](https://github.com/prantlf/v-yaml/compare/v0.0.1...v0.0.2) (2023-06-06)

### Chores

* Rename `jsany` to `jany` ([3e9a2eb](https://github.com/prantlf/v-yaml/commit/3e9a2eb656b96a414849ffa92307a954e29b85ab))

### BREAKING CHANGES

* The type Any is imported from `prantlf.jany` instead of from `pratlf.jsany`. You have to rename the import module name in your sources.

## 0.0.1 (2023-06-06)

Initial release.
