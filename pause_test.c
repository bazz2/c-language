#include<unistd.h>
#include<stdio.h>
#include<signal.h>

void sigroutine(int unused)
{
	printf("exec the sigroutine function\n");
}

int main()
{
	signal(SIGINT, sigroutine);
	pause();
	printf("end the pause\n");
}
