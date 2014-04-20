#include <stdio.h>
#include <stdlib.h>
void main()
{
	int i = fork();
	int j = i;
	switch(i)
	{
		case -1:
			printf("fail to create child process\n");
			exit(0);
		case 0:
			(void) setsid();
			chdir("/");
			close(0);
			close(1);
			close(2);
			int childpid = getpid();
			FILE *fp = fopen("deamon_test", "w");
			fprintf(fp, "%d\n", childpid);
			fclose(fp);
			break;
		default:
			exit(0);
	}
	printf("this is deamon\n");
}
	
