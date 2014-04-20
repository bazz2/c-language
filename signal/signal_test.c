#include <signal.h>
#include <unistd.h>
#include <stdio.h>
#include <sys/time.h>

#if 0
void sigroutine(int signo) {
	printf("%d\n", signo);
	switch (signo) {
	case SIGALRM:
		printf("0123456789\n");
		break;
		}
	return;
}

int main() {
	struct itimerval value,ovalue;
	sigset_t mask;

	sigfillset(&mask);
	pthread_sigmask(SIG_BLOCK, &mask, NULL);

	printf("process id is %d\n",getpid());
	signal(SIGALRM, sigroutine);

	value.it_value.tv_sec = 1;
	value.it_value.tv_usec = 0;
	value.it_interval.tv_sec = 1;
	value.it_interval.tv_usec = 0;
	setitimer(ITIMER_REAL, &value, NULL);

	pause();
} 
#else

void print(int sig)
{
	printf("receive SIGLARM(%d)\n", sig);
}
int main()
{
	sigset_t set, old;
	int sig;

	while (1) {
		//sigemptyset(&set);
		//sigaddset(&set, SIGALRM);
		sigfillset(&set);
		pthread_sigmask(SIG_SETMASK, &set, &old);
		sigwait(&set, &sig);
		switch(sig) {
		case 14:
			print(sig);
			break;
		default:
			printf("receive sig %d\n", sig);
			break;
		}
		pthread_sigmask(SIG_SETMASK, &old, NULL);
	}
	return 0;
}
#endif
