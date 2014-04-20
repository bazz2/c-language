#include<stdio.h>
#include<unistd.h>
#include<sys/stat.h>

void main()
{
	char path[50] = "/dev/VG01/base";
	struct stat info;
        stat(path, &info);
        if(S_ISREG(info.st_mode))
		printf("rerular file\n");
	else if (S_ISLNK(info.st_mode))
		printf("link file\n");
	else if (S_ISBLK(info.st_mode))
		printf("block file\n");
}
