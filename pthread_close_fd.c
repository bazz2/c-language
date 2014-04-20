#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <errno.h>

void *thread1(void *fd)
{
	char buf[10] = {0};
	if (5 != read(*(int*)fd, buf, 5)) {
		printf("Read err: %s\n", strerror(errno));
		return;
	}
	printf("%s\n", buf);
}

int main(void)
{
	pthread_t t_a;
	pthread_t t_b;
	int fd;

	fd = open("/etc/redhat-release", O_RDONLY);
	pthread_create(&t_a, NULL, thread1, &fd);
	pthread_join(t_a, NULL);
	close(fd);

	return 0;
}
