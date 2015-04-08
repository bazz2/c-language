#include <stdio.h>
#include <string.h>


void main()
{
	char *file;
	const char *url = "ftp:10.7.0.15pmC20141224.1500-20141224.1600_FFFFFF-80000001.xml/";
	file = strrchr(url, '/')+1;
	printf("file: %s(%c)\nurl: %s\n", file, *file, url);
}
