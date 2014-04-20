#include<stdio.h>
#include<stdlib.h>
#include<signal.h>
#include<memory.h>
#include<sys/stat.h>
#include<sys/types.h>
#include<fcntl.h>
#include<errno.h>

#define FIFO_NAME "osncdp.fifo"

struct attr {
	char name[50];
	int age;
};
int timeout = 0;

void sigalarm_fn(int signum)
{
	printf("Recv SIGALRM\n");
	timeout = 1;
//	exit(0);
}
void main()
{
	struct attr humen;
	int ret;
	struct sigaction sigact;

	memset(&sigact, 0 ,sizeof (sigact));
	sigact.sa_handler = sigalarm_fn;
	sigfillset(&sigact.sa_mask);
	sigaction(SIGALRM, &sigact, NULL);

	if(access(FIFO_NAME, F_OK) == -1)
	{
		if(mkfifo(FIFO_NAME, S_IFIFO|6060) == -1)
		{
			printf("mkfifo error!");
			return;
		}
	}
	mode_t old = umask(0);
	int fd = open(FIFO_NAME, O_RDONLY);
	umask(old);
	if(fd == -1)
	{
		printf("fopen error!");
		return;
	}

	while(1)
	{
		ret = 0;
		memset(&humen, 0, sizeof(struct attr));
		alarm(1);
		ret = read(fd, &humen, sizeof(struct attr));
		if (timeout) {
			printf("Timeout (%s)!!\n", strerror(errno));
			exit(0);
		}
		if(ret > 0) {
			printf("Name: %s\n", humen.name);
			printf("age: %d\n", humen.age);
			return;
		} if (ret < 0) {
			if (errno == EINTR)
				continue;
			if (errno == EAGAIN )
				continue;

			printf("read failed: %d, err: %s", ret, strerror(errno));
			return;
		}
	}
	close(fd);
}
