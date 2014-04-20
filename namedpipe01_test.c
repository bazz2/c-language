#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/stat.h>
#include<sys/types.h>
#include<fcntl.h>
#include<memory.h>

#define FIFO_NAME "myfifo01"
#define BUF_SIZE 1024

void main()
{
	int fd, readfig;
	char buf[BUF_SIZE];
	
	if(access(FIFO_NAME, F_OK) == -1)
	{
		if(mkfifo(FIFO_NAME, S_IFIFO|6060) == -1)
		{
			perror("mkfifo error!");
			exit(1);
		}
	}

	while(1)
	{
		fd = open(FIFO_NAME, O_RDONLY);
		if(fd == -1)
		{
			perror("fopen error!");
			exit(1);
		}
		memset(buf, 0, sizeof(buf));
		if((readfig = read(fd, buf, BUF_SIZE)) > 0)
		{
			printf("Read content: %s\n", buf);
		}
		printf("%d\n",readfig);
		close(fd);
	}
}
