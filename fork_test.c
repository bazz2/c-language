#include<stdio.h>

void main()
{
	int i;
	if(fork() == 0)
		for(i = 0; i < 50; i++)
			printf("child\n");
	else
		for(i = 0; i < 50; i++)
			printf("parent\n");
}
