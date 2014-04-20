#include<stdio.h>
#include<string.h>
#include<errno.h>

void main()
{
#if 1
	char *path = "/tmp/a";
#else
	char *path = NULL;
#endif
	if(access(path, 0) == -1)
		printf("%s not exist: %s\n", path, strerror(errno));
	else
		printf("%s exist\n", path);
}
