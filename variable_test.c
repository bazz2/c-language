#include <stdio.h>
#include <string.h>

int main()
{
	int j = 10;
	char str[j];

	strcpy(str, "hello");
	printf("%s\n", str);

	return 1;
}
