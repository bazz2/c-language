#include <stdio.h>
#include <signal.h>

static void handler(int sig) {
	printf("%d\n",sig);
}

int main(int argc, char **argv)
{
	sigset_t pending_mask, blocking_mask, enpty_mask;

	sigfillset(&blocking_mask);
	if (sigprocmask(SIG_SETMASK, &blocking_mask, NULL) == -1)
		exit(1);

	printf("%s: sleeping for %d seconds\n", argv[0], nr_sec);
	sleep(nr_sec);

	if (sigpending(&pending_mask) == -1)
		exit(1);

	sigemptyset(&empty_mask);
}
