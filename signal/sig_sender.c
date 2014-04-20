#include <stdio.h>
#include <signal.h>

int main(int argc, char **argv)
{
	int sig, i;
	pid_t pid;

	pid = atoi(argv[1]);

	for (i = 2; i < argc; i++) {
		sig = atoi(argv[i]);
		kill(pid, sig);
	}
}
