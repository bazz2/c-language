#include <stdio.h>
#include <string.h>

void main()
{
	char name[512] = {0};
	char name2[512] = {0};
	char *name3 = NULL;

	strcpy(name2, "hello");
	name[0] = -10;
	printf("name: %s name2: %s name3: %s\n", name, name2, name3);
}
