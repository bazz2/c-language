#include<stdio.h>
#include<dlfcn.h>

void main()
{
	void (*pHello)(void);
	void *sop;
	if(!(sop = dlopen("libhello.so", RTLD_NOW|RTLD_LOCAL))) {
		printf("oops, %s\n", dlerror());
		return;
	}
	dlerror();
	if (!(pHello = dlsym(sop, "hello"))) {
		printf("dlsym null\n");
		return;
	}
	pHello();
}
