all: check test

check:
	v fmt -w .
	v vet .

test:
	NO_COLOR=1 v -use-os-system-to-run test .

clean:
	rm -rf src/*_test src/*.dSYM
