all:
	gcc -o libhello.so hello.c --share -fPIC
	gcc main.c -ldl

install:
	cp libhello.so /usr/lib64
uninstall:
	rm -f /usr/lib64/libhello.so
clean:
	rm -f libhello.so
