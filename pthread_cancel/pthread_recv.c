#include <pthread.h>
#include <arpa/inet.h>
#include <linux/un.h>
#include <stdio.h>
#include <string.h>
#include <memory.h>
#include <stdlib.h>

pthread_t recv_thid = 0;
#define UNIX_SOCK  "unix.sock"

void *timeout_thread(void *junk)
{
	printf("[timeout_thread] sleep 5 sec...\n");
	sleep(1);
	printf("[timeout_thread] sleep 4 sec...\n");
	sleep(1);
	printf("[timeout_thread] sleep 3 sec...\n");
	sleep(1);
	printf("[timeout_thread] sleep 2 sec...\n");
	sleep(1);
	printf("[timeout_thread] sleep 1 sec...\n");
	sleep(1);
	if (recv_thid) {
		printf("[timeout_thread] cancel recv_thread(id: %d)\n", recv_thid);
		pthread_cancel(recv_thid);
	}
	return NULL;
}

void *send_thread(void *junk)
{
	int ret, sockfd;
	struct sockaddr_un daemon_addr;
	struct timeval timeout;
	int time_len;
	char buf[512];

	printf("{send_thread} sleep(8).. \n");
	sleep(8);
	memset(&daemon_addr, 0, sizeof (daemon_addr));
	daemon_addr.sun_family = AF_LOCAL;
	strncpy(daemon_addr.sun_path, UNIX_SOCK,
		sizeof (daemon_addr.sun_path) - 1);

	sockfd = socket(AF_LOCAL, SOCK_STREAM, 0);

	time_len = sizeof (timeout);
	memset(&timeout, 0, time_len);
	timeout.tv_sec = 40;
	setsockopt(sockfd, SOL_SOCKET, SO_SNDTIMEO, (void*)&timeout, time_len);
	setsockopt(sockfd, SOL_SOCKET, SO_RCVTIMEO, (void*)&timeout, time_len);

	connect(sockfd, (struct sockaddr*)&daemon_addr, sizeof (daemon_addr));

	strcpy(buf, "hello world");
	printf("{send_thread} send '%s' to recv_thread\n", buf);
	sleep(10);
	write(sockfd, buf, NULL);
	close (sockfd);
	printf("{send_thread} die\n");
	return NULL;
}

void *recv_thread(void *junk)
{
	char buf[512];
	int unixfd =0, acceptfd = 0;
	socklen_t addrlen;
	struct sockaddr_un this_addr;
	struct sockaddr *peeraddr = NULL;

	pthread_setcanceltype(PTHREAD_CANCEL_DEFERRED, NULL);

	printf("{recv_thread} thid: %d\n", pthread_self());
	unlink(UNIX_SOCK);
	unixfd = socket(AF_UNIX, SOCK_STREAM, 0);
	memset(&this_addr, 0, sizeof (this_addr));
	this_addr.sun_family = AF_UNIX;
	strcpy(this_addr.sun_path, UNIX_SOCK);
	bind(unixfd, (struct sockaddr*)&this_addr, sizeof (this_addr));
	listen(unixfd, 1);

	/* sleep() is a cancellation point,
	 * so i need disable cancelstate to let thread run
	 * to pthread_testcancel() function */
	pthread_setcancelstate(PTHREAD_CANCEL_DISABLE, NULL);
	printf("{recv_thread} sleep(7)...\n");
	sleep(7);
	printf("{recv_thread} testcancel #1\n");
	pthread_testcancel();
	printf("{recv_thread} accept()...\n");
	acceptfd = accept(unixfd, peeraddr, &addrlen); /* accept is a cacenlation point, too */
	sleep(10);
	pthread_setcancelstate(PTHREAD_CANCEL_ENABLE, NULL);
	printf("{recv_thread} read()...\n");
	read(acceptfd, buf, 512); /* read also is a cancellation point */
	printf("{recv_thread} recv %s\n", buf);
	printf("{recv_thread} write()...\n");
	write(acceptfd, buf, 512); /* read also is a cancellation point */

	printf("{recv_thread} testcancel #2\n");
	pthread_testcancel();
	printf("{recv_thread} die\n");
	return NULL;
}

int main(void)
{
	pthread_t timeout_thid;
	pthread_t send_thid;
	pthread_create(&timeout_thid, NULL, timeout_thread, (void*)NULL);
	pthread_create(&recv_thid, NULL, recv_thread, (void*)NULL);
	pthread_create(&send_thid, NULL, send_thread, (void*)NULL);
	pthread_join(timeout_thid, NULL);
	pthread_join(recv_thid, NULL);

	return 0;
}
