#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>

int main()
{
	int pfds[2];
	if(pipe(pfds) == 0)
	{
		if(fork() == 0) //child process, 
		{
			close(STDOUT_FILENO);
			dup2(pfds[1], STDOUT_FILENO);
			close(pfds[0]);
			execlp("ls", "ls", "-1", NULL);
		}
		else //parent process
		{
			close(0);
			dup2(pfds[0], 0);
			close(pfds[1]);
			execlp("wc", "wc", "-l", NULL);
		}
	}
	return 0;
}

