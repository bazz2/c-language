#include <stdio.h>
#include <signal.h>

void handler(int sig)
{
	printf("recv %d\n", sig);
}

void main()
{
	int i;
	for (i = 1; i < NSIG; i++) {
		signal(i, handler);
	}

	
}
