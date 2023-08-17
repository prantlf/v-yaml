all: check test

check:
	v fmt -w .
	v vet .

test:
	NO_COLOR=1 v test .

clean:
	rm -rf src/*_test src/*.dSYM
