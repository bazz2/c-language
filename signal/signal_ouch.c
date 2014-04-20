#include <stdio.h>
#include <signal.h>

static void sig_handler(int sig)
{
	printf("Ouch, recv %d\n", sig);
}

void main()
{
	int j;

	if (signal(SIGINT, sig_handler) == SIG_ERR)
		return;

	for (j = 0; ; j++) {
		printf("%d\n", j);
		sleep(2);
	}
}
