#include <stdio.h>

#define container_of(ptr, type, member) ({ \
const typeof(((type *)0)->member) *__mptr = (ptr); \
(type *)((char *)__mptr - offsetof(type, member));})


void main()
{
	struct A {
		int *ptr_a;
	};
	struct B {
		int int_b;
	};
	typedef struct B structB;
	struct A a;
	struct B b;
	struct B *ptr_B;
	b.int_b = 3;
	a.ptr_a = &b.int_b;

	ptr_B = container_of(a.ptr_a, structB, int_b);
	printf("%d\n", ptr_B->int_b);
}
