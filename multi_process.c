#include <stdio.h>
#include <stdlib.h>

int g_int = -1;
struct hand {
	int i;
};

void main()
{
	int pid;
	struct hand *g_hand;

	g_hand = calloc(1, sizeof (*g_hand));
	g_hand->i = 1000;

again:
	pid = fork();
	switch(pid) {
	case -1:
		printf("Failed to fork()\n");
		exit(1);
	case 0: /* child */
		g_int = 0;
//		printf("g_int in child: %d\n", g_int);
		g_hand->i = 200;
		printf("g_hand in child: %d\n", g_hand->i);
		exit(0);
		break;
	default:
//		printf("g_int in parent: %d\n", g_int);
		printf("g_hand in parent: %d\n", g_hand->i);
		break;
	}

	printf("=== g_hand: %d\n", g_hand->i);

	sleep(5);
	goto again;
}
