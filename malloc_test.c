#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int test_malloc(char **str)
{
	*str = malloc(1024);
	strcpy(*str, "hello world");
	return 1;
}
int test_cpy(char *str)
{
	strcpy(str, "hello world");
	return 1;
}

int main()
{

	char *str = malloc(1024);
	test_cpy(str);
	printf("%s\n", str);


	free(str);
	return 0;
}
