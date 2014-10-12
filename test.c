#include <stdio.h>

int main()
{
	char str[5] = {0};
	char str2[5] = {0};

	strcpy(str, "hello world");
	printf("%s\n", str);
	printf("%s\n", str2);
}
