#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<fcntl.h>

int read_line(int fd, char *buf)
{
	static FILE *fp = fdopen(fd, "r");

	fgets(buf, 256, fp);
}

void main(int argc, char **argv)
{
	int fd, i;
        char buffer[256];

	fd = open("test", O_RDONLY);

	for (i = 0; i < 10; i++) {
		read_line(fd, buffer);
		printf("%s", buffer);
	}
}
