#include<stdio.h>
#include<stdlib.h>
#include<string.h>

struct cdp_s {
	char *name;
};

void main()
{
	char *tmp = NULL;
	if (!strcmp(tmp, "mon"))
		printf("mon\n");
	else
		printf("no\n");
}
