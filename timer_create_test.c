#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<string.h>
#include<pthread.h>
#include<signal.h>
#include<sys/time.h>

void sayHello()
{
	printf("Hello world!\n");
}

void main()
{
	struct itimerspec itime;
	timer_t timer_id;
	signal(SIGALRM, sayHello);
	timer_create(CLOCK_REALTIME, NULL, &timer_id);
	
	itime.it_value.tv_sec = 1;
	itime.it_value.tv_nsec = 0;
	itime.it_interval.tv_sec = 1;
	itime.it_interval.tv_nsec = 0;
	timer_settime(timer_id, 0, &itime, NULL);

	while(1);
}
