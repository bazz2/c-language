#include <stdio.h>

void main()
{
	FILE *fp = fopen("test.txt", "w");
	fprintf(fp, "osm {\n\t%s\n}\n", "hello world");
	fprintf(fp, "osm {\n\t%s\n}\n", "hello china");
	fclose(fp);
}
