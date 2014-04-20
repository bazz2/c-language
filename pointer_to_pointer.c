#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char g_str[20] = "hello world";

void main(void)
{
	char *p = g_str;

	printf("%s\n", p);
}
