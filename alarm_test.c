#include <stdio.h>
#include <unistd.h>
#include <signal.h>

char user[40] = {0}; 
int timeout = 0;

void catch_alarm ( int sig_num)
{
	printf ("Sorry,time limit reached. \n"); 
	timeout = 1;
}

int main ( int argc , char *argv[] )
{
	signal ( SIGALRM, catch_alarm );
	alarm(2); 
	scanf("%s", user);
	if (timeout)
		printf("timeout!!!\n");
	printf("your username is = '%s' \n",user);
	alarm (0);
	return 0;
}
