#include<stdio.h>
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

void sigpipe_fn(int signum)
{
	/* remote unpolite QUIT */
	printf("recv SIGPIPE\n");
}
void main()
{
	int send;
	struct attr humen;
	struct sigaction sigact;

	memset(&sigact, 0, sizeof (sigact));
	sigact.sa_handler = sigpipe_fn;
	sigfillset(&sigact.sa_mask);
	sigaction(SIGPIPE, &sigact, NULL);

	if(access(FIFO_NAME, F_OK) == -1)
	{
		if(mkfifo(FIFO_NAME, S_IFIFO|6060) == -1)
		{
			printf("mkfifo error!");
			return;
		}
	}
	mode_t old = umask(0);
	int fd = open(FIFO_NAME, O_WRONLY);
	umask(old);
	if(fd == -1)
	{
		printf("fopen error!");
		return;
	}

	memset(&humen, 0, sizeof(struct attr));
	strcpy(humen.name, "Ben");
	humen.age = 12;
	sleep(5);
again:
	send = write(fd, &humen, sizeof(struct attr));
	if (send == 0) {
		printf("connection is closed");
		return;
	}
	if (send < 0) {
		if (errno == EAGAIN || errno == EINTR)
			goto again;
		printf("write failed ret: %d err: %s\n", send, strerror(errno));
		return;
	}
	close(fd);
}
