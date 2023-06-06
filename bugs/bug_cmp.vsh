#!/usr/bin/env -S v run

f1 := f64(9.1)
f2 := f32(f1)
f3 := f64(f2)

println('f1 == f2: ${f1 == f2}, f2 == f3: ${f2 == f3}, f1 == f3: ${f1 == f3}')
println('f1 - f2: ${f1 - f2}, f3 - f2: ${f3 - f2}, f1 - f3: ${f1 - f3}')
