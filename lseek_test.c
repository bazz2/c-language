#include <stdio.h>
#include <fcntl.h>
#include <string.h>

#define BUFFSZ 1000

void main()
{
	int fd = open("hello", O_RDONLY);
	char buf[BUFFSZ];
	int ret;

	if (fd < 0)
		return;

	memset(buf, 0, BUFFSZ);
	read(fd, buf, 9);
	ret = lseek(fd, 0, SEEK_CUR);
	printf("1-> %d %s\n", ret, buf);

	lseek(fd, 2, SEEK_SET);
	memset(buf, 0, BUFFSZ);
	read(fd, buf, 2);
	ret = lseek(fd, 0, SEEK_CUR);
	printf("2-> %d %s\n", ret, buf);

	lseek(fd, 2, SEEK_CUR);
	memset(buf, 0, BUFFSZ);
	read(fd, buf, 3);
	ret = lseek(fd, 0, SEEK_CUR);
	printf("3-> %d %s\n", ret, buf);

	ret = lseek(fd, -8, SEEK_END);
	lseek(fd, ret, SEEK_SET);
	memset(buf, 0, BUFFSZ);
	read(fd, buf, 4);
	ret = lseek(fd, 0, SEEK_CUR);
	printf("4-> %d %s\n", ret, buf);

	ret = lseek(fd, -1, SEEK_CUR);
	lseek(fd, ret, SEEK_SET);
	memset(buf, 0, BUFFSZ);
	read(fd, buf, 4);
	ret = lseek(fd, 0, SEEK_CUR);
	printf("5-> %d %s\n", ret, buf);

	ret = lseek(fd, 0, SEEK_SET);
	memset(buf, 0, BUFFSZ);
	read(fd, buf, 4);
	ret = lseek(fd, 0, SEEK_CUR);
	printf("6-> %d %s\n", ret, buf);

	close(fd);
}
