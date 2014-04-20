#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include "ioctl_test.h"

int main()
{
	char buf[20] = {0};
	int fd;
	int ret;
	
	fd = open("/dev/test", O_RDWR);
	if(fd < 0)
	{
		perror("open /dev/test");
		return -1;
	}
	
	write(fd, "xiao bai", 10);
	ioctl(fd, TEST_CLEAR);
	ret = read(fd, buf, 10);
	if(ret < 0)
	{
		perror("read /dev/test");
	}
	close(fd);
	return 0;
}
