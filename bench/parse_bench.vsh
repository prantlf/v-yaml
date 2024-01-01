#!/usr/bin/env -S v -prod -use-os-system-to-run run

import benchmark
import os
import prantlf.json
import prantlf.yaml

const repeats = 20

json_in := os.read_file('src/testdata/vlang.io.har.json')!
yaml_in := os.read_file('src/testdata/vlang.io.har.yaml')!

mut b := benchmark.start()

for _ in 0 .. repeats {
	json.parse(json_in)!
}
b.measure('parsing with prantlf.json')

for _ in 0 .. repeats {
	yaml.parse_text(yaml_in)!
}
b.measure('parsing with prantlf.yaml')
