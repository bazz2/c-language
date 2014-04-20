#include<stdio.h>
#include<string.h>

void main()
{
	char str[32] = "-1029.1qwe";
	char *ptr = str;
	while(*ptr < 58 && *ptr > 47)
		ptr++;
	*ptr = '\0';
	printf("%s\n", str);
}
