#include<stdio.h>

void main()
{
	FILE *fp = fopen("Schedule.xml", "r");
	fseek(fp, 0, SEEK_END);
	unsigned long filesize = ftell(fp);
	rewind(fp);
	char *content = (char*)malloc(filesize+1);
	memset(content, 0, filesize+1);
	fread(content, 1, filesize, fp);
	close(fp);
	printf("content:\n\t%s\n", content);
}
