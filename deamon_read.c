#include<sys/types.h>
#include<sys/stat.h>
#include<stdio.h>
#include<stdlib.h>
#include<fcntl.h>
#include<errno.h>
#include<unistd.h>
#include<syslog.h>
#include<string.h>

#define BUFFER_SIZE 2048

int main(int argc, int **argv)
{
	pid_t pid, sid;
	int i = 0;
	long timestamp;
	char buf[BUFFER_SIZE];
	if(argc < 2)
	{
		printf("Usage: %s <filename>\n", argv[0]);
		exit(1);
	}
	pid = fork();
	if(pid < 0)
	{
		exit(EXIT_FAILURE);
	}
	if(pid > 0)
	{
		exit(EXIT_SUCCESS);
	}

	umask(0);
	/* open a log here */
	
	sid = setsid();
	if(sid < 0)
	{
		exit(EXIT_FAILURE);
	}
	if((chdir("/opt/c-language/")) < 0)
	{
		exit(EXIT_FAILURE);
	}
	while(1)
	{
		FILE *fin = fopen((char*)argv[1], "r");
		if(!fin)
		{
			printf("child process cannot open file\n");
			exit(1);
		}
		buf[0] = '0';
		fread(buf, sizeof(char), BUFFER_SIZE, fin);
		fclose(fin);
		timestamp = time(NULL);
	//	printf("%s\n", ctime(&timestamp));
		printf("%s\n", buf);
		sleep(5);
	}
	exit(EXIT_SUCCESS);
}
