#include<stdio.h>

void main()
{
	FILE *fin = fopen("Schedule.xml", "r");
	if(!fin)
	{
		printf("cannot open file\n");
		exit(1);
	}

	char buf[1024] = {0};
	fread(buf, sizeof(char), 1024, fin);
	printf("%s\n\n", buf);
	fclose(fin);
}
