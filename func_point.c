#include <stdio.h>
#include <stdlib.h>
#include <memory.h>

struct funcs {
	int type;
	union {
		int (*fun1) (void);
		void (*fun2) (const char*);
	};
	int soso;
};

int print_hello(void)
{
	printf("hello\n");
	return 1000;
}

void print_world(const char *str)
{
	printf("world: %s\n", str);
}

int main()
{
	int ret;
	struct funcs *f1, *f2;

	f1 = calloc(1, sizeof (struct funcs));
	f2 = calloc(1, sizeof (struct funcs));

	f1->fun1 = &print_hello;
	f2->fun2 = &print_world;
	f2->type = 100;

	ret = f1->fun1();
	f2->fun2("2014");

	printf("fun1 return %d\n", ret);

	return 0;
}
