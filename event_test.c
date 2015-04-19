#include <error.h>
#include <stdio.h>
#include <pthread.h>
#include <stdint.h>
#include <sys/epoll.h>

#define handle_error(msg) \
	do {perror(msg); exit(1);} while (0)

int main(int argc, char **argv)
{
	int evfd, epfd, j, ret;
	uint64_t u;
	ssize_t s;
	pid_t pid;

	if (argc < 2) {
		fprintf(stderr, "Usage: %s <num>...\n", argv[0]);
		exit(1);
	}

	evfd = eventfd(0, EFD_NONBLOCK);
	if (evfd == -1)
		handle_error("eventfd");

	epfd = epoll_create(10);
	if (epfd == -1)
		handle_error("epoll");

	struct epoll_event ev;
	ev.event = EPOLLIN;
	ev.data.fd = evfd;

	ret = epoll_ctl(epfd, EPOLL_CTL_ADD, evfd, &ev);
	if (ret < 0)
		handle_error("epoll_ctl");

	pid = fork();
	if (pid == 0) {
		sleep(3);
		for (j = 1; j < argc; j++) {
			printf("Child writing %s to efd\n", argv[j]);
			u = strtoull(argv[j], NULL, 0);
			s = write(evfd, &u, sizeof (uint64_t));
			if (s != sizeof (uint64_t))
				handle_error("write");
			sleep(1);
		}
		printf("Child completed write loop\n");
		exit(0);
	} else if (pid == -1){
		handle_error("fork");
	}

	struct epoll_event events[10];
	int fd, i;

	printf("Parent about to read\n");

	for (j = 1; j < argc; j++) {
		ret = epoll_wait(epfd, events, 10, -1);
		printf("get %d events\n", ret);

		for (i = 0; i < ret; i ++) {
			fd = events[i].data.fd;
			if ((events[i].events & EPOLLIN) && (fd == evfd)) {
				s = read(evfd, &u, sizeof (uint64_t));
				if (s != sizeof (uint64_t))
					handle_error("read");
				printf("Parent read %llu (0x%llx) from evfd\n",
					(unsigned long long)u,
					(unsigned long long)u);
			}
		}
	}

	ret = epoll_ctl(epfd, EPOLL_CTL_DELL, evfd, NULL);
	if (ret < 0)
		handle_error("epoll_ctl");
	wait();
	exit(0);
}
