#include<stdio.h>
#include<string.h>
#include<stdlib.h>
void main()
{
	char *str = NULL;
	str = realloc(str, sizeof(char));
	printf("%d\n", strlen(str));
	strcpy(str, "Hello");
	strcat(str, ":");
	printf("%s\n", str);
	free(str);
}
