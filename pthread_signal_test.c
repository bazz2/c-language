#include <pthread.h>
#include <signal.h>
#include <sys/types.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <errno.h>

void sig_handler(int signo)
{
	static int j = 0;
	pthread_t sig_ppid = pthread_self();

	if (signo == SIGALRM) {
		printf("### '%d' receive SIGARLM No.%d ###\n", sig_ppid, j);
		j++;
	} else if (signo == SIGKILL) {
		printf("### '%d' receive SIGKILL ###\n", sig_ppid);
	}
}
static void _thread_exit(pthread_t *thid)
{
	printf("%d exit\n", *thid);
}
void *sigmgr_thread()
{
	sigset_t set, old;
	siginfo_t info;
	int ret;
	pthread_t ppid = pthread_self();

	pthread_detach(ppid);

	sigemptyset(&set);
	sigaddset(&set, SIGALRM);
	pthread_cleanup_push(_thread_exit, &ppid);

	while (1) {
		pthread_testcancel();
		ret =  sigwaitinfo(&set, &info);
		if (ret != -1) {
			sig_handler(info.si_signo);
		} else {
			printf("sigwaitinfo() return err: %d(%s)\n", errno, strerror(errno));
		}
	}

	pthread_cleanup_pop(1);
}

int main()
{
	sigset_t set, old;
	int i;
	pid_t pid = getpid();
	pthread_t ppid[5];

#if 0
	sigemptyset(&set);
	sigaddset(&set, SIGALRM);
	pthread_sigmask(SIG_BLOCK, &set, &old);
#else
	/* block all sig */
	sigfillset(&set);
	pthread_sigmask(SIG_BLOCK, &set, &old);
#endif


	for (i = 0; i < 5; i++) {
		pthread_create(&ppid[i], NULL, sigmgr_thread, NULL);
		printf("create '%d'\n", ppid[i]);
	}

	for (i = 0; i < 10; i++) {
		if (i == 6) {
			pthread_cancel(ppid[0]);
			pthread_join(ppid[0], NULL);
		}
		pthread_kill(ppid[i%5], SIGALRM);
		printf("### main thread send SIGALRM No.%d ###\n", i);
		sleep(2);
	}
	exit(0);
}
