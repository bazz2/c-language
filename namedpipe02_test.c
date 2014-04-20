#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<sys/stat.h>
#include<sys/types.h>
#include<fcntl.h>

#define FIFO_NAME "myfifo01"
#define BUF_SIZE 1024

void main()
{
	int fd;
	char buf[BUF_SIZE] = "Hello, I'm from namepipe02\n";
	
	if((fd = open(FIFO_NAME, O_WRONLY)) == -1)
	{
		perror("fopen error!");
		exit(1);
	}
	write(fd, buf, strlen(buf)+1);
	close(fd);
	//unlink(FIFO_NAME); //delete pipe "FIFO_NAME"
	exit(0);
}
